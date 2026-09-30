{
  den.aspects.communication = {
    nixos = { pkgs, ... }: {
      environment.systemPackages = with pkgs; [
        element-desktop # matrix
        slack
        zoom-us
        discord
      ];
    };
  };
}
