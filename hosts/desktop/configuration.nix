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
    remotePlay.openFirewall = true;
    dedicatedServer.openFirewall = true;
  };

  hardware.graphics = {
      enable = true;
      enable32Bit = true;
  };

  services.xserver.videoDrivers = [ "nvidia" ];

  hardware.nvidia = {
      # Modesetting is required for modern desktop environments and Wayland
      modesetting.enable = true;

      # Enable the NVIDIA GUI control panel (nvidia-settings)
      nvidiaSettings = true;

      # Option to select the driver package (stable, beta, production, legacy, etc.)
      package = config.boot.kernelPackages.nvidiaPackages.stable;

      # Enable open-source kernel module (NOT Nouveau)
      # Set to true for Turing or newer GPUs (GTX 16xx, RTX 20xx and newer)
      # Set to false for older GPUs (GTX 10xx and older)
      open = false;

      # Power management options (set to true if you encounter sleep/suspend issues)
      powerManagement.enable = false;
      powerManagement.finegrained = false;
  };
  programs.nix-ld.enable = true;

  networking.hostName = "nixos-btw"; # Define your hostname.

  # Configure network connections interactively with nmcli or nmtui.
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Asia/Hong_Kong";

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";
  console.keyMap = "fi";

services.xserver = {
      enable = true;
      autoRepeatDelay = 200;
      autoRepeatInterval = 35;
      
      # --- Commented out Awesome WM ---
      # windowManager.awesome = {
      #   enable = true;
      #   luaModules = with pkgs.luaPackages; [
      #     luarocks
      #     luadbi-mysql
      #     awesome-wm-widgets      
      #     luautf8
      #   ];
      # };

      # --- Enable the GNOME Desktop Environment and GDM ---
      displayManager.gdm = {
          enable = true;
          wayland = false;
      };
      desktopManager.gnome.enable = true;
  };

  # --- Commented out SDDM ---
  # services.displayManager = {
  #   sddm.enable = true;
  #   defaultSession = "none+awesome";
  # };

  # Configure keymap in X11
  services.xserver.xkb.layout = "fi";
  # services.xserver.xkb.options = "eurosign:e,caps:escape";

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound.
  # services.pulseaudio.enable = true;
  # OR
  # services.pipewire = {
  #   enable = true;
  #   pulse.enable = true;
  # };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.ramo = {
    isNormalUser = true;
    extraGroups = [ "wheel" ]; # Enable ‘sudo’ for the user.
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
    alacritty # My terminal
    zip
    unzip
    acpi
    htop
    fd
    tlp
    direnv # added for ein working with nix-shell

    # xclip is needed for screenshotting script
    xclip
    
    # download discord for the desktop environment
    discord
  ];
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

