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
    inputs.sops-nix.nixosModules.sops
    inputs.home-manager.nixosModules.home-manager
    {
      home-manager.useGlobalPkgs = true;
      home-manager.useUserPackages = true;
      home-manager.extraSpecialArgs = { inherit globals; };
      home-manager.users.${globals.UserName} = import ../../modules/home/home.nix;
    }
  ];

  # FIXME: override default mac address with a recognized one
  modules.networkmanager.profiles.lirmm-pandas.macAddress = "34:48:ed:7e:e4:70";

  nix = {
    settings = {
      trusted-users = [ "root" "${globals.UserName}" ]; # Replace with your actual username
      substituters = [
        "https://cache.nixos.org/"
        "https://mc-rtc-nix.cachix.org"
        "https://ros.cachix.org"
      ];
      trusted-public-keys = [
        "mc-rtc-nix.cachix.org-1:5M3sLvHXJCep4wc1tQl7QuFWL2eH2I0jkuvWtqJDYQs="
        "ros.cachix.org-1:dSyZxI8geDCJrwgvCOHDoAfOm5sV1wCPjBkKL+38Rvo="
      ];
    };
    # See https://nixos.wiki/wiki/Storage_optimization
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 30d";
    };
  };

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
    settings.PasswordAuthentication = true;
    # Optional: allow root login (default is "prohibit-password")
    # permitRootLogin = "no";
    # Optional: open the firewall for SSH
    openFirewall = true;
  };
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

  # See modules/home/nvidia.nix for programs requiring nvidia to run (davinci-resolve, blender, darktable, etc)
  environment.systemPackages = with pkgs; [
    # Clipboard & File Management
    wl-clipboard-rs

    # Media & Graphics
    adw-gtk3
    bitwarden-desktop
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
    openvpn
    polkit
    qbittorrent
    sqlmap
    steam
    steam-run
    wireshark
    wordlists

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
    awww
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
  networking.firewall.enable = false;
  system.stateVersion = "25.11";

}
