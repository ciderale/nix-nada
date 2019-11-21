let
  overlay = import ./haskellOverlay.nix;
  overlay2 = import ./packages/overlay.nix;
  pkgs = import ./nix/nixpkgs-1909-darwin.nix {
    config = {};
    overlays = [overlay overlay2];
  };
in
  pkgs

# install: nix-env -f ./default.nix -iA nix-pinning
