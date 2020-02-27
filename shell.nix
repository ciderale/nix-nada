with (import ./. {});

let

  projectScripts = scripts {
    gfix = ''COMMIT=$1; git commit --fixup "$COMMIT" && git rebase -i --autosquash "$COMMIT^"'';
  };
in

mkShell {
  buildInputs = (with nix-pinning; [init update pinning]) ++ [
    gitFull curl jq direnv less coreutils
    myzsh

    #lorri.lorri
    #haskellPackages.brittany
    #jdk
    #myvim
  ] ++ projectScripts;
  shellHook = ''
    export ROOTDIR=$(pwd)
  '';
}
