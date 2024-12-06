{
  lazarus,
  config,
  inputs,
  lib,
  pkgs,
  secrets,
  specialArgs,
  ...
}:
let
  flakeImports = with inputs; [
    lix-module.nixosModules.default
    home-manager.nixosModules.default
    nixos-apple-silicon.nixosModules.default
  ];
in
{
  imports = flakeImports ++ [ ./nixos ];

  hyprland.enable = true;

  home-manager = {
    backupFileExtension = "backup";
    useGlobalPkgs = true;
    useUserPackages = true;
    extraSpecialArgs = {
      inherit inputs secrets;
    };
    users.quinn = {
      home = {
        username = "quinn";
        homeDirectory = "/home/quinn";
        sessionPath = [ "$HOME/.local/bin" ];
        stateVersion = "25.05";
      };
      imports = [ ./home-manager ];
    };
  };

  specialisation = {
    gnome.configuration = {
      system.nixos.tags = [ "Gnome" ];
      hyprland.enable = lib.mkForce false;
      gnome.enable = true;
    };
  };

  system.stateVersion = "25.05";
}
