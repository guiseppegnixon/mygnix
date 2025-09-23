{
  description = "Stage 1 - Implement Impermanence";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    impermanence.url = "github:nix-community/impermanence";

  };

  outputs = { self, nixpkgs, impermanence, ... }: {
    nixosConfigurations.laptop = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        ./configuration.nix
        impermanence.nixosModules.impermanence
      ];
    };
  };
}
