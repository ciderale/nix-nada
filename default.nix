{ pkgPath ? ./nixpkgs
}:
let
  jdk = import ./packages/java.nix "jdk11";
  overlay = import ./packages/overlay.nix;

  shOverlay = self: super: import ./packages/strictShell.nix {
    inherit (self) bash writers shellcheck;
  };

  pkgs = import pkgPath { overlays = [overlay jdk shOverlay]; };
in
  pkgs
