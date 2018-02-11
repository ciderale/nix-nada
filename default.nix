let # pin the version of the nixpkgs
  hostPkgs = import <nixpkgs> {};
  nixpkgs = (hostPkgs.fetchFromGitHub {
    owner = "NixOS";
    repo = "nixpkgs-channels";
    rev = "931a0b8be80661902baefb3e7d55403be893e0e6";
    sha256 = "028kq1k03kn2p6p5wh6c1wiyh4vsp25hj4cv5yfqnw8yllm28889";
  });
in

let # Adding minor modifications/patches to python
  pyNoCheck = pkg: pkg.overridePythonAttrs (old: rec {doCheck = false;});

  packageOverrides = self: super: {
     send2trash = pyNoCheck super.send2trash;
     notebook = pyNoCheck super.notebook;
     #graph-tool = (super.callPackage ./2.x.x.nix {
     graph-tool = (super.callPackage ./graph-tool.nix {
       inherit (self) pycairo scipy numpy pygobject3 matplotlib boost;
     });
  };
in

# load nixpkgs with modifications based on overlays mechanism
#with import <nixpkgs> { # use the global nixpkgs
with import nixpkgs {    # use the pinned nixpkgs
  overlays = [
    (pkgsself: pkgssuper: {
       python36 = pkgssuper.python36.override { inherit packageOverrides;};
       # TODO: generalize to use_openmp(and gcc) or no_openmp on mac
       xgboost = pkgssuper.xgboost.overrideAttrs (old: rec {
         meta = { platforms = pkgsself.stdenv.lib.platforms.darwin; };
         patchPhase = '' substituteInPlace make/config.mk --replace "USE_OPENMP = 1" "USE_OPENMP = 0" '';
         #buildInputs = [pkgsself.gcc]; # alternatively if OPENMP is needed on osx
       });
    })
  ];
};


# define the actual jupyter packages
let 

  python36x = python36.buildEnv.override {
    ignoreCollisions = true; # https://github.com/NixOS/nixpkgs/issues/24517
    extraLibs = with python36.pkgs; [
      # Kernel
      ipykernel
      ipywidgets

      # Visualization
      matplotlib
      seaborn

      # The numeric machinery
      numpy
      scipy
      pandas
      scikitlearn
      scikitimage
      xgboost
      graph-tool
      cython
      statsmodels
      sympy
    ];
  };


  python36_kernel = stdenv.mkDerivation rec {
    name = "python36_kernel";
    buildInputs = [ python36x ];

    json = builtins.toJSON {
      argv = [ "${python36x}/bin/python3.6"
               "-m" "ipykernel" "-f" "{connection_file}" ];
      display_name = "Python 3.6";
      language = "python";
      env = { PYTHONPATH = ""; };
    };

    builder = builtins.toFile "builder.sh" ''
      source $stdenv/setup
      mkdir -p $out
      cat > $out/kernel.json << EOF
      $json
      EOF
    '';
  };

  vimplugin = fetchgit {
    "url"= "https://github.com/lambdalisue/jupyter-vim-binding";
    "rev"= "c9822c753b6acad8b1084086d218eb4ce69950e9";
    "sha256"= "1951wnf0k91h07nfsz8rr0c9nw68dbyflkjvw5pbx9dmmzsa065j";
  };

  calysto = fetchgit {
    "url"= "https://github.com/Calysto/notebook-extensions.git";
    "rev"= "5cbb49a097d96a82c6fb165858a37b766aa381c5";
    "sha256"= "18c5skljfivlv5hzs0xcspknhnrsb0vlny8x6ryg14w1krfcmiwj";
  };

  jupyter_config = stdenv.mkDerivation rec {
      name = "jupyter_config";

      buildInputs = [ python36_kernel makeWrapper ];

      jp_nb_config = writeText "jupyter_notebook_config.py" ''
        import os
        from subprocess import check_call

        c.NotebookApp.ip = os.environ.get('JUPYTER_NOTEBOOK_IP', 'localhost')
        c.KernelSpecManager.whitelist = {
          '${python36_kernel.name}'
        }

        # https://www.svds.com/jupyter-notebook-best-practices-for-data-science/
        ### If you want to auto-save .html and .py versions of your notebook:
        # modified from: https://github.com/ipython/ipython/issues/8009
        def post_save(model, os_path, contents_manager):
            """post-save hook for converting notebooks to .py scripts"""
            if model['type'] != 'notebook':
               return # only do this for notebooks
            d, fname = os.path.split(os_path)
            check_call(['jupyter', 'nbconvert', '--to', 'script', fname], cwd=d)
            check_call(['jupyter', 'nbconvert', '--to', 'html', fname], cwd=d)
        c.FileContentsManager.post_save_hook = post_save
      '';

      nbjson = writeText "notebook.json" (builtins.toJSON {
          load_extensions = {
            "calysto/document-tools/main" = true;
            "calysto/cell-tools/main" = true;
            "calysto/spell-check/main" = true;
            "calysto/annotate/main" = true;
            "calysto/publish/main" = false;
            "calysto/submit/main" = false;
            "jupyter-js-widgets/extension" = true;
            "vim_binding/vim_binding" = true;
          };
      });

      builder = writeText "builder.sh" ''
        source $stdenv/setup
        mkdir -p $out/etc/jupyter/{kernels,migrated,nbconfig,nbextensions}

        # configuration and extension activation
        ln -s ${jp_nb_config} $out/etc/jupyter/jupyter_notebook_config.py
        ln -s ${nbjson} $out/etc/jupyter/nbconfig/notebook.json

        # install kernels
        cd $out/etc/jupyter/kernels
        ln -s ${python36_kernel} ${python36_kernel.name}

        # install extensions
        cd $out/etc/jupyter/nbextensions
        ln -s ${vimplugin} vim_binding
        ln -s ${calysto}/calysto
        ln -s ${python36.pkgs.widgetsnbextension}/share/jupyter/nbextensions/jupyter-js-widgets

        # put variable data into working directory
        makeWrapper ${python36x.pkgs.jupyter_core}/bin/jupyter \
                    $out/bin/jupy \
           --set JUPYTER_DATA_DIR    ".jupyter" \
           --set JUPYTER_RUNTIME_DIR ".jupyter" \
           --set JUPYTER_CONFIG_DIR  $out/etc/jupyter \
           --set JUPYTER_PATH        $out/etc/jupyter
      '';
    };


  project = stdenv.mkDerivation rec {
     name = "project";

     buildInputs = [python36x jupyter_config];

     shellHook = ''
        mkdir -p $PWD/.jupyter
        # setup some project specific environment variables
        #export JUPYTER_DATA_DIR=$PWD/.jupyter
        #export JUPYTER_RUNTIME_DIR=$PWD/.jupyter
        #export JUPYTER_CONFIG_DIR=${jupyter_config}/etc/jupyter
        #export JUPYTER_PATH=${jupyter_config}/etc/jupyter
      '';
    } ;

in 
  project