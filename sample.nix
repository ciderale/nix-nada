with import <nixpkgs> {};

stdenv.mkDerivation rec {
  name = "my-project";
  version = "0.1";

  buildInputs = [ git kpcli gradle_3_5 nodejs-8_x ansible openssh vim ];

  shellHook = ''
    export PS1="\\u@\h \\W]\\$ ${name}> "
    echo $PATH | tr : '\n'
  '';

  # Actually building it requires also

  builder = builtins.toFile "builder.sh" ''
    source $stdenv/setup;
    mkdir -p $out;
    ln -s $theprogram/bin $out/bin
    gradle -version >> $out/versions;
    node --version >> $out/versions;
  '';

  theprogram = writeShellScriptBin "helloworld" ''
  	echo "Hello World $1"
  '';

}
