{ pkgs, ... }: {
  home.packages = with pkgs; [
    (writeShellApplication {
      name = "script-davinci-resolve-convert";
      runtimeInputs = [ ffmpeg ];
      text = builtins.readFile ./davinci-resolve-convert.sh;
    })
    (writeShellApplication {
      name = "script-davinci-resolve-compress-export";
      runtimeInputs = [ ffmpeg ];
      text = builtins.readFile ./davinci-resolve-compress-export.sh;
    })
  ];
}
