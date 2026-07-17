{ pkgs, ... }:
{
  programs.ghostty = {
    enable = true;
    settings = {
      window-decoration = "none";
      keybind = "shift+insert=paste_from_clipboard";
    };
  };
  programs.kitty = {
    enable = true;

    settings = {
      # # Set the outer border width to zero
      # window_border_width = "0";
      #
      # # Remove the internal padding between the text and the window edge
      # window_padding_width = "0";
      #
      # # Hide window decorations completely (removes titlebar and borders on wayland/x11)
      # hide_window_decorations = "yes";

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
}
