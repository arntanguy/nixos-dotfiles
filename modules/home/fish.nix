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
      interactiveShellInit = ''
        set -x CMAKE_CXX_COMPILER_LAUNCHER ccache
        set -x EDITOR nvim
      '';
      functions = {
        nurl-aist = ''
          function nurl-aist
            if test (count $argv) -eq 0
              echo "Usage: nurl-aist <repo> [REV]"
              return 1
            end
            nurl https://github.com/isri-aist/$argv
          end
        '';
        nurl-jrl = ''
          function nurl-jrl
            if test (count $argv) -eq 0
              echo "Usage: nurl-jrl <repo> [REV]"
              return 1
            end
            set -l url "https://github.com/jrl-umi3218/$argv[1]"
            if test (count $argv) -gt 1
              nurl $url $argv[2..-1]
            else
              nurl $url
            end
          end
        '';
        nurl-gh = ''
          function nurl-gh
            if test (count $argv) -eq 0
              echo "Usage: nurl-gh <org>/<repo> [REV]"
              return 1
            end
            set -l url "https://github.com/$argv[1]"
            if test (count $argv) -gt 1
              nurl $url $argv[2..-1]
            else
              nurl $url
            end
          end
        '';
      };
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

        ghqpr = "gh pr comment -b '@mergifyio queue'";
        ghco = "gh checkout";
        # nurl-aist = "function _nurl_aist; nurl https://github.com/isri-aist/$argv; end; _nurl_aist";
        # nurl-jrl = "function _nurl_aist; nurl https://github.com/jrl-umi3218/$argv; end; _nurl_aist";
        # nurl-gh = "function _nurl_aist; nurl https://github.com/$argv; end; _nurl_aist";
      }
      // lib.optionalAttrs globals.enableBitwarden {
        token_cachix = "rbw get token_mc-rtc-nix-cachix";
        token_attic_aist = "rbw get token_attic";
        token_copy_rofi = "rofi-rbw -a copy --clipboarder wl-copy -t password -r 'Copy pwd: '";
        token_print_rofi = "rofi-rbw -a print -t password -r 'Print pwd: '";
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
