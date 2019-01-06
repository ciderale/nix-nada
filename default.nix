with (import ./nix/1809-darwin.nix {});

let
  git = gitFull;
  nix-pinning = callPackage ./packages/nix-pinning.nix {};
  zsh = callPackage ./packages/zsh.nix {};
  vim = callPackage ./packages/vim { git = gitFull; };
in

# install globally with
# nix-env -f ./default.nix -iA buildInputs
mkShell {
  buildInputs = with import ./default.nix; [
    nix-pinning
    zsh vim git
    which coreutils less
    curl jq
  ];
  shellHook = ''
  '';
}
