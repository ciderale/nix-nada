{ writeShellScriptBin, nix, git, coreutils, jq }:

writeShellScriptBin "nix-update" ''
  set -e
  FILE=''${1}
  shift
  DATE=$(${coreutils}/bin/date +%Y-%m-%d)

  REPO=$(${jq}/bin/jq -r '.repo' $FILE)
  BRANCH=$(${jq}/bin/jq -r '.branch' $FILE)

  REVISION=$(${git}/bin/git ls-remote https://github.com/$REPO $BRANCH | ${coreutils}/bin/cut -f1 )
  TARBALL="https://github.com/$REPO/archive/$REVISION.tar.gz"
  COMMITTED=$(curl -s -X GET https://api.github.com/repos/$REPO/git/commits/$REVISION | ${jq}/bin/jq -r '.committer.date')
  COMMITTED_DAY=$(echo $COMMITTED | cut -c1-10)
  DERIVATION_NAME=$(echo $REPO-$BRANCH-$COMMITTED_DAY | tr '/' '_');

  SHA256=$(${nix}/bin/nix-prefetch-url --name $DERIVATION_NAME --unpack $TARBALL)

  (cat <<EOF
  {
    "name"   : "$DERIVATION_NAME",
    "url"    : "$TARBALL",
    "sha256" : "$SHA256",
    "repo":    "$REPO",
    "branch":  "$BRANCH",
    "committedOn": "$COMMITTED",
    "retrievedOn": "$DATE"
  }
  EOF
  ) | ${jq}/bin/jq '.' > $FILE
''
