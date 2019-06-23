self: super: {
  nix-pinning = self.callPackage ./nix-pinning.nix {};
  nix-update = self.callPackage ./nix-update.nix {};
  lorri = self.callPackage ./lorri.nix { };
  myzsh = self.callPackage ./zsh.nix {};
  myvim = self.callPackage ./vim { git = self.gitFull; };
}
