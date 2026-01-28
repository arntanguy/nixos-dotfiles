{
  description = "S13L custom NixOS + Home Manager config";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.11";
    nixos-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    niri = {
      url = "github:YaLTeR/niri";
      inputs.nixpkgs.follows = "nixos-unstable";
    };
    xwayland-satellite = {
      url = "github:Supreeeme/xwayland-satellite";
      inputs.nixpkgs.follows = "nixos-unstable";
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
      globals = {
        # this are the variables that you wanna change xd
        UserName = "arnaud"; 
        HostName = "arnaud";
        GitName = "Arnaud TANGUY";
        GitEmail = "arn.tanguy@gmail.com";
        Bwserver = "https://vault.arntanguy.fr";
      };

      # Add an overlay to override some packages from nixos-unstable
      # {
      unstablePkgs = import inputs.nixos-unstable {
        system = system;
        config.allowUnfree = true;
      };
      overlays = [
        (final: prev: {
          # niri = unstablePkgs.niri;
          # xwayland-satellite = unstablePkgs.xwayland-satellite;
          niri = inputs.niri.packages.${system}.default;
          # niri = unstablePkgs.niri;
          xwayland = unstablePkgs.xwayland;
          # xwayland-satellite = unstablePkgs.xwayland-satellite;
          xwayland-satellite = builtins.trace "Using flake input for xwayland-satellite: ${inputs.xwayland-satellite.packages.${system}.default.pname or "unknown"}" (assert inputs.xwayland-satellite.packages.${system}.default != null; inputs.xwayland-satellite.packages.${system}.default);
          davinci-resolve = unstablePkgs.davinci-resolve;
        })
      ];
      pkgs = import nixpkgs {
        inherit system;
        overlays = overlays;
        config.allowUnfree = true;
      };
    in
    {
      nixosConfigurations.${globals.HostName} = nixpkgs.lib.nixosSystem {
        inherit system;
        specialArgs = { inherit globals; inherit inputs; };
        modules = [
          ./configuration.nix
          sops-nix.nixosModules.sops
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.extraSpecialArgs = { inherit globals; };
            home-manager.users.${globals.UserName} = import ./modules/home/home.nix;
          }
        ];
      };
    };
}
