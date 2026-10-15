{
  pkgs,
  lib,
  globals,
  ...
}:
{
  programs = {
    fish = {
      enable = true;
      shellAbbrs = {
        "-" = "cd -";
        ".." = "cd ..";
        "..." = "cd ../..";
        "...." = "cd ../../..";
        "....." = "cd ../../../..";
        "......" = "cd ../../../../..";
        bn = "cmake -B build";
        bnb = "cmake -B build && cmake --build build";
        bb = "cmake --build build";
        bt = "cmake --build build -t test";
        bi = "cmake --build build -t install";
        da = "direnv allow";
        db = "direnv block";
        gc = {
          expansion = "git commit -am '%'";
          setCursor = true;
        };
        gd = "git difftool";
        gst = "git status";
        gp = "git push";
        gf = "git fetch --all --prune";
        gcaf = "git commit -a --fixup";
        gcan = "git commit -a --amend --no-edit";
        gch = "git checkout";
        v = "hx";
      };

      shellAliases = {
        "+" = "echo";
        cp = "cp -r";
        mv = "mv -v";
        rm = "rm -Iv";
        watch = "watch --color -d";
      };
      preferAbbrs = true;
    };
    starship = {
      enable = true;
      presets = [
        "nerd-font-symbols"
      ];
      settings = {
        format = "┬─ $all$time$line_break╰─ $jobs$battery$status$container$os$shell$character";
        time.disabled = false;
        status.disabled = false;
        package.disabled = true;
        os.disabled = false;
      };
    };
    zoxide = {
      enable = true;
      options = [
        "--cmd"
        "cd"
      ];
    };
  };
}
