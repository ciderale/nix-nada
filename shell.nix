with (import ./.);

mkShell {
  buildInputs = (with nix-pinning; [init update pinning]) ++ [
    gitFull curl jq direnv less
    lorri.lorri
    myzsh
    haskellPackages.brittany
    #myvim
  ];
  shellHook = ''
    export ROOTDIR=$(pwd)
  '';
}
