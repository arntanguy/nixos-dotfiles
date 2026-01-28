{
  description = "S13L custom NixOS + Home Manager config";

  inputs = {
    nixpkgs = {
      url = "github:nixos/nixpkgs/nixos-25.11";
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
      globals = {
        # this are the variables that you wanna change xd
        UserName = "arnaud"; 
        HostName = "arnaud";
        GitName = "Arnaud TANGUY";
        GitEmail = "arn.tanguy@gmail.com";
        Bwserver = "https://vault.arntanguy.fr";
      };

      # Define an overlay to override some packages
      overlays =  [
        (final: prev: {
          # see https://github.com/Supreeeme/xwayland-satellite/issues/210
          # This fixes drag and drop issues in Niri + xwayland-satellite, in particular in davinci resolve
          xwayland-satellite = inputs.xwayland-satellite.packages.${system}.default;
        })
      ];
      # define a new package set replacing nixpkgs input with the overlayed nixpkgs set
      pkgs = import nixpkgs {
        inherit system overlays;
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
        pkgs = pkgs; # pass your overlayed pkgs
      };
    };
}
