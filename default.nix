let
  overlay = self: super: {
    haskellPackages = super.haskellPackages.override {
      overrides = hself: hsuper: {
        # testsuite has an issue on osx
        # https://github.com/alanz/ghc-exactprint/issues/66
        ghc-exactprint = self.haskell.lib.dontCheck hsuper.ghc-exactprint;
        multistate = self.haskell.lib.dontCheck hsuper.multistate;

        brittany = self.haskell.lib.overrideCabal (
          self.haskell.lib.doJailbreak hsuper.brittany) (old: {
  version = "0.12.0.0";
  revision=null;
  editedCabalFile=null;
  sha256 = "058ffj00x374iaz75zzd9l0ab4crdsq2zjrq1r8lvcpp63fmsa7h";
          });


        };
     };
  };
  pkgs = import ./nix/1903-darwin.nix {
    overlays = [overlay];
  };
in

with pkgs;

let
  git = gitFull;
  nix-pinning = callPackage ./packages/nix-pinning.nix {};
  zsh = callPackage ./packages/zsh.nix {};
  vim = callPackage ./packages/vim { git = gitFull; };
  lorri = callPackage ./packages/lorri.nix { };
in
# install globally with
# nix-env -f ./default.nix -iA buildInputs
mkShell {
  buildInputs = [
    nix-pinning
    zsh vim git
    which coreutils less
    curl jq
    lorri.direnv lorri.lorri
    haskellPackages.brittany
  ];
  shellHook = ''
  '';
}
