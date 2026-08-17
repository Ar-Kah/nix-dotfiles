{ config, lib, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ./zsh_config
    ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.kernelParams = [ "acpi_osi=Linux" "acpi_backlight=vendor" ];

  networking.hostName = "nixos-btw"; # Define your hostname.

  # Configure network connections interactively with nmcli or nmtui.
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Europe/Helsinki";

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
      windowManager.awesome = {
	enable = true;
	luaModules = with pkgs.luaPackages; [
	  luarocks
	  luadbi-mysql
	  awesome-wm-widgets	    
	  luautf8
        ];
      };
      displayManager = {
	sddm.enable = true;
	defaultSession = "none+awesome";
      };
  };
  

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
    acpi
    htop
    fd
    tlp
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

  programs.zsh = {
      enable = true;
      enableCompletion = true;
      autosuggestions.enable = true;
      syntaxHighlighting.enable = true;

      shellAliases = {
          ll = "ls -l";
          edit = "sudo -e";
          update = "sudo nixos-rebuild switch";
      };

      histSize = 10000;
      histFile = "$HOME/.zsh_history";
      setOptions = [
          "HIST_IGNORE_ALL_DUPS"
      ];
  };
}

