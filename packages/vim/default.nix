# Vim, with a set of extra packages (extraPackages) and a custom vimrc
# (./vimrc). The final vimrc file is generated by vimUtils.vimrcFile and
# bundles all the packages with the custom vimrc.
{ symlinkJoin, makeWrapper, lib,
  vim, vim_configurable, vimPlugins, vimUtils,
  git, haskellPackages, gnutar, gzip, zip }:
  let
    vim_nogtk3 = vim_configurable.overrideAttrs (old: {
      configureFlags = ["--enable-darwin" "--enable-carbon_check"] ++ # "--with-x=no"] ++ 
      ( lib.remove "--disable-darwin"
      ( lib.remove "--disable-carbon_check"
      ( lib.remove "--enable-gui=gtk3"
        old.configureFlags
      )));
    });
    vim_noX = symlinkJoin {
      name = "vim_noX";
      paths = [ vim_nogtk3 ];
      buildInputs = [makeWrapper];
          #--add-flags "-X" \
      postBuild = ''
        wrapProgram $out/bin/vim \
          --prefix PATH ":" '${binPath}'
        ln -s $out/bin/{vim,vi}
      '';
    };
    binPath = lib.makeBinPath [git gnutar gzip zip haskellPackages.hasktags];
    myvim = (vimUtils.makeCustomizable vim_noX).customize {
      name = "vim";
      wrapGui = false;
      vimrcConfig = {
        customRC = builtins.readFile ./vimrc;
        packages.myVimPackages.start = with vimPlugins; [
          # TODO: setup ultisnips
          # ghcmod # NOTE: the haskell package for ghc-mod is broken
          ctrlp
          fugitive
          gitgutter
          nerdcommenter
          nerdtree
          surround
          syntastic
          vim-tmux-navigator
          vim-airline
          vim-easymotion
          vim-indent-guides
          vim-markdown
          vim-multiple-cursors
          vim-nix
          vim-trailing-whitespace
          vimproc
          neoformat
          #youcompleteme
          ale
          riv
          vimwiki
        ];
      };
    };
  in
  myvim
