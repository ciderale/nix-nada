self: super: {
  nix-pinning = self.callPackage ./nix-pinning.nix {};
  lorri = self.callPackage ./lorri.nix { };
  myzsh = self.callPackage ./zsh.nix {};
  myvim = self.callPackage ./vim { git = self.gitFull; };
  linix = self.callPackage ./linix.nix {};
  inherit (self.callPackage ./strictShell.nix {}) scripts strictShell;
}
