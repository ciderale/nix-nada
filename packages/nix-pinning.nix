{ writeShellScriptBin, nix, git, coreutils, gnused }:

{
pinning = writeShellScriptBin "nix-pinning" ''
  set -e

  # Selecting a channels: some documentation
  # https://nixos.wiki/wiki/Nixpkgs
  # https://nixos.wiki/wiki/Nix_channels
  # https://gist.github.com/grahamc/c60578c6e6928043d29a427361634df6#which-channel-is-right-for-me
  # http://howoldis.herokuapp.com/
  if [ $# -lt 1 ]; then
    echo " USAGE: nix-pinning <branch/rev> [<repo> ?noimport?]"
    echo " USAGE: nix-pinning nixos-unstable nixos/nixpkgs-channels"
    echo " typical branches: nixpkgs-unstable, nixos-19.09, nixpkgs-19.09-darwin"
    exit 1
  fi

  BRANCH=''${1}
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
  if [ $# -lt 1 ]; then
    echo " USAGE: nix-pinup <pinned1.nix> [<pinned2.nix>...]"
  fi

  for pin in $*; do
    CMD=$(${coreutils}/bin/head -n 1 $pin | ${gnused}/bin/sed -e 's/#[[:space:]]*//')
    $CMD > $pin
  done
'';

init = writeShellScriptBin "nix-init" ''
  [ ! -e .envrc ] && echo "use nix" > .envrc
  mkdir -p nixpkgs
  [ ! -e default.nix ] && cat >> default.nix <<EOF
  let
    overlay = self: super: {
      # modify nixpkgs and select custom versions
      jdk = super.jdk11;
      nodejs = super.nodejs-12_x;
    };
    pkgs = import ./nixpkgs { overlays = [overlay]; };
  in
    pkgs
  EOF
  [ ! -e shell.nix ] && cat >> shell.nix <<EOF
  with (import ./.);
  mkShell {
    buildInputs = [
      curl
      #jdk gradle
      #nodejs
      #google-cloud-sdk
      #kubectl kustomize sops
      # find more with nix-search
    ];
    shellHook = '''
      export ROOTDIR=\$(pwd)
      unset IN_NIX_SHELL
    ''';
  }
  EOF
  [ ! -e nixpkgs/default.nix ] && nix-pinning nixpkgs-unstable > nixpkgs/default.nix
'';
}
