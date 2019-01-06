{ jdkversion ? "jdk11"
}:

let
  java = import ../packages/java.nix;
  pkgs = import ../nix/1809-darwin.nix {
    overlays = [java.custom (java.select jdkversion)];
  };
in with pkgs;

stdenv.mkDerivation {
  name = "sample";
  version = "0.0";
  buildInputs = [jdk gradle];
}
