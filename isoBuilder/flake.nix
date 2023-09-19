# flake.nix
{
  description = "Example";
  inputs.nixos.url = "github:nixos/nixpkgs/nixos-unstable";
  outputs = {
    self,
    nixos,
  }: {
    nixosConfigurations = let
      # Shared base configuration.
      exampleBase = {
        system = "x86_64-linux";
        modules = [
          ./iso.nix
        ];
      };
    in {
      Iso = nixos.lib.nixosSystem {
        inherit (exampleBase) system;
        modules =
          exampleBase.modules
          ++ [
            # Whatever nixos system configuration you want
            ./iso.nix #some basic stuff I'll generally want to include
            "${nixos}/nixos/modules/installer/cd-dvd/installation-cd-minimal"
          ];
      };
    };
  };
}
