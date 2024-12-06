{ inputs, pkgs, ... }:
let
  nixpkgsDrvRootPath = inputs.nixpkgs + "/pkgs/applications/editors/vscode";
in
{
  nixpkgs.overlays = [
    {
      vscodium-insiders = pkgs.callPackage ./vscodium-insiders.nix { inherit nixpkgsDrvRootPath; };
    }
  ];
}
