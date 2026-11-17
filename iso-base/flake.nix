{
  description = "Minimal NixOS installation media";
  inputs.nixos.url = "github:nixos/nixpkgs/nixos-26.05";
  inputs.nixos-common.url = "github:jhollowe-infra/nixos-common";
  outputs = { self, nixos, nixos-common }: {
    nixosConfigurations."iso-base" = nixos.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = { inherit nixos-common; };
      modules = [
        "${nixos}/nixos/modules/installer/cd-dvd/installation-cd-minimal.nix"
        ./configuration.nix
      ];
    };

  };
}
