{ writeShellScriptBin, nix, git, coreutils, gnused }:

{ pinning = writeShellScriptBin "nix-pinning" ''
  set -e
  BRANCH=''${1:-nixos-unstable}
  REPO=''${2:-nixos/nixpkgs-channels}
  # typically 'import' the remote, but sometimes we need the store path
  DO_IMPORT=$(echo $* | grep -q noimport || echo "import ")

  DATE=$(${coreutils}/bin/date +%Y-%m-%d)
  if [ ''${#BRANCH} -eq 40 ]; then
      REVISION=$BRANCH
      NAME=$BRANCH
  else
      REVISION=$(${git}/bin/git ls-remote https://github.com/$REPO $BRANCH | ${coreutils}/bin/cut -f1 )
      NAME="$BRANCH"
  fi

  TARBALL="https://github.com/$REPO/archive/$REVISION.tar.gz"
  COMMITTED=$(curl -s -X GET https://api.github.com/repos/$REPO/git/commits/$REVISION | jq '.committer.date')
  COMMITTED_DAY=$(echo $COMMITTED | cut -c2-11)
  DERIVATION_NAME=$(echo $REPO-$NAME-$COMMITTED_DAY | tr '/' '_');

  SHA256=$(${nix}/bin/nix-prefetch-url --name $DERIVATION_NAME --unpack $TARBALL)

  cat <<EOF
  # nix-pinning $*
  # committed on $COMMITTED - retrieved on $DATE
  $DO_IMPORT (builtins.fetchTarball {
    name   = "$DERIVATION_NAME";
    url    = "$TARBALL";
    sha256 = "$SHA256";
  })
  EOF
'';
update = writeShellScriptBin "nix-pinup" ''
for pin in $*; do
  CMD=$(${coreutils}/bin/head -n 1 $pin | ${gnused}/bin/sed -e 's/#[[:space:]]*//')
  $CMD > $pin
done
'';
}
