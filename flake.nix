{
  description = "YiFENG's NixOS configuration";

  inputs = {
    # nixos-26.05 channel tarball from the USTC mirror, the same source
    # `nix-channel --update` pulls from. Run `nix flake update` to refresh.
    nixpkgs = {
      type = "tarball";
      url = "https://mirrors.ustc.edu.cn/nix-channels/nixos-26.05/nixexprs.tar.xz";
    };

    # nixos-unstable channel, used for packages that need newer versions
    # than the 26.05 pin (e.g. clash-verge-rev). Mix per package with
    # `pkgs-unstable.<name>`.
    nixpkgs-unstable = {
      type = "tarball";
      url = "https://mirrors.ustc.edu.cn/nix-channels/nixos-unstable/nixexprs.tar.xz";
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

    # Noctalia desktop shell. Keeps its own nixpkgs pin so the derivations
    # match the noctalia.cachix.org binary cache; following our nixpkgs
    # would force building the shell from source.
    noctalia.url = "github:noctalia-dev/noctalia";

    # Noctalia greeter (greetd login screen). Not packaged in nixpkgs
    # 26.05, so the module and package come from the project flake.
    noctalia-greeter = {
      url = "github:noctalia-dev/noctalia-greeter";
      # Reuse the nixpkgs above instead of dragging in a second copy
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    { self, nixpkgs, nixpkgs-unstable, home-manager, nixos-wsl, noctalia
    , noctalia-greeter, ... }:
    {
      nixosConfigurations = {
        # Graphical desktop host
        beryllium = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          # Inputs for the graphical modules in modules/nixos/desktop-env.nix.
          specialArgs = {
            inherit noctalia noctalia-greeter;
            pkgs-unstable = import nixpkgs-unstable { system = "x86_64-linux"; };
          };
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
