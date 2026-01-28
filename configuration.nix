{
  pkgs,
  config,
  globals,
  inputs,
  ...
}:

{
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
  ];

  sops = {
    age.keyFile = "/home/arnaud/.config/sops/age/keys.txt";
    defaultSopsFile = ./secrets/secrets.yaml;
    defaultSopsFormat = "yaml";
    # secrets are available as root in /run/secrets/<path> by default
    secrets = {
        "data/networking/wifi/LIRMM"= { };
        "ssh_keys/arnaud-dell-precision7560" = {
          path = "/home/${globals.UserName}/.ssh/id_arnaud-dell-precision7560";
          owner = globals.UserName;
        };
    };
  };

  # Bootloader
  boot.loader = {
    systemd-boot.enable = false;
    grub.enable = true;
    grub.device = "nodev";
    grub.theme = pkgs.fetchFromGitHub {
      owner = "shvchk";
      repo = "fallout-grub-theme";
      rev = "80734103d0b48d724f0928e8082b6755bd3b2078";
      sha256 = "sha256-7kvLfD6Nz4cEMrmCA9yq4enyqVyqiTkVZV5y4RyUatU=";
    };
    grub.efiSupport = true;
    grub.useOSProber = true;
    efi.canTouchEfiVariables = true;
  };
  boot = {
    kernelPackages = pkgs.linuxPackages;
    supportedFilesystems = [ "ntfs" ];
  };

  networking = {
    hostName = globals.HostName;

    networkmanager = {
     enable = true;
     # Add default profiles to autoconnect
     # Note: secrets are available as files at runtime decripted by sops (in /run/secrets)
     # Set key-value pairs in secrets.yaml, and use the generated file as an environmentFiles entry for network manager. Secrets are then available as variables $SECRET_NAME in network profiles.
     ensureProfiles = {
            environmentFiles = [ config.sops.secrets."data/networking/wifi/LIRMM".path ];
            profiles = {
                LIRMM = {
                  connection = {
                    id = "LIRMM";
                    type = "wifi";
                    autoconnect = true;
                  };
                  wifi = {
                    mode = "infrastructure";
                    ssid = "LIRMM";
                  };
                  wifi-security = {
                    key-mgmt = "wpa-eap";
                  };
                  "802-1x" = {
                    eap = "peap";
                    identity = "$LIRMM_USER"; 
                    password = "$LIRMM_PASSWORD";
                    phase2-auth = "mschapv2";
                  };
                };
                arnaud-android-ap = {
                  connection = {
                    id = "arnaud-android-ap";
                    type = "wifi";
                    autoconnect = false;
                  };
                  wifi = {
                    mode = "infrastructure";
                    ssid = "arnaud";
                  };
                  wifi-security = {
                    key-mgmt = "wpa-psk";
                    psk = "$ARNAUD_ANDROID_AP_PASSWORD";
                  };
                  ipv4 = {
                    method = "auto";
                  };
                  ipv6 = {
                    method = "ignore";
                  };
                };
                robots-ethernet = {
                  connection = {
                    id = "Robots Ethernet";
                    type = "ethernet";
                    autoconnect = false;
                  };
                  ipv4 = {
                    method = "manual";
                    address1 = "10.4.5.42/24"; # for hrp4005c and rhps1
                    address2 = "172.16.0.42/16"; # for panda6 and panda7
                    address3 = "192.168.1.42/24"; # for panda2
                  };
                  ipv6 = {
                    method = "ignore";
                  };
                };
              };
        };
    };
    hosts = {
      "192.168.1.100" = [ "ur10_1" ];
      "192.168.1.200" = [ "ur10_2" ];
      "10.4.5.1" = [ "hrp4005c" ];
      "10.4.5.120" = [ "rhps1" ];
      "172.16.0.6" = [ "panda6" ];
      "172.16.1.7" = [ "panda7" ];
      "192.168.1.2" = [ "panda2" ];
    };
  };

  time.timeZone = "Europe/Paris";
  i18n.defaultLocale = "en_US.UTF-8";

  services.openssh = {
    enable = true;
    # Optional: allow password authentication (default is false)
    passwordAuthentication = true;
    # Optional: allow root login (default is "prohibit-password")
    # permitRootLogin = "no";
    # Optional: open the firewall for SSH
    openFirewall = true;
  };
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };
  services.gvfs.enable = true;
  users.users.${globals.UserName} = {
    isNormalUser = true;
    description = "Main User";
    extraGroups = [
      "wheel"
      "dialout"
      "plugdev"
      "networkmanager"
      "wireshark"
      "docker"
      "input"
    ];
    packages = with pkgs; [
      chromium
    ];
  };

  # Enable CUPS and Avahi (for printer discovery):
  services.printing = {
    enable = true;
    drivers = with pkgs; [
      cups-filters
      cups-browsed
    ];
  };
  # hardware.printers = {
  #   # ensureDefaultPrinter = "robcolor";
  #   ensurePrinters = [
  #     {
  #       deviceUri = "ipp://robcolor.lirmm.fr/ipp";
  #       location = "work";
  #       name = "robcolor";
  #       model = "everywhere";
  #     }
  #   ];
  # };
  # avahi enables resolution of *.local hostnames
  services.avahi = { #
    enable = true;
    nssmdns = true; # This adds mdns to /etc/nsswitch.conf for hosts
    openFirewall = true; # Optional: open mDNS port in firewall
  };

  # home-row mods
  services.kmonad = {
   enable = true;
   keyboards = {
     myKMonadOutput = {
       defcfg = {
         enable = true;
         fallthrough = true;
       };
       device = "/dev/input/by-path/platform-i8042-serio-0-event-kbd";
       config = builtins.readFile ./modules/home/kmonad/config.kbd;
     };
   };
  };

  # See modules/home/nvidia.nix for programs requiring nvidia to run (davinci-resolve, blender, darktable, etc)
  environment.systemPackages = with pkgs; [
    sops
    gnupg
    element-desktop
    zathura # pdf reader
    evince
    wsdd # Web Service Discovery (WSD) host daemon for SMB/Samba
    jmtpfs
    gimp
    eog # eye-of-gnome image viewer
    godot
    krita
    ffmpeg
    jq
    ripgrep
    fzf
    fastfetch
    btop
    starship
    waybar-mpris
    playerctl
    waypaper
    waybar
    swaylock-effects
    swww
    nvidia-vaapi-driver
    nvidia-modprobe
    swaynotificationcenter
    neovim
    inputs.nixCats.packages."${pkgs.system}".nixCats
    helix
    wget
    wl-clipboard-rs
    git
    cmakeCurses
    pre-commit
    glib
    steam-run
    curl
    wlogout
    discord
    slack
    obs-studio
    lsd
    bat
    tmux
    fzf
    lazygit
    gh # github cli
    lazydocker
    fuzzel
    ghostty
    vscode
    adw-gtk3
    papirus-icon-theme
    nh
    nautilus
    gnumake
    go
    gopls
    musl
    gcc
    ly
    fastfetch
    btop
    steam
    pavucontrol
    bitwarden-desktop
    docker
    docker-compose
    devpod
    polkit
    nixfmt-rfc-style
    obsidian
    nmap
    openvpn
    hashcat
    burpsuite
    caido
    wireshark
    wordlists
    rockyou
    seclists
    metasploit
    gobuster
    ffuf
    sqlmap
    john
    thc-hydra
    qbittorrent

    zoom-us

    grub2
    xwayland
    xwayland-satellite
    bzmenu # for bluetooth
    pciutils # lspci
    usbutils # lsusb
  ];

  hardware = {
    graphics.enable = true;
    nvidia = {
      modesetting.enable = true;
      open = false;
    };
    bluetooth.enable = true;
  };
  services.xserver.videoDrivers = [ "nvidia" ];
  services.dbus.enable = true;

  fonts = {
    fontconfig.enable = true;
    packages = with pkgs; [
      nerd-fonts.jetbrains-mono
    ];
  };
  services = {
    displayManager.enable = true;
    displayManager.ly.enable = true;
    blueman.enable = true;
    # services.openssh.enable = true;
  };
  programs = {
    nix-ld.enable = true;
    niri.enable = true;
    xwayland.enable = true;
    wireshark.enable = true;
    firefox.enable = true;

    steam = {
      enable = true;
      remotePlay.openFirewall = true;
      dedicatedServer.openFirewall = true;
    };

    gamemode.enable = true;
    direnv.enable = true;
  };
  security.polkit.enable = true;
  virtualisation.docker.enable = true;

  environment.variables = {
    LD_LIBRARY_PATH = "/run/opengl-driver/lib";
    ELECTRON_OZONE_PLATFORM_HINT = "wayland";
    OZONE_PLATFORM = "wayland";
    GDK_BACKEND = "wayland";
  };

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # networking.firewall.enable = false;
  system.stateVersion = "25.11";

}
