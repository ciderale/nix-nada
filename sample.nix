with import <nixpkgs> {};

stdenv.mkDerivation rec {
  name = "my-project";
  version = "0.1";

  buildInputs = [ git kpcli gradle_3_5 nodejs-8_x ansible openssh vim ];

  shellHook = ''
    export PS1="\\u@\h \\W]\\$ ${name}> "
    echo $PATH | tr : '\n'
  '';
}
