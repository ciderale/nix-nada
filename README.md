# Nix-Nada: Reproducible Environment with nix

## Usage: Initial project setup

```
mkdir project
cd project
nix-init
direnv allow
```

## Usage: Pinning remote repositories

1) Update the pinned nix packages

`cd project && nix-pinup nixpkgs/default.nix`

2)  Configure alternative remotes

`cd project && nix-pinning nixos-unstable > nixpkgs/nixos.nix`

## One-time (system) Installation

1) [Install 'nix'](https://nixos.org/nix/download.html)

  ```curl https://nixos.org/nix/install | sh```

2) Install & Configure 'direnv'

  ```
  nix-env -iA direnv
  echo 'eval "$(direnv hook zsh)"' > ~/.zshrc
  ```

3) Install 'nix-pinning'

  ```nix-env -f ./default.nix -iA nix-pinning```


# Additional helpful nix commands

- nix repl ./default.nix    (interactively exploring the packages)
- nix search "query"        (find derivation mathing query)
- nix search -u -f ./default.nix jdk (query jdk in locally pinned repo)
- nix-shell --pure          (shell env with only declared dependencies)
- nix-env -f ./default.nix -iA attributeName (global installation)

