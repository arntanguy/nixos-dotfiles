{
  pkgs,
  lib,
  config,
  globals,
  ...
}:
{
  options = {
    modules.audio.enable = lib.mkEnableOption "enables audio configuration (PipeWire, JACK, real-time, etc)";
  };

  config = lib.mkIf config.modules.audio.enable {
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

    # Add your user to the audio group (replace 'arnaud' if needed)
    users.users.${globals.UserName}.extraGroups = [ "audio" ];

    # Optionally install Ardour
    # environment.systemPackages = [ pkgs.ardour ];
  };
}
