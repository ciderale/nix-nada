{ pkgs
}:
let
  lorriRepo = import ../nix { version="lorri"; import=false; };
  lorri = import "${lorriRepo}/default.nix" {
    inherit pkgs; # does not build with 'crate' problem
    src = lorriRepo;
  };
in {
  inherit lorriRepo lorri;
}
