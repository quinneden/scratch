{
  description = "NixOS for mac mini m1";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    hyprland.url = "github:hyprwm/hyprland";
    ags.url = "github:aylur/ags/v1";
    astal.url = "github:aylur/astal";
    nix-shell-scripts.url = "github:quinneden/nix-shell-scripts";
    nix-vscode-extensions.url = "github:nix-community/nix-vscode-extensions";
    matugen.url = "github:InioX/matugen";
    micro-autofmt-nix.url = "github:quinneden/micro-autofmt-nix";
    micro-colors-nix.url = "github:quinneden/micro-colors-nix";

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

    firefox-gnome-theme = {
      url = "github:rafaelmardojai/firefox-gnome-theme";
      flake = false;
    };
  };

  outputs =
    { self, nixpkgs, ... }@inputs:
    let
      forAllSystems = inputs.nixpkgs.lib.genAttrs [
        "aarch64-darwin"
        "aarch64-linux"
      ];
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

      devShells = forAllSystems (
        system:
        let
          pkgs = nixpkgs.legacyPackages.${system};
          lib = nixpkgs.lib;
        in
        {
          default = pkgs.mkShell {
            shellHook = ''
              set -e
              ${lib.getExe pkgs.nixos-rebuild} switch \
                --fast --show-trace \
                --flake .#nixos-macmini \
                --target-host "root@10.0.0.243" \
                --build-host "root@10.0.0.243"
              exit 0
            '';
          };
        }
      );
    };
}
