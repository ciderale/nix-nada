with import ../nix/1809-darwin.nix { };

let
  program = callPackage ./sample.nix {
    # within docker, we need linux binaries!
    system = "x86_64-linux";
  };
in

#dockerTools.buildImage { # one-layer
dockerTools.buildLayeredImage { # one-layer per derivation (only squash to avoid max-layers)
  name = "helloworld";
  tag = "v1.0"; #only one tag allowed
  contents = [ program ];
  config.entrypoint = "/bin/helloworld";
  # config.Cmd = "/bin/helloworld";
}
