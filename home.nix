{
  config,
  pkgs,
  pkgs-unstable,
  ...
}:

{
  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "aarol";
  home.homeDirectory = "/Users/aarol";

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "24.11"; # Please read the comment before changing.

  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages =
    with pkgs;
    [
      nixd
      nil
      difftastic
      fzf
      ripgrep
      zoxide
      zig
      go
      rustup
      jetbrains-mono
      just
      nixfmt-rfc-style
      fastfetch
    ]
    ++ (with pkgs-unstable; [
      opencode
    ]);
  # # It is sometimes useful to fine-tune packages, for example, by applying
  # # overrides. You can do that directly here, just don't forget the
  # # parentheses. Maybe you want to install Nerd Fonts with a limited number of
  # # fonts?
  # (pkgs.nerdfonts.override { fonts = [ "FantasqueSansMono" ]; })

  # # You can also create simple shell scripts directly inside your
  # # configuration. For example, this adds a command 'my-hello' to your
  # # environment:
  # (pkgs.writeShellScriptBin "my-hello" ''
  #   echo "Hello, ${config.home.username}!"
  # '')

  programs.fish = {
    enable = true;
    interactiveShellInit = ''
      zoxide init fish --cmd cd | source

      set -gx PNPM_HOME "/Users/aarol/Library/pnpm"
      if not string match -q -- $PNPM_HOME $PATH
        set -gx PATH "$PNPM_HOME" $PATH
      end

      set -gx VCPKG_ROOT "$HOME/dev/vcpkg"

      # Added by LM Studio CLI (lms)
      set -gx PATH $PATH /Users/aarol/.lmstudio/bin
      # End of LM Studio CLI section

      # >>> JVM installed by coursier >>>
      set -gx JAVA_HOME "/Users/aarol/Library/Caches/Coursier/arc/https/cdn.azul.com/zulu/bin/zulu21.44.17-ca-jdk21.0.8-macosx_aarch64.tar.gz/zulu21.44.17-ca-jdk21.0.8-macosx_aarch64"
      # <<< JVM installed by coursier <<<


      set -gx ANDROID_HOME /Users/aarol/Library/Android/sdk/

      # >>> coursier install directory >>>
      set -gx PATH "$PATH:/Users/aarol/Library/Application Support/Coursier/bin"
      # <<< coursier install directory <<<

      # bun
      set --export BUN_INSTALL "$HOME/.bun"
      set --export PATH $BUN_INSTALL/bin $PATH

      # Added by Antigravity
      fish_add_path /Users/aarol/.antigravity/antigravity/bin

      function fish_edit_config
          zed --wait ~/.config/fish/config.fish && source ~/.config/fish/config.fish
      end
    '';
    shellAliases = {
      gs = "git status";
      gpl = "git pull --rebase";
      gpo = "git push origin";
      gcm = "git commit -m";
      ga = "git add";
      gl = "git log --oneline --graph --decorate";
      finder = "open";
    };
    functions = {
      hm_switch = "nix run home-manager/release-24.11 -- switch";
    };
  };

  programs.git = {
    enable = true;
    userName = "aarol";
    userEmail = "aarol@iki.fi";
    difftastic.enable = true;

    lfs.enable = true;
    includes = [
      {
        condition = "gitdir:~/aalto/";
        contents = {
          user = {
            name = "Aaro Luomanen";
            email = "aaro.luomanen@aalto.fi";
          };
        };
      }
    ];
    extraConfig = {
      url = {
        "ssh://git@version.aalto.fi/" = {
          insteadOf = "https://version.aalto.fi/";
        };
      };
    };
  };
  programs.gh.enable = true;

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    # # Building this configuration will create a copy of 'dotfiles/screenrc' in
    # # the Nix store. Activating the configuration will then make '~/.screenrc' a
    # # symlink to the Nix store copy.
    # ".screenrc".source = dotfiles/screenrc;

    # # You can also set the file content immediately.
    # ".gradle/gradle.properties".text = ''
    #   org.gradle.console=verbose
    #   org.gradle.daemon.idletimeout=3600000
    # '';
  };

  # Home Manager can also manage your environment variables through
  # 'home.sessionVariables'. These will be explicitly sourced when using a
  # shell provided by Home Manager. If you don't want to manage your shell
  # through Home Manager then you have to manually source 'hm-session-vars.sh'
  # located at either
  #
  #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  ~/.local/state/nix/profiles/profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  /etc/profiles/per-user/aarol/etc/profile.d/hm-session-vars.sh
  #
  home.sessionVariables = {
    EDITOR = "zed";
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
