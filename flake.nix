{
  description = "arntanguy's custom NixOS + Home Manager config";

  inputs = {
    nixpkgs = {
      url = "github:nixos/nixpkgs/nixos-25.11";
    };
    nixpkgs-unstable = {
      url = "github:nixos/nixpkgs/nixos-unstable";
    };
    xwayland-satellite = {
      url = "github:Supreeeme/xwayland-satellite";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
        url = "github:nix-community/home-manager";
        inputs.nixpkgs.follows = "nixpkgs";
    };
    nixCats = {
      # url = "github:BirdeeHub/nixCats-nvim?dir=templates/example";
      # url = "github:arntanguy/nvim-nix";
      # url = "git+file:./modules/home/nvim-nix?submodules=1";
      url = "github:arntanguy/nvim-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # secrets management
    sops-nix = {
        url = "github:Mic92/sops-nix";
        inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      nixpkgs,
      home-manager,
      sops-nix,
      ...
    }@inputs:
    let
      system = "x86_64-linux";

      # Define an overlay to override some packages
      overlays =  [
        (final: prev: {
          # see https://github.com/Supreeeme/xwayland-satellite/issues/210
          # This fixes drag and drop issues in Niri + xwayland-satellite, in particular in davinci resolve
          xwayland-satellite = inputs.xwayland-satellite.packages.${system}.default;
          # FIXME: this overlay is done to force-enable google-accounts support in gvfs, which is required for google-drive support in nautilus.
          # This is necessary for nixos 25.11, as google account support is disabled by default as there are security vulnerabilities
          # in libsoup. see https://github.com/NixOS/nixpkgs/issues/438121
          # required by modules/nautilus.nix
          gnome = prev.gnome.overrideScope (gfinal: gprev: {
            gvfs = gprev.gvfs.override {
              googleSupport = true;
              gnomeSupport = true;
            };
          });
        })
      ];
      # define a new package set replacing nixpkgs input with the overlayed nixpkgs set
      pkgs = import nixpkgs {
        inherit system overlays;
        config = {
          allowUnfree = true;
          permittedInsecurePackages = [
            # Required by gnome.gvfs.googleSupport in nixkpgs overlay
            "libsoup-2.74.3" 
          ];
        };
      };
    in
    {
      nixosConfigurations."arnaud" = nixpkgs.lib.nixosSystem {
        inherit system;
        specialArgs = 
        {
          inherit inputs; 
          globals = import ./hosts/dell-precision-work/globals.nix;
          unstablePkgs = import inputs.nixpkgs-unstable {
            system = system;
            config.allowUnfree = true;
          };
        };
        modules = [
          ./hosts/dell-precision-work/configuration.nix
          ./modules
        ];
        pkgs = pkgs; # pass your overlayed pkgs
      };

      # dell precision 5570 for panda control (old Julien's laptop)
      nixosConfigurations."lirmm-bamboo" = nixpkgs.lib.nixosSystem {
        inherit system;
        specialArgs = 
        { 
          inherit inputs; 
          globals = import ./hosts/lirmm-bamboo/globals.nix;
        };
        modules = [
          ./hosts/lirmm-bamboo/configuration.nix
          ./modules
        ];
        pkgs = pkgs;
      };
    };
}
