{ config, pkgs, ... }:

{
    home.username = "ramo";
    home.homeDirectory = "/home/ramo";
    home.stateVersion = "26.05";

    home.file.".config/awesome".source = ./config/awesome;
    home.file.".config/vim".source = ./config/vim;

    imports = [
        ./zsh_config.nix
    ];


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
    
  programs.git = {
      enable = true;
      settings = {
          user = {
              name = "Aaro Karhu";
              email = "aaro.karhu19@gmail.com";
          };
          init.defaultBranch = "main";
      }; 
  };
}
