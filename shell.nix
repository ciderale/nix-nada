{ jdkversion ? "jdk11"
}:

let
  java = import ./java.nix;

  pkgs = import <nixpkgs> {
    overlays = [java.custom (java.select jdkversion)];
  };

in with pkgs;

stdenv.mkDerivation {
  name = "sample";
  version = "0.0";
  buildInputs = [jdk gradle];
}