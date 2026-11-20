{ config, lib, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ../../imports/printer.nix
    ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.kernelParams = [ 
    "acpi_osi=Linux"
    "acpi_backlight=vendor"
  ];

  # Allow unfree packages (required for Steam, NVIDIA drivers, etc.)
  nixpkgs.config.allowUnfree = true;

  # Enable Zsh system-wide so it gets added to /etc/shells
  programs.zsh.enable = true;
  programs.steam = {
    enable = true;
  };

  programs.nix-ld.enable = true;

  networking.hostName = "nixos-btw";
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Asia/Hong_Kong";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";
  console.keyMap = "fi";

  # Keep xserver enabled so xkb.layout applies to Wayland/COSMIC as well
  services.xserver = {
    enable = true;
    xkb.layout = "fi";
    # xkb.options = "eurosign:e,caps:escape";
  };

  # Display Manager & COSMIC Desktop
  services.displayManager = {
    cosmic-greeter.enable = true;
    defaultSession = "cosmic";
  };

  services.desktopManager.cosmic.enable = true;
  services.system76-scheduler.enable = true;

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound via PipeWire.
  services.pipewire = {
    enable = true;
    pulse.enable = true;
  };

  # Define a user account.
  users.users.ramo = {
    isNormalUser = true;
    extraGroups = [ "wheel" ];
    shell = pkgs.zsh;
    packages = with pkgs; [
      tree
    ];
  };

  programs.firefox.enable = true;

  environment.systemPackages = with pkgs; [
    vim
    wget
    git
    alacritty
    zip
    unzip
    acpi
    htop
    fd
    tlp
    direnv
    wl-clipboard # Wayland replacement for xclip
    cosmic-ext-applet-minimon
    discord

    # Standalone Lua packages (kept without AwesomeWM)
    lua
    luarocks
  ];

  i18n.inputMethod = {
    enable = true;
    type = "fcitx5";
    fcitx5 = {
      waylandFrontend = false;
      addons = with pkgs; [
        qt6Packages.fcitx5-chinese-addons
        fcitx5-gtk
        fcitx5-rime
        rime-data
      ];
    };
  };

  fonts.packages = with pkgs; [
    nerd-fonts.jetbrains-mono
  ];

  services.upower.enable = true;

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  system.stateVersion = "26.05";
  
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 30d";
  };

  nix.settings.auto-optimise-store = true;
}
