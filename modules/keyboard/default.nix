{ pkgs, lib, config, ... }:
{
  options = {
    modules.keyboard-mods = {
      enable = lib.mkEnableOption "enables keyboard-mods (kmonad, home-row mods, etc)";
      layout = lib.mkOption {
        type = lib.types.str;
        default = "us";
        description = "Keyboard layout (e.g., 'us', 'fr', 'de').";
        example = "fr";
      };
      variant = lib.mkOption {
        type = lib.types.str;
        default = "";
        description = "Keyboard layout variant (optional).";
        example = "altgr-intl";
      };
    };
  };

  config = lib.mkIf config.modules.keyboard-mods.enable {
    services.xserver.xkb = {
      layout = config.modules.keyboard-mods.layout;
      variant = config.modules.keyboard-mods.variant;
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
