{ system ? builtins.currentSystem
}:

let
  selectJS = self: super: { nodejs = self.nodejs-10_x; } ;
in

with import <nixpkgs> {
  inherit system;
  overlays = [ selectJS ];
};

let

  # for some very simple one-off script files (make it executable)
  helloworld = writeShellScriptBin "helloworld" ''
  	echo "Hello World $1!"
  '';

in 

stdenv.mkDerivation rec {
  name = "my-project";
  version = "0.1";
  
  buildInputs = [ git nodejs ];

  # Run only the installPhase -- no unpacking -- phases must be "quoted"
  phases = [ "installPhase" ];
  installPhase = ''
    mkdir -p $out/bin;

    # output a bunch of versions
    echo "Built on: $(date)" >> $out/versions;
    uname -a >> $out/versions;
    node --version >> $out/versions;
    # gradle -version >> $out/versions;

    # 1) Just link the helloworld binary
    # ln -s ${helloworld}/bin/helloworld $out/bin

    # 2) OR create a wrapper with a version preamble
    cat > $out/bin/helloworld << EOF
    #!${bash}/bin/bash
    ${coreutils}/bin/cat $out/versions
    exec ${helloworld}/bin/helloworld \$*
    EOF
    chmod +x $out/bin/helloworld
  '';

  shellHook = ''
    export PS1="\\u@\h \\W]\\$ ${name}> "
    echo "Your PATH variable contains:"
    echo $PATH | tr : '\n'
    echo "  that was your path variable"
  '';

}
