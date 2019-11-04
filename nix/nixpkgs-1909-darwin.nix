# nix-pinning nixpkgs-19.09-darwin
# committed on "2019-11-04T18:34:12Z" - retrieved on 2019-11-05
import  (builtins.fetchTarball {
  name   = "nixos_nixpkgs-channels-nixpkgs-19.09-darwin-2019-11-04";
  url    = "https://github.com/nixos/nixpkgs-channels/archive/82efd775e37efb04299f5f1fedea4a773f5a9f1e.tar.gz";
  sha256 = "05nwj62fzwnaif7l5yxkvjgnh2qf7kppm72zjkr733cqs2y6z0zw";
})
