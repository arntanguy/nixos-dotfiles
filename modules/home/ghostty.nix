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
      # Set the outer border width to zero
      window_border_width = "0";

      # Remove the internal padding between the text and the window edge
      window_padding_width = "0";

      # Hide window decorations completely (removes titlebar and borders on wayland/x11)
      hide_window_decorations = "yes";
    };
  };
}
