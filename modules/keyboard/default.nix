{ pkgs, lib, config, globals, ... }:
{
  options = {
    modules.keyboard-mods = {
      enable = lib.mkEnableOption "enables keyboard-mods (kmonad, home-row mods, etc)";
    };
  };

  config = lib.mkIf config.modules.keyboard-mods.enable {
    services.xserver.xkb = {
      layout = "${globals.xkb.layout}";
      variant = "";
      options = "${globals.xkb.options}";
     };

    environment.systemPackages = with pkgs; [
      kmonad
    ];

    # home-row mods
    # see https://precondition.github.io/home-row-mods
    services.kmonad = {
     enable = true;
     keyboards = {
       myKMonadOutput = {
         defcfg = {
           enable = true;
           fallthrough = true;
         };
         # XXX how to configure per-host?
         device = "/dev/input/by-path/platform-i8042-serio-0-event-kbd";
         config = builtins.readFile ./kmonad/config.kbd;
       };
     };
    };
  };
}
