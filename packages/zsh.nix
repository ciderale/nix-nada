{ zsh, oh-my-zsh, writeText, makeWrapper, symlinkJoin, writeScriptBin,
  direnv
}:

let
  zsh-nix-shell = builtins.fetchTarball {
    name = "zsh-nix-shell";
    url = "https://github.com/chisui/zsh-nix-shell/archive/dceed031a54e4420e33f22a6b8e642f45cc829e2.tar.gz";
    sha256 = "10g8m632s4ibbgs8ify8n4h9r4x48l95gvb57lhw4khxs6m8j30q";
  };

  # start nix-based zsh when coming from login shell
  # place 'which boot-zsh && exec boot-zsh' in ~/.zshrc
  # maybe some other alternatives exist
  boot-zsh = writeScriptBin "boot-zsh" "exec zsh";

  zshrc = writeText "myzshrc" ''
    export ZSH=${oh-my-zsh}/share/oh-my-zsh
    # check example in: $ZSH/templates/zshrc.zsh-template

    # Which plugins would you like to load? (plugins can be found in $ZSH/plugins/*)
    # Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
    plugins=(git)

    # Uncomment the following line to disable bi-weekly auto-update checks.
    # => disable, since nix is immutable => update derivation
    DISABLE_AUTO_UPDATE="true"

    # Set name of the theme to load. Optionally, if you set this to "random"
    # it'll load a random theme each time that oh-my-zsh is loaded.
    # See https://github.com/robbyrussell/oh-my-zsh/wiki/Themes
    # ZSH_THEME="robbyrussell"
    ZSH_THEME="af-magic"

    # You may need to manually set your language environment
    export LANG=en_US.UTF-8

    # source ZSH
    source $ZSH/oh-my-zsh.sh

    # aliases
    alias ls='ls --color'

    # execute nix-shell hook again (when switching from bash to zsh)
    eval "$shellHook"
    eval "$(direnv hook zsh)"
  '';
in
  symlinkJoin {
    name = "zsh";
    buildInputs = [makeWrapper];
    postBuild = ''
      wrapProgram "$out/bin/zsh" \
        --set ZDOTDIR $out/ \
        --set ZSH_CUSTOM $out/

      # setup the immutable (user) configuration
      mkdir $out/plugins
      ln -fs ${zshrc} $out/.zshrc
      ln -fs ${zsh-nix-shell} $out/plugins/nix-shell
    '';
    paths = [zsh boot-zsh];
  }
