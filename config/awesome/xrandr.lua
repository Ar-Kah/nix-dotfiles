--------------------------------------------------------------------------------
-- Multi-monitor / display helper for AwesomeWM
--
-- This module gives you two things, both driven from rc.lua:
--
--   1. apply_layout()  - applies your preferred display arrangement. rc.lua
--                        calls this on startup, so your monitors are configured
--                        automatically every time Awesome (re)starts.
--
--   2. xrandr()        - interactive cycler. Bind it to a key to step through
--                        every possible arrangement of the currently connected
--                        outputs via a popup, then auto-apply the chosen one.
--                        (Based on the official https://awesomewm.org/recipes/xrandr/)
--------------------------------------------------------------------------------

local awful   = require("awful")
local naughty = require("naughty")
local gtable  = require("gears.table")

local module = {}

--------------------------------------------------------------------------------
-- 1. Preferred layouts, applied automatically on startup
--------------------------------------------------------------------------------
-- Nothing is hardcoded to a specific dock: we read the connected outputs from
-- `xrandr -q` at runtime and treat the built-in panel (eDP*) as the laptop and
-- everything else as an external monitor. This works the same on the office
-- DisplayLink dock (DVI-I-* outputs), the home Thunderbolt dock (DP-1-3-*
-- outputs), or with no dock at all.
module.laptop_pattern = "^eDP"

-- Connected output names, parsed from `xrandr -q`, in xrandr's own order.
local function connected_outputs()
    local out = {}
    local handle = io.popen("xrandr -q --current")
    if handle then
        for line in handle:lines() do
            local output = line:match("^([%w-]+) connected ")
            if output then
                out[#out + 1] = output
            end
        end
        handle:close()
    end
    return out
end

local function is_laptop(name)
    return name:match(module.laptop_pattern) ~= nil
end

-- Split the connected outputs into externals and laptop panel(s).
local function classify()
    local externals, laptops = {}, {}
    for _, o in ipairs(connected_outputs()) do
        if is_laptop(o) then
            laptops[#laptops + 1] = o
        else
            externals[#externals + 1] = o
        end
    end
    return externals, laptops
end

-- Laptop only: built-in panel primary, every external output off. The "off"
-- list is built from what's actually connected, so we never name an output
-- xrandr doesn't know about (which would abort the whole command).
function module.apply_laptop()
    local externals, laptops = classify()
    local laptop = laptops[1] or "eDP-1-1"
    local cmd = "xrandr --output " .. laptop .. " --auto --primary"
    for _, o in ipairs(externals) do
        cmd = cmd .. " --output " .. o .. " --off"
    end
    awful.spawn.with_shell(cmd)
end

-- Dock: every connected external monitor on, laid out left-to-right with the
-- first one primary, and the laptop panel off. Uses --auto, i.e. each monitor's
-- highest/preferred mode. If a high-refresh monitor on a shared dock link
-- flickers, drop its rate by hand, e.g.:
--   xrandr --output DP-1-3-3 --mode 2560x1440 --rate 60
function module.apply_dock()
    local externals, laptops = classify()
    if #externals == 0 then
        -- Nothing external is actually connected; don't black-screen.
        module.apply_laptop()
        return
    end
    local cmd = "xrandr"
    for i, o in ipairs(externals) do
        cmd = cmd .. " --output " .. o .. " --auto"
        if i == 1 then
            cmd = cmd .. " --primary"
        else
            cmd = cmd .. " --right-of " .. externals[i - 1]
        end
    end
    for _, o in ipairs(laptops) do
        cmd = cmd .. " --output " .. o .. " --off"
    end
    awful.spawn.with_shell(cmd)
end

-- Startup default: always the laptop panel. Auto-docking caused more trouble
-- than it was worth (DisplayLink resolution races on the office dock, shared-MST
-- bandwidth flicker on the home dock), so external monitors are now opt-in:
-- press Mod4+Ctrl+D (or use the Display menu) when you actually want them.
-- Defaulting to the built-in panel can never black-screen.
function module.apply_layout()
    module.apply_laptop()
end

--------------------------------------------------------------------------------
-- 2. Interactive arrangement cycler (awesomewm.org/recipes/xrandr)
--------------------------------------------------------------------------------

-- Get active outputs (shared with the startup layout logic above).
local function outputs()
    return connected_outputs()
end

-- Enumerate every ordered combination of the connected outputs.
local function arrange(out)
    local choices  = {}
    local previous = { {} }
    for _ = 1, #out do
        local new = {}
        for _, p in pairs(previous) do
            for _, o in pairs(out) do
                if not gtable.hasitem(p, o) then
                    new[#new + 1] = gtable.join(p, { o })
                end
            end
        end
        choices  = gtable.join(choices, new)
        previous = new
    end
    return choices
end

-- Build the list of { label, xrandr-command } choices.
local function menu()
    local m       = {}
    local out     = outputs()
    local choices = arrange(out)

    for _, choice in pairs(choices) do
        local cmd = "xrandr"
        -- Enabled outputs (laid out left to right).
        for i, o in pairs(choice) do
            cmd = cmd .. " --output " .. o .. " --auto"
            if i > 1 then
                cmd = cmd .. " --right-of " .. choice[i - 1]
            end
        end
        -- Disabled outputs.
        for _, o in pairs(out) do
            if not gtable.hasitem(choice, o) then
                cmd = cmd .. " --output " .. o .. " --off"
            end
        end

        local label = ""
        if #choice == 1 then
            label = 'Only <span weight="bold">' .. choice[1] .. '</span>'
        else
            for i, o in pairs(choice) do
                if i > 1 then label = label .. " + " end
                label = label .. '<span weight="bold">' .. o .. '</span>'
            end
        end

        m[#m + 1] = { label, cmd }
    end

    return m
end

-- Cycle through the choices: each keypress shows the next option in a popup,
-- and the option stays applied if you stop pressing for `timeout` seconds.
local state = { cid = nil }

local function naughty_destroy_callback(reason)
    local actions = { naughty.notificationClosedReason.expired,
                      naughty.notificationClosedReason.dismissedByUser }
    if gtable.hasitem(actions, reason) then
        local action = state.index and state.menu[state.index - 1][2]
        if action then
            awful.spawn(action, false)
            state.index = nil
        end
    end
end

function module.xrandr()
    -- Build the list of choices on first invocation.
    if not state.index then
        state.menu  = menu()
        state.index = 1
    end

    -- Select one and display the appropriate notification.
    local label, action
    local next_choice = state.menu[state.index]
    state.index = state.index + 1

    if not next_choice then
        label = "Keep the current configuration"
        state.index = nil
        action = nil
    else
        label, action = next_choice[1], next_choice[2]
    end

    state.cid = naughty.notify({
        text        = label,
        timeout     = 4,
        screen      = mouse.screen, -- not all screens may be visible
        replaces_id = state.cid,
        destroy     = naughty_destroy_callback,
    }).id
end

return module
