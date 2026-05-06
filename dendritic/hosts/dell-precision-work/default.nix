{ self, inputs, ... }: {
  flake.nixosConfigurations.dell-precision-work = inputs.nixpkgs.lib.nixosSystem {
    modules = [
      self.nixosModules.dell-precision-work-configuration
    ];
  };
}
