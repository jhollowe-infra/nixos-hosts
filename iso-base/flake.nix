{
  description = "Minimal NixOS installation media";
  inputs.nixos.url = "nixpkgs/24.05";
  outputs = { self, nixos }: {
    nixosConfigurations."iso-base" = nixos.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        "${nixos}/nixos/modules/installer/cd-dvd/installation-cd-minimal.nix"
        ./configuration.nix
      ];
    };

  };
}
