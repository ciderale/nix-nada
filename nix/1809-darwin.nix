# nix-pinning nixpkgs-18.09-darwin
# committed on "2019-04-08T03:04:42Z" - retrieved on 2019-04-11
import (builtins.fetchTarball {
  name   = "nixpkgs-18.09-darwin.2019-04-11";
  url    = "https://github.com/NixOS/nixpkgs/archive/feaf8ac4632c2d9d27f24272da2e6873d2e9a7ad.tar.gz";
  sha256 = "0qz8qmvh9vb6n1ziflhlww0pqqw936228pcpwnsyl8adi2izc7lw";
})