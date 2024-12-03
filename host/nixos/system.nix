{
  pkgs,
  inputs,
  secrets,
  ...
}:
{
  users.users.quinn = {
    isNormalUser = true;
    initialPassword = "${secrets.defaultUserPassword}";
    extraGroups = [
      "networkmanager"
      "wheel"
      "podman"
    ];
  };

  nix = {
    nixPath = [ "nixpkgs=flake:nixpkgs" ];
    settings = {
      accept-flake-config = true;
      access-tokens = [ "github=${secrets.github.token}" ];
      experimental-features = "nix-command flakes";
      auto-optimise-store = true;
      warn-dirty = false;
      extra-substituters = [
        "https://cache.lix.systems"
      ];
      extra-trusted-public-keys = [
        "cache.lix.systems:aBnZUw8zA7H35Cz2RyKFVs3H4PlGTLawyY5KRbvJR8o="
      ];
    };
  };

  zramSwap = {
    enable = true;
    memoryPercent = 100;
  };

  virtualisation = {
    podman.enable = true;
  };

  programs.dconf.enable = true;

  programs.nh = {
    enable = true;
    flake = /home/quinn/.dotfiles;
  };

  programs.direnv = {
    enable = true;
    silent = false;
    enableZshIntegration = true;
    loadInNixShell = true;
    nix-direnv = {
      enable = true;
      package = pkgs.nix-direnv;
    };
  };

  environment.pathsToLink = [
    "/share/zsh"
    "/share/qemu"
    "/share/edk2"
  ];

  security.sudo.wheelNeedsPassword = false;

  fonts.packages = with pkgs.nerd-fonts; [
    caskaydia-cove
    hack
    fira-code
    jetbrains-mono
    iosevka
    iosevka-term
    symbols-only
    noto
  ];

  services.flatpak.enable = true;

  services.xserver = {
    enable = true;
    excludePackages = [ pkgs.xterm ];
  };

  programs.ssh = {
    enable = true;
    startAgent = true;
    settings.PermitRootLogin = "yes";
  };

  services.logind.extraConfig = ''
    HandlePowerKey=ignore
  '';

  # network
  networking = {
    wireless.iwd = {
      enable = true;
      settings = {
        IPv6.Enabled = true;
        Settings.AutoConnect = true;
        General.EnableNetworkConfiguration = true;
      };
    };
    networkmanager = {
      enable = true;
      wifi.backend = "iwd";
    };
  };

  # bluetooth
  hardware.bluetooth = {
    enable = true;
    settings.General.Experimental = true;
  };

  # bootloader
  boot = {
    tmp.cleanOnBoot = true;
    loader = {
      timeout = 2;
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = false;
    };
  };

  hardware.asahi = {
    enable = true;
    setupAsahiSound = true;
    useExperimentalGPUDriver = true;
    experimentalGPUInstallMode = "replace";
    peripheralFirmwareDirectory = builtins.fetchTarball {
      url = "https://qeden.me/fw/asahi-firmware-20241024.tar.gz";
      sha256 = "sha256-KOBXP/nA3R1+/8ELTwsmmZ2MkX3lyfp4UTWeEpajWD8=";
    };
  };
}
