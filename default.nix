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
