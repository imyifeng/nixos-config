{
  description = "YiFENG's NixOS configuration";

  inputs = {
    # nixos-26.05 channel tarball from the USTC mirror, the same source
    # `nix-channel --update` pulls from. Run `nix flake update` to refresh.
    nixpkgs = {
      type = "tarball";
      url = "https://mirrors.ustc.edu.cn/nix-channels/nixos-26.05/nixexprs.tar.xz";
    };

    home-manager = {
      url = "github:nix-community/home-manager/release-26.05";
      # Reuse the nixpkgs above instead of dragging in a second copy
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixos-wsl = {
      url = "github:nix-community/NixOS-WSL/release-26.05";
      # Reuse the nixpkgs above instead of dragging in a second copy
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    { self, nixpkgs, home-manager, nixos-wsl, ... }:
    {
      nixosConfigurations = {
        # Graphical desktop host
        beryllium = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          modules = [
            home-manager.nixosModules.home-manager
            ./hosts/beryllium
          ];
        };

        # WSL guest on the helium machine
        helium-nixos-wsl = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          modules = [
            home-manager.nixosModules.home-manager
            nixos-wsl.nixosModules.default
            ./hosts/helium-nixos-wsl
          ];
        };
      };
    };
}
