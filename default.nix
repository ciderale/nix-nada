let
  overlay = import ./haskellOverlay.nix;
  pkgs = import ./nix { version="1903-darwin"; } {
    config = {};
    overlays = [overlay];
  };
in

with pkgs;

let
  git = gitFull;
  nix-pinning = callPackage ./packages/nix-pinning.nix {};
  nix-update = callPackage ./packages/nix-update.nix {};
  zsh = callPackage ./packages/zsh.nix {};
  vim = callPackage ./packages/vim { git = gitFull; };
  lorri = callPackage ./packages/lorri.nix { };
in
# install globally with
# nix-env -f ./default.nix -iA buildInputs
mkShell {
  buildInputs = [
    nix-pinning nix-update
    zsh vim git
    which coreutils less
    curl jq
    lorri.direnv lorri.lorri
    haskellPackages.brittany
  ];
  shellHook = ''
  '';
}
