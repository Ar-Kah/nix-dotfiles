{ config, pkgs, ... }:

{
    home.username = "ramo";
    home.homeDirectory = "/home/ramo";
    programs.git.enable = true;
    home.stateVersion = "26.05";
    programs.bash = {
        enable = true;
        shellAliases = {
            btw = "echo I use nixos btw";
        };
    };

    home.file.".config/awesome".source = ./config/awesome;
    home.file.".config/vim".source = ./config/vim;


    # Add path to doom emacs binaries
    home.sessionPath = [
        "$HOME/.config/emacs/bin"
    ];
    home.packages = with pkgs; [
        ripgrep
        emacs
        nil
        nixpkgs-fmt
        nodejs
        gcc

        # awesomewm themes dependencies
        alsa-utils
        dmenu
        librewolf
        mpc
        mpd
        scrot
        unclutter
        xbacklight
        xsel
        slock
    ];
}
