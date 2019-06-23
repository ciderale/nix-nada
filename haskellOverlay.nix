self: super:
  with self.haskell.lib; {
  haskellPackages = super.haskellPackages.override {
    overrides = hself: hsuper: {
        # testsuite has an issue on osx
        # https://github.com/alanz/ghc-exactprint/issues/66
        ghc-exactprint = dontCheck hsuper.ghc-exactprint;
        multistate = overrideCabal (dontCheck hsuper.multistate) (old: {
          broken=false;
        });

        butcher = overrideCabal hsuper.butcher (old: {
          broken=false;
        });

        brittany = overrideCabal (doJailbreak hsuper.brittany) (old: {
          version = "0.12.0.0";
          revision=null;
          editedCabalFile=null;
          broken=false;
          sha256 = "058ffj00x374iaz75zzd9l0ab4crdsq2zjrq1r8lvcpp63fmsa7h";
        });
      };
    };
  }
