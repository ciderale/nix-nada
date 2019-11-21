with (import ./.);

let
  pyy = python36.withPackages (p: with p; [matplotlib pandas pypdf2])
;

in

# install globally with
# nix-env -f ./default.nix -iA buildInputs
mkShell {
  buildInputs = [
    nix-pinning.pinning nix-pinning.update nix-pinning.init
    direnv lorri.lorri

    which coreutils less gitFull
    myzsh myvim
    curl jq
    haskellPackages.brittany

    pyy
  ];
  shellHook = ''
  '';
}
