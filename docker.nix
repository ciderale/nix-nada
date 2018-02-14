with import <nixpkgs> {};

let 
  program = import ./sample.nix;
in

dockerTools.buildImage {
  name = "helloworld";
  contents = [ program ];
  config.entrypoint = "helloworld";
  config.Cmd = "!!!";
}
