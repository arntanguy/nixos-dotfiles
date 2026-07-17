{
  config,
  lib,
  pkgs,
  globals,
  ...
}:

{
  home.stateVersion = "26.05";

  imports =
    [ ]
    ++ lib.optional globals.enableWaybar ./waybar/waybar.nix
    ++ lib.optional globals.enableNiri ./niri/niri.nix
    ++ lib.optional globals.enableBash ./bash.nix
    ++ lib.optional globals.enableZsh ./zsh/zsh.nix
    ++ lib.optional globals.enableFuzzel ./fuzzel/fuzzel.nix
    ++ lib.optional globals.enableTmux ./tmux.nix
    ++ lib.optional globals.enableGhostty ./ghostty.nix
    ++ lib.optional globals.enableGit ./git.nix
    ++ lib.optional globals.enableGit ./lazygit/lazygit.nix
    ++ lib.optional globals.enableScripts ./scripts/scripts.nix
    ++ lib.optional globals.enableNvidia ./nvidia.nix
    ++ lib.optional globals.enableSsh ./ssh/ssh.nix
    ++ lib.optional globals.enableEmail ./email.nix
    ++ lib.optional globals.enableBitwarden ./bw.nix;
  # ++ lib.optional globals.enableDavinciResolve ./davinci-resolve.nix;

  dconf.settings = {
    "org/gnome/desktop/interface" = {
      color-scheme = "prefer-dark";
    };
  };
  gtk = {
    enable = true;
    theme.name = "Adwaita-dark";

    colorScheme = "dark";
  };
  qt = {
    enable = true;
    style.name = "adwaita-dark";
  };
  home.pointerCursor = {
    enable = true;
    gtk.enable = true;
    package = pkgs.catppuccin-cursors.mochaSapphire;
    name = "catppuccin-mocha-sapphire-cursors";
    size = 12;
  };

  ########################################
  # 🧬 Git config
  ########################################
  programs = {
    go.enable = true;
    bash.enable = true;
    zoxide.enable = true;
    obs-studio.enable = true;
    obs-studio.plugins = [ pkgs.obs-studio-plugins.wlrobs ];

  };

  services.awww.enable = true;
  services.swaync.enable = true;

}
