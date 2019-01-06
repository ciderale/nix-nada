# Configuration of a user environment

- `nix-shell --pure`: try the configuration in a shell
- `nix-env -f ./default.nix -iA buildInputs` permanent installation

# Various samples (jupyter, docker usage, etc on osx)

- the configuration for jupyter is currently not maintained

# Notes:

- use a custom nixpkgs definition in nix-shell/nix-build
      nix-shell -I nixpkgs=${HOME}/.nix-defexpr/channels/unstable/ --pure
  nix-env uses the references in .nix-defexpr automatically
  pinning the nixpkgs version explicitly avoid this step

# Some blog posts

- Overlays Mechanism (including link to slides & talk)
  - https://blog.flyingcircus.io/2017/11/07/nixos-the-dos-and-donts-of-nixpkgs-overlays/

- very short example
http://techblog.holidaycheck.com/post/2017/11/14/nix-in-practice-providing-dependencies
