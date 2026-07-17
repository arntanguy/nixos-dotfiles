{ pkgs, ... }:
{
  programs.kitty = {
    enable = true;

    settings = {
      background_opacity = "0.76";
      draw_minimal_borders = "yes";
      window_padding_width = "2";
      window_border_width = "0";
      hide_window_decorations = "yes";
      titlebar-only = "yes";
      active_border_color = "none";
    };
  };
  home.packages = with pkgs; [
    fzf
  ];

  programs.ghostty = {
    enable = true;
    settings = {
      window-decoration = "none";
      keybind = "shift+insert=paste_from_clipboard";
    };
  };
}
