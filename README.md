# Nix-Nada: Reproducible Environment with nix

## Usage: Initial project setup

```
$ mkdir project
$ cd project
$ nix-init
$ direnv allow

# creates: .envrc, default.nix, shell.nix, nixpkgs/default.nix
```

## Usage: Pinning remote repositories

```
# Update the pinned nix packages
$ nix-pinup nixpkgs/default.nix`

# Configure alternative remotes
$ nix-pinning nixos-unstable > nixpkgs/nixos.nix
```

## One-time (system) Installation

1) [Install 'nix'](https://nixos.org/nix/download.html)
2) [Install & Configure 'direnv'](https://direnv.net)
3) [Install 'nix-pinning'](https://github.com/ciderale/nix-nada/)

```
$ curl https://nixos.org/nix/install | sh

$ nix-env -iA direnv
$ echo 'eval "$(direnv hook zsh)"' > ~/.zshrc

$ nix-env -f ./default.nix -iA nix-pinning
```

# Additional helpful nix commands

- nix repl ./default.nix    (interactively exploring the packages)
- nix search "query"        (find derivation mathing query)
- nix search -u -f ./default.nix jdk (query jdk in locally pinned repo)
- nix-shell --pure          (shell env with only declared dependencies)
- nix-env -f ./default.nix -iA attributeName (global installation)

