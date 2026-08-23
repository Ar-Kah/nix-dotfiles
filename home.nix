{ config, pkgs, ... }:

{
    home.username = "ramo";
    home.homeDirectory = "/home/ramo";
    home.stateVersion = "26.05";

    home.file.".config/awesome".source = ./config/awesome;
    home.file.".config/vim".source = ./config/vim;
    home.file.".config/doom".source = ./config/doom;

    home.sessionPath = [
        "$HOME/.config/emacs/bin"
    ];

    imports = [
        ./zsh_config.nix
    ];

    # Start emacs on startup
    services.emacs = {
      enable = true;
      client.enable = true; # Creates emacsclient desktop launchers
    };

    home.packages = with pkgs; [
        ripgrep
        emacs
        nil
        nixpkgs-fmt
        nodejs
        gcc

        # dependencies for vterm in doom emacs
        cmake
        gnumake
        libtool

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
