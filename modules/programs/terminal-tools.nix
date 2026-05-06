{ pkgs, lib, config, ... }:
{
  options = {
    modules.programs.terminal-tools.enable = 
      lib.mkEnableOption "enables terminal apps (unzip, tmux, etc)";
  };

  config = lib.mkIf config.modules.programs.terminal-tools.enable {
    environment.systemPackages = with pkgs; [
      unzip
      neovim
      bat # better cat
      btop
      curl
      fastfetch
      fzf
      jq
      lsd # better ls
      ripgrep
      starship
      tmux
      wget
      dua # disk usage analyzer
      # Nix/NixOS Tools
      nh
      imagemagick
      nmap
      acpi
    ];
  };
}
