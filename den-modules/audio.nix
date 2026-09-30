{
  den.aspects.audio.includes = [
    # static, applies everywhere
    {
      nixos = { pkgs, ... }: {
        # Enable PipeWire with JACK support
        services.pipewire = {
          enable = true;
          audio.enable = true;
          jack.enable = true;
        };

        # Real-time permissions for audio group
        security.pam.loginLimits = [
          {
            domain = "@audio";
            type = "soft";
            item = "memlock";
            value = "unlimited";
          }
          {
            domain = "@audio";
            type = "hard";
            item = "memlock";
            value = "unlimited";
          }
          {
            domain = "@audio";
            type = "soft";
            item = "rtprio";
            value = "95";
          }
          {
            domain = "@audio";
            type = "hard";
            item = "rtprio";
            value = "99";
          }
        ];
      };

      homeManager =
        { pkgs, ... }:
        {
          home.packages = with pkgs; [
            ardour
            reaper
            qjackctl
            qpwgraph # graphical patchbay
            pavucontrol
          ];
        };
    }

    # applies for a user
    {
      nixos = { user, pkgs, ... }: {
        # Add your user to the audio group
        users.users.${user.name}.extraGroups = [ "audio" ];
      };
    }
  ];
}
