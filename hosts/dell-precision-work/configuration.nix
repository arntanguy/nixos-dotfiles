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

  # enable/disable custom services from ./module
  # all modules are enabled/disabled through their modules.<module_name>.enable option
  # e.g:
  # modules.yubikey.enable = true;
  # modules.sops.enable = true;
  # ...

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
  # See modules/home/nvidia.nix for programs requiring nvidia to run (davinci-resolve, blender, darktable, etc)
  environment.systemPackages = with pkgs; [
    # Nix/NixOS Tools
    nh
    nixfmt-rfc-style
    inputs.nixCats.packages."${pkgs.system}".nixCats

    # Utilities
    bat
    btop
    curl
    fastfetch
    fzf
    jq
    lsd
    ripgrep
    starship
    tmux
    wget

    # Clipboard & File Management
    nautilus
    wl-clipboard-rs

    # Media & Graphics
    adw-gtk3
    bitwarden-desktop
    discord
    eog # eye-of-gnome image viewer
    ffmpeg
    ghostty
    gimp
    godot
    krita
    obs-studio
    papirus-icon-theme
    pavucontrol
    playerctl
    swaynotificationcenter
    swaylock-effects
    waybar
    waybar-mpris
    waypaper

    # Security & Networking
    burpsuite
    caido
    devpod
    docker
    docker-compose
    gobuster
    hashcat
    john
    metasploit
    nmap
    openvpn
    polkit
    qbittorrent
    rockyou
    seclists
    sqlmap
    steam
    steam-run
    thc-hydra
    wireshark
    wordlists
    wsdd # Web Service Discovery (WSD) host daemon for SMB/Samba

    # Bluetooth & Hardware
    bzmenu # for bluetooth
    ly
    nvidia-modprobe
    nvidia-vaapi-driver
    pciutils # lspci
    usbutils # lsusb
    xwayland
    xwayland-satellite

    # Misc
    fuzzel
    grub2
    swww
    wlogout
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
