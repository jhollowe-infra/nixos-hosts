{
  description = "jhollowe's NixOS Host configurations";

  inputs = {
    # Nixpkgs Stable - https://github.com/NixOS/nixpkgs
    nixpkgs.url = "github:nixos/nixpkgs/nixos-26.05";

    # Nixpkgs Unstable
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";

    # Disko (Disk Config)
    disko.url = "github:nix-community/disko";
    disko.inputs.nixpkgs.follows = "nixpkgs";

    # Home Manager - https://github.com/nix-community/home-manager
    # home-manager.url = "github:nix-community/home-manager/release-26.05";
    # home-manager.inputs.nixpkgs.follows = "nixpkgs";

    # Atomic, declarative, and reproducible secret provisioning for NixOS based on sops.
    # sops-nix.url = "github:Mic92/sops-nix";
    # sops-nix.inputs.nixpkgs.follows = "nixpkgs";

    # For VS Code Remote to work on NixOS
    # vscode-server.url = "github:nix-community/nixos-vscode-server";

    # Community VS Code Extensions
    # nix-vscode-extensions.url = "github:nix-community/nix-vscode-extensions";

    # For managing KDE Plasma
    # plasma-manager.url = "github:pjones/plasma-manager";
    # plasma-manager.inputs.nixpkgs.follows = "nixpkgs";
    # plasma-manager.inputs.home-manager.follows = "home-manager";

    # TODO check this out
    # Deploy-rs
    # deploy-rs.url = "github:serokell/deploy-rs";

    # NixOS Hardware
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    nixos-hardware.inputs.nixpkgs.follows = "nixpkgs";

    # nixos-anywhere (pinned by flake.lock; used by run_vmtest.sh)
    nixos-anywhere.url = "github:nix-community/nixos-anywhere";
    nixos-anywhere.inputs.nixpkgs.follows = "nixpkgs";
    nixos-anywhere.inputs.disko.follows = "disko";

    # personal common configurations
    nixos-common.url = "github:jhollowe-infra/nixos-common";
  };

  outputs = { self, nixpkgs, disko, nixos-common, nixos-hardware, ... }:
    {

      nixosConfigurations = {
        lap02 = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          specialArgs = { inherit nixos-common nixos-hardware; };
          modules = [
            disko.nixosModules.disko
            ./lap02/configuration.nix
          ];
        };
        test = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          specialArgs = { inherit nixos-common; };
          modules = [
            disko.nixosModules.disko
            ./test/configuration.nix
          ];
        };
        vps01 = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          specialArgs = { inherit nixos-common; };
          modules = [
            disko.nixosModules.disko
            ./vps01/configuration.nix
          ];
        };
        "hl01-devnix01" = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          specialArgs = { inherit nixos-common; };
          modules = [
            disko.nixosModules.disko
            ./hl01-devnix01/configuration.nix
          ];
        };
      };
    };
}
