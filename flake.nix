{
  description = "NixOS for mac mini m1";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    hyprland.url = "github:hyprwm/hyprland";
    ags.url = "github:quinneden/ags";
    astal.url = "github:quinneden/astal";
    nix-shell-scripts.url = "github:quinneden/nix-shell-scripts";

    lix-module = {
      url = "https://git.lix.systems/lix-project/nixos-module/archive/2.91.1-2.tar.gz";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixos-apple-silicon = {
      url = "github:tpwrules/nixos-apple-silicon";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    { self, nixpkgs }@inputs:
    let
      secrets = builtins.fromJSON (builtins.readFile .secrets/common.json);
      system = "aarch64-linux";

      pkgs = import nixpkgs {
        inherit system;
        config.allowUnfree = true;
        overlays = with inputs; [ nixos-apple-silicon.overlays.default ];
      };
    in
    {
      formatter.${system} = pkgs.nixfmt-rfc-style;
      packages.${system}.default = pkgs.callPackage ./ags { inherit inputs; };

      nixosConfigurations = {
        nixos-macmini = nixpkgs.lib.nixosSystem {
          inherit system pkgs;
          specialArgs = {
            inherit inputs secrets;
            asztal = self.packages.${system}.default;
          };
          modules = [ ./host ];
        };
      };
    };
}
