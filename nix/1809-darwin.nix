# nix-pinning nixpkgs-18.09-darwin
# committed on "2019-01-06T12:12:24Z" - retrieved on 2019-01-06
import (builtins.fetchTarball {
  name   = "nixpkgs-18.09-darwin.2019-01-06";
  url    = "https://github.com/NixOS/nixpkgs/archive/591da7cb8480907101f4003d01337b21917cae35.tar.gz";
  sha256 = "093yblp7d5rlwyrg1jckc4p3sps5hr0b1aa9b2qypqzw1flj9g50";
})
