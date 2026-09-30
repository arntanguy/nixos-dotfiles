{
  config,
  pkgs,
  lib,
  globals,
  ...
}:
{
  options = {
    modules.syncthing.enable = lib.mkEnableOption "enables syncthing";
  };

  config = lib.mkIf config.modules.syncthing.enable {
    services.syncthing = {
      enable = true;
      user = "${globals.UserName}"; # Or use config.users.users.arnaud.name if defined
      # Override all settings set from the GUI.  This is necessary if I don't want
      # to have changes made from the GUI apply.
      overrideDevices = true;
      overrideFolders = true;
      dataDir = "/home/${globals.UserName}/Sync"; # Default folder for new synced folders
      configDir = "/home/${globals.UserName}/.config/syncthing"; # Folder for Syncthing's settings and keys
      openDefaultPorts = true;
      guiAddress = "0.0.0.0:8385";
      guiPasswordFile = config.sops.secrets."data/syncthing/${globals.UserName}/password".path;
      settings = {
        devices = {
          "syncthing.arntanguy.fr" = {
            id = "BEHCUNH-5ETNA7F-WEVMHST-7GDZXCB-2PRVVMT-ZFERPA5-6HCXBFY-A2IH7AQ";
            addresses = [ "tcp://arntanguy.fr:22000" ]; # Replace with your peer's public IP and port
          };
        };
        gui = {
          user = "arnaud"; # Set your desired GUI username here
          # Do NOT set 'password' here if using guiPasswordFile
        };
      };
      folders = {
        "zotero-storage" = {
          label = "zotero-storage";
          path = "/home/${globals.UserName}/Zotero/storage";
          # share with these devices
          devices = [
            "syncthing.arntanguy.fr"
          ];
        };
        "obsidian-vault" = {
          label = "obsidian-vault";
          path = "/home/${globals.UserName}/Obsidian Vault";
          # share with these devices
          devices = [
            "syncthing.arntanguy.fr"
          ];
        };
        "core-x4-camera" = {
          label = "core-x4-camera";
          path = "/home/${globals.UserName}/Sync/core-x4-camera";
          # share with these devices
          devices = [
            "syncthing.arntanguy.fr"
          ];
        };
      };
    };
  };
}
