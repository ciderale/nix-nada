{ bash, shellcheck, writers }:

rec {
  strictShell = name: content: writers.makeScriptWriter {
    interpreter = ''
      ${bash}/bin/bash
      # http://redsymbol.net/articles/unofficial-bash-strict-mode/
      set -euo pipefail
      IFS=$'\n\t'
    '';
    check = "${shellcheck}/bin/shellcheck";
  } "/bin/${name}" content;

  scripts = args: with builtins; attrValues (mapAttrs strictShell args);
}
