self: super: {
  nix-pinning = self.callPackage ./nix-pinning.nix {};
  lorri = self.callPackage ./lorri.nix { };
  myzsh = self.callPackage ./zsh.nix {};
  myvim = self.callPackage ./vim { git = self.gitFull; };
}
