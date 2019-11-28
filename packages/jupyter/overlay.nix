let # Adding minor modifications/patches to python
  pyNoCheck = pkg: pkg.overridePythonAttrs (old: rec {doCheck = false;});

  packageOverrides = self: super: {
     docker = pyNoCheck super.docker;
     docutils = pyNoCheck super.docutils;
     sqlalchemy = pyNoCheck super.sqlalchemy;
     send2trash = pyNoCheck super.send2trash;
     notebook = pyNoCheck super.notebook;
     terminado = pyNoCheck super.terminado;
     pathpy = pyNoCheck super.pathpy;
     graph-tool = super.callPackage ./2.x.x.nix {}; # could be dump since changes in PR
  };
in


pkgsself: pkgssuper: {
       python36 = pkgssuper.python36.override { inherit packageOverrides;};
       python35 = pkgssuper.python35.override { inherit packageOverrides;};
       # TODO: generalize to use_openmp(and gcc) or no_openmp on mac
       xgboost = pkgssuper.xgboost.overrideAttrs (old: rec {
         meta = { platforms = pkgsself.stdenv.lib.platforms.darwin; };
         patchPhase = '' substituteInPlace make/config.mk --replace "USE_OPENMP = 1" "USE_OPENMP = 0" '';
         #buildInputs = [pkgsself.gcc]; # alternatively if OPENMP is needed on osx
       });
}
