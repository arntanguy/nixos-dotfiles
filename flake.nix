{
  description = "S13L custom NixOS + Home Manager config";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.11";
    home-manager = {
        url = "github:nix-community/home-manager";
        inputs.nixpkgs.follows = "nixpkgs";
    };
    nixCats = {
      # url = "github:BirdeeHub/nixCats-nvim?dir=templates/example";
      url = "github:arntanguy/nvim-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      home-manager,
      nixCats,
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

    in
    {
      nixosConfigurations.${globals.HostName} = nixpkgs.lib.nixosSystem {
        inherit system;
        specialArgs = { inherit globals; inherit inputs; };
        modules = [
          ./configuration.nix
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
