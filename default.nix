let
  jdk = import ./packages/java.nix "jdk11";
  overlay = import ./packages/overlay.nix;
  pkgs = import ./nixpkgs { overlays = [overlay jdk]; };
in
  pkgs
