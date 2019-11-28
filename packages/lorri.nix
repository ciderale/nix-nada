{ pkgs
}:
let
  lorriRepo = import ../nixpkgs/lorri.nix;
in {
  lorri = import "${lorriRepo}" {
    inherit pkgs; # does not build with 'crate' problem
    src = lorriRepo;
  };
}
