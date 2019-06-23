let
  overlay = import ./haskellOverlay.nix;
  overlay2 = self: super: {
    nix-pinning = self.callPackage ./packages/nix-pinning.nix {};
    nix-update = self.callPackage ./packages/nix-update.nix {};
    lorri = self.callPackage ./packages/lorri.nix { };
    myzsh = self.callPackage ./packages/zsh.nix {};
    myvim = self.callPackage ./packages/vim { git = self.gitFull; };
  };
  pkgs = import ./nix { version="1903-darwin"; } {
    config = {};
    overlays = [overlay overlay2];
  };
in

with pkgs;

# install globally with
# nix-env -f ./default.nix -iA buildInputs
mkShell {
  buildInputs = [
    nix-pinning nix-update
    myzsh myvim gitFull
    which coreutils less
    curl jq
    direnv lorri.lorri
    haskellPackages.brittany
  ];
  shellHook = ''
  '';
}
