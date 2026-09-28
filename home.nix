{ config, pkgs, ... }:

{
    home.username = "ramo";
    home.homeDirectory = "/home/ramo";
    home.stateVersion = "26.05";

    # Create symlinks between nixos-dotfiles and the normal paths
    home.file.".config/awesome".source = ./config/awesome;
    home.file.".config/vim".source = ./config/vim;
    home.file.".config/doom".source = ./config/doom;
    home.file.".local/bin".source = ./local/bin;

    home.sessionPath = [
        "$HOME/.config/emacs/bin"
        "$HOME/.local/bin"
    ];

    imports = [
        ./imports/zsh.nix # custom shell environment
        ./imports/python.nix
    ];

    # Start emacs on startup
    services.emacs = {
      enable = true;
      client.enable = true; # Creates emacsclient desktop launchers
    };

    home.packages = with pkgs; [
        # --- Doom Emacs Core & Search Tools ---
        ripgrep                   # Fast text searching (used by Doom Vertico/Consult)
        fd                        # Fast file finding (recommended for Doom Projectile/Vertico)
        emacs
        gcc                       # Compiler for Tree-Sitter & Emacs native compilation
        nodejs                    # Runtime required by npm-based language servers

        # --- Language Servers (LSP) & Formatters for Doom Emacs ---
        pyright                   # Python LSP -> provides pyright-langserver (for: (python +pyright))
        clang-tools               # C/C++ LSP -> provides clangd (for: (cc +lsp))
        nil                       # Nix LSP -> provides nil (for: (nix +lsp))
        nixpkgs-fmt               # Nix code formatter
        bash-language-server      # Shell script LSP -> provides bash-language-server (for: sh)
        haskell-language-server   # Haskell LSP -> provides haskell-language-server-wrapper (for: (haskell +lsp))
        texlab                    # LaTeX LSP -> provides texlab (for: latex)
        lua-language-server       # Lua LSP -> provides lua-language-server (for: lua)
        yaml-language-server      # YAML LSP -> provides yaml-language-server (for: yaml)
        vscode-langservers-extracted # JSON LSP -> provides vscode-json-language-server (for: json)

        # --- Dependencies for vterm in Doom Emacs ---
        cmake
        gnumake
        libtool

        # --- Applications ---
        google-chrome
        spotify

        # --- AwesomeWM Theme Dependencies ---
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

        # --- LaTeX Distribution ---
        (texlive.combine {
            inherit (texlive) scheme-medium wrapfig capt-of ulem hyperref;
        })
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
