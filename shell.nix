with (import ./.);

mkShell {
  buildInputs = (with nix-pinning; [init update pinning]) ++ [
    gitFull curl jq direnv less coreutils
    myzsh

    #lorri.lorri
    #haskellPackages.brittany
    #jdk
    #myvim
  ];
  shellHook = ''
    export ROOTDIR=$(pwd)
  '';
}
