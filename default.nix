with (import ./nix/1809-darwin.nix {});

let
  nix-pinning = callPackage ./packages/nix-pinning.nix {};
  zsh = callPackage ./packages/zsh.nix {};
  vim = callPackage ./packages/vim {};
in

# install globally with
# nix-env -f ./default.nix -iA buildInputs
mkShell {
  buildInputs = with import ./default.nix; [
    nix-pinning zsh vim which coreutils
  ];
  shellHook = ''
  '';
}
