{
  version ? "1903-darwin",
  import ? true,
}:

let
  meta = builtins.fromJSON (builtins.readFile (./.  + "/${version}.json"));
  tarball = builtins.fetchTarball {
    inherit (meta) name url sha256;
  };
in
  if import
  then builtins.import tarball
  else tarball

