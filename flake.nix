{
  description = "arntanguy's custom NixOS + Home Manager config";

  inputs = {
    nixpkgs = {
      url = "github:nixos/nixpkgs/nixos-unstable";
    };
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixCats = {
      url = "github:arntanguy/nvim-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nvim-wrapper = {
      url = "github:arntanguy/nvim-wrapper";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # secrets management
    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Treefmt framework integration
    treefmt-nix = {
      url = "github:numtide/treefmt-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  # See https://birdeehub.github.io/nix-wrapper-modules/md/getting-started.html
  inputs.wrappers.url = "github:BirdeeHub/nix-wrapper-modules";
  inputs.wrappers.inputs.nixpkgs.follows = "nixpkgs";

  outputs =
    {
      nixpkgs,
      home-manager,
      sops-nix,
      wrappers,
      treefmt-nix,
      ...
    }@inputs:
    let
      system = "x86_64-linux";

      # Define global overlays natively fed into the NixOS system builders
      overlays = [
        (final: prev: {
          # Keep this if still needed, or remove if unstable gvfs works fine now
          gnome = prev.gnome.overrideScope (
            gfinal: gprev: {
              gvfs = gprev.gvfs.override {
                gnomeSupport = true;
              };
            }
          );
        })
      ];

      # Configure treefmt eval for your system (using raw nixpkgs legacyPackages)
      treefmtEval = treefmt-nix.lib.evalModule nixpkgs.legacyPackages.${system} {
        projectRootFile = "flake.nix";

        # Configure the formatters you want to use
        programs.nixfmt.enable = true; # Formatter for Nix files
        programs.mdformat.enable = true; # Formatter for Markdown files
      };
    in
    {
      nixosConfigurations."arnaud" = nixpkgs.lib.nixosSystem {
        inherit system;
        specialArgs = {
          inherit inputs;
          globals = import ./hosts/dell-precision-work/globals.nix;
        };
        modules = [
          # Native nixpkgs configuration block for this host evaluation tree
          {
            nixpkgs.config.allowUnfree = true;
            nixpkgs.config.permittedInsecurePackages = [
              "libsoup-2.74.3"
              "electron-39.8.10"
            ];
            nixpkgs.overlays = overlays;
          }
          ./hosts/dell-precision-work/configuration.nix
          ./modules
        ];
      };

      # dell precision 5570 for panda control (old Julien's laptop)
      nixosConfigurations."lirmm-bamboo" = nixpkgs.lib.nixosSystem {
        inherit system;
        specialArgs = {
          inherit inputs;
          globals = import ./hosts/lirmm-bamboo/globals.nix;
        };
        modules = [
          {
            nixpkgs.config.allowUnfree = true;
            nixpkgs.config.permittedInsecurePackages = [
              "libsoup-2.74.3"
            ];
            nixpkgs.overlays = overlays;
          }
          ./hosts/lirmm-bamboo/configuration.nix
          ./modules
          # inputs.nvim-wrapper.nixosModules.default
        ];
      };

      # alienware for panda control
      nixosConfigurations."rob-alienware" = nixpkgs.lib.nixosSystem {
        inherit system;
        specialArgs = {
          inherit inputs;
          globals = import ./hosts/rob-alienware/globals.nix;
        };
        modules = [
          {
            nixpkgs.config.allowUnfree = true;
            nixpkgs.config.permittedInsecurePackages = [
              "libsoup-2.74.3"
            ];
            nixpkgs.overlays = overlays;
          }
          ./hosts/rob-alienware/configuration.nix
          ./modules
        ];
      };

      # Expose the formatter wrapper to the flake outputs
      formatter.${system} = treefmtEval.config.build.wrapper;
    };
}
