{
  version ? "1903-darwin",
  import ? true,
}:

let
  meta = builtins.import (./.  + "/${version}.nix");
  tarball = builtins.fetchTarball {
    inherit (meta) name url sha256;
  };
in
  if import
  then builtins.import tarball
  else tarball

