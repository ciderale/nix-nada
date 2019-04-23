{ writeShellScriptBin, nix, git, coreutils }:

writeShellScriptBin "nix-pinning" ''
  set -e
  BRANCH=''${1:-nixos-unstable}
  REPO=''${2:-nixos/nixpkgs-channels}
  DATE=$(${coreutils}/bin/date +%Y-%m-%d)
  if [ ''${#BRANCH} -eq 40 ]; then
      REVISION=$BRANCH
      NAME=$BRANCH
  else
      REVISION=$(${git}/bin/git ls-remote https://github.com/$REPO $BRANCH | ${coreutils}/bin/cut -f1 )
      NAME="$BRANCH"
  fi

  TARBALL="https://github.com/$REPO/archive/$REVISION.tar.gz"
  SHA256=$(${nix}/bin/nix-prefetch-url --name $NAME --unpack $TARBALL)
  COMMITTED=$(curl -s -X GET https://api.github.com/repos/$REPO/git/commits/$REVISION | jq '.committer.date')
  COMMITTED_DAY=$(echo $COMMITTED | cut -c2-11)
  DERIVATION_NAME=$(echo $REPO-$NAME-$COMMITTED_DAY | tr '/' '_');


  cat <<EOF
  # nix-pinning $*
  # committed on $COMMITTED - retrieved on $DATE
  import (builtins.fetchTarball {
    name   = "$DERIVATION_NAME";
    url    = "$TARBALL";
    sha256 = "$SHA256";
  })
  EOF
''
