self: super: {
  haskellPackages = super.haskellPackages.override {
    overrides = hself: hsuper: {
        # testsuite has an issue on osx
        # https://github.com/alanz/ghc-exactprint/issues/66
        ghc-exactprint = self.haskell.lib.dontCheck hsuper.ghc-exactprint;
        multistate = self.haskell.lib.dontCheck (
          self.haskell.lib.overrideCabal hsuper.multistate (old: {
            broken=false;
          }));

          butcher = self.haskell.lib.overrideCabal hsuper.butcher (old: {
            broken=false;
          });

          brittany = self.haskell.lib.overrideCabal (
            self.haskell.lib.doJailbreak hsuper.brittany) (old: {
              version = "0.12.0.0";
              revision=null;
              editedCabalFile=null;
              broken=false;
              sha256 = "058ffj00x374iaz75zzd9l0ab4crdsq2zjrq1r8lvcpp63fmsa7h";
            });
          };
        };
      }
