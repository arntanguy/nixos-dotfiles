{
  inputs,
  den,
  lib,
  ...
}:
{
  imports = [ inputs.den.flakeModule ];

  den.schema.user.classes = lib.mkDefault [ "homeManager" ];

  # Define new hosts here
  den.hosts.x86_64-linux.dell-precision-work.users.arnaud = { };
  # den.hosts.aarch64-darwin.iceberg.users.arnaud = {};

  # These run for host "dell-precision-work"
  den.aspects.dell-precision-work = {
    includes = [ den.batteries.hostname ];
    nixos = { pkgs, ... }: { environment.systemPackages = [ pkgs.hello ]; };
  };

  # These run for user "arnaud"
  den.aspects.arnaud = {
    # Include the aspects that the user should have here
    includes = [
      den.batteries.define-user
      den.batteries.primary-user
      den.aspects.dev-tools
      den.aspects.office
      den.aspects.communication
      den.aspects.terminal-tools
      den.aspects.audio
      den.aspects.bash
    ];
    # nixos = { pkgs, ... }: { environment.systemPackages = [ pkgs.hello ]; };
    homeManager = { pkgs, ... }: {
      home.packages = [
        pkgs.vim
        pkgs.cowsay
      ];

      programs.bash = {
        shellAliases = {
          token_cachix = "rbw get token_mc-rtc-nix-cachix";
          token_attic_aist = "rbw get token_attic";
          token_copy_rofi = "rofi-rbw -a copy --clipboarder wl-copy -t password -r 'Copy pwd: '";
          token_print_rofi = "rofi-rbw -a print -t password -r 'Print pwd: '";
          booo = "echo 'booo'";
        };
      };
    };
  };
}
