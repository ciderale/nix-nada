{ pkgs
}:
let
  lorriRepo = import ../nix { version="lorri"; import=false; };
  lorri = import "${lorriRepo}/default.nix" {
    inherit pkgs; # does not build with 'crate' problem
    src = lorriRepo;
  };
  # provides direnv in a sufficiently high, compatible version
  direnv = import "${lorriRepo}/direnv/nix.nix";
in {
  inherit lorriRepo direnv lorri;
}
