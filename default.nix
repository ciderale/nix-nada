let
  overlay = import ./haskellOverlay.nix;
  overlay2 = import ./packages/overlay.nix;
  pkgs = import ./nix/nixpkgs-1909-darwin.nix {
    config = {};
    overlays = [overlay overlay2];
  };
in

with pkgs;

# install globally with
# nix-env -f ./default.nix -iA buildInputs
mkShell {
  buildInputs = [
    nix-pinning.pinning nix-pinning.update
    myzsh myvim gitFull
    which coreutils less
    curl jq
    direnv lorri.lorri
    haskellPackages.brittany
  ];
  shellHook = ''
  '';
}
