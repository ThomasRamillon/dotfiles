# /etc/nixos/flake.nix
{
  description = "flocon";

  inputs = {
    nixpkgs = {
      url = "github:NixOS/nixpkgs/nixos-unstable";
    };
    zen-browser.url = "github:0xc000022070/zen-browser-flake";
  };

  outputs = { self, nixpkgs, zen-browser}@inputs: {
    nixosConfigurations = {
      systematr = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = { inherit inputs;};
        modules = [
          ./configuration.nix
        ];
      };
    };
  };
}
