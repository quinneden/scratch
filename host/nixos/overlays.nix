{ inputs, pkgs, ... }:
let
  nixpkgsDrvRootPath = inputs.nixpkgs + "/pkgs/applications/editors/vscode";
in
{
  nixpkgs.overlays =
    let
      packageOverlays =
        _: prev:
        let
          inherit (prev) system;
        in
        {
          # vscodium-insiders = pkgs.vscodium.overrideAttrs (
          #   prevAttrs: finalAttrs: rec {
          #     dontBuild = false;
          #     version = "1.96.0.24341-insider";
          #     passthru.executableName = "codium";
          #     src = builtins.fetchurl {
          #       url = "https://github.com/VSCodium/vscodium-insiders/releases/download/${version}/VSCodium-linux-arm64-${version}.tar.gz";
          #       sha256 = "sha256:01vvm2cdqak6cz95sai8l3h7iaflf51m72cjgk155b235i7v30w8";
          #     };
          #     buildPhase = ''
          #       ln -s codium-insiders codium
          #       mv bin/codium-insiders bin/codium
          #     '';
          #   }
          # );
          vscodium-insiders = pkgs.callPackage ../drv/vscodium-insiders.nix { inherit nixpkgsDrvRootPath; };
        };
    in
    [
      packageOverlays
    ];
}
