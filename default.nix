let
  overlay = import ./packages/overlay.nix;
  pkgs = import ./nixpkgs { overlays = [overlay]; };
in
  pkgs
