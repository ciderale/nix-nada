# nix-pinning nixpkgs-19.03-darwin
# committed on "2019-06-16T14:22:25Z" - retrieved on 2019-06-20
import (builtins.fetchTarball {
  name   = "nixos_nixpkgs-channels-nixpkgs-19.03-darwin-2019-06-16";
  url    = "https://github.com/nixos/nixpkgs-channels/archive/bfc68f778a7a7423cd56a972ce1dd6da9f89d036.tar.gz";
  sha256 = "1cv96jwf54wrx8vp6j98s0zf164c1yg3582rgcbwcbmph8hlza3m";
})
