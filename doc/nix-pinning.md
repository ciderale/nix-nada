# Nix-Pinning: reproducible environment utilities

Nix-pinning consists of three little scripts:

- nix-init: template based project initialization
- nix-pinning: pin a remote repository to a particular version
- nix-pinup: update by reexecuting the nix-pinning command

The main goal of nix-pinning is to be simple and and allowing to
manager reproducible environment without much nixpkgs knowledge.

## Tasks & Requirements

- T1: pinning of nixpkgs (including updating)
- T2: initialize a project using some templates

- R1: overall usage should be simple without much options
- R2: knowledge of nix details should be kept minimal
- R3: must allow for multiple remote repositories (github, stash, etc)

## Current solution

### Setup

     > nix-pinning nixpkgs-unstable > nixpkgs/default.nix
     > nix-pinup mypkgs/default.nix

### project (default.nix) usage

     > let
     >   pkgs = import ./nixpkgs {};
     >   other = import ./nixpkgs/alternative.nix {};
     >   raw = import ./nixpkgs/repository;
     > in ...

### nix repl usage

     > nix repl nixpkgs/default.nix
     > nix repl nixpkgs (same as above, since default.nix is default)

### Description:

  - nix-pinning fetch and freezes a remote repository/branch
  - generate a nix file that mimics a channel package set
  - generated file contains 'generation command' as comments
  - nix-pinup extracts generation command, reruns it and updates the file
  - special option "nix-pinning noimport" allows for fetching repositories


## Alternatives & Design considerations

- U1: import in default.nix should be almost like "import <nixpkgs>"
- U1b: hopefully avoid parenthesis "(import ./nixpkgs).theSet"
- U2: it is kind of convenient to allow for "nix repl ./nix/thefile.nix"
- U3: avoid double import, ie "import (import ./nixpkgs) {}"
- U3b: and yet allow for raw file path, ie. without the import

The above consideration ruled out various other designs:

- JSON Based representation of the version data
  - would probably be more flexible for update scenarios, but
  - would require an additional utiltiy nix file for usage
- Such a nix utility file could be:
  - an attribute set of all remotes (both, raw and 'import raw')
  - a single function with arguments select the remote and import or not

Both, an attribute set and a single function have disadvantages:

- Function is tricky to use with nix-repl (how to pass arguments)
  - let pkgs = imprt ./file { pkgs='nixpkgs; } {};
  - the second '{}' would allow for passing overlays etc.
  - does not look like the typical 'import <nixpgks> {}'

- Attribute set would be inconvenient for simple "one-remote" scenarios
  - A) let pkgs = (import ./file).nixpkgs {};
  - B) with (import ./nixfile); let pkgs = nixpkgs {}
  - does not look like the typical 'import <nixpgks> {}'

The current solution looks simple and close to classical channel import,
but also has some downsides that feel not very problematic:

- Import of "raw", non-imported remotes must be specified when pinning the remote. This is not the standard use case and having an double import (import (import ./file) {}) in such cases is a minor annoyance.
- Information about the remove channel is embedded as comment meta data. This requires parsing in the update script. That is not nice, but the details is hidden from the ordinary user, does acceptable
