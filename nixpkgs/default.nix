# nix-pinning nixpkgs-unstable
# committed on "2019-11-20T07:40:07Z" - retrieved on 2019-11-28
import  (builtins.fetchTarball {
  name   = "nixos_nixpkgs-channels-nixpkgs-unstable-2019-11-20";
  url    = "https://github.com/nixos/nixpkgs-channels/archive/58fb23f72ad916c8bbfa3c3bc2d0c83c9cfcdd16.tar.gz";
  sha256 = "0f7gnsis5hdrdcmiv7s06qz02pszmmfxrqvc77jf0lmc86i25x9i";
})
