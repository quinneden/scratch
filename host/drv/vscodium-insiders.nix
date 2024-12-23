{
  lib,
  stdenv,
  callPackage,
  fetchurl,
  nixosTests,
  nixpkgsDrvRootPath,
  isInsiders ? true,
  sourceExecutableName ?
    "codium" + lib.optionalString (isInsiders && stdenv.hostPlatform.isLinux) "-insiders",
  commandLineArgs ? "",
  useVSCodeRipgrep ? stdenv.hostPlatform.isDarwin,
}:

let
  inherit (stdenv.hostPlatform) system;
  throwSystem = throw "Unsupported system: ${system}";

  plat =
    {
      x86_64-linux = "linux-x64";
      x86_64-darwin = "darwin-x64";
      aarch64-linux = "linux-arm64";
      aarch64-darwin = "darwin-arm64";
      armv7l-linux = "linux-armhf";
    }
    .${system} or throwSystem;

  archive_fmt = if stdenv.hostPlatform.isDarwin then "zip" else "tar.gz";

  sha256 =
    {
      x86_64-linux = "0948jbnhjra09bvf9acrl6b2dp1xar5ajahmzy0cwf6dbidfms5y";
      x86_64-darwin = "1a8ga66526lfy2xrgshhizmidp8aaiwvpr38rvhsx0hqb4vmm0hy";
      aarch64-linux = "08la7kbb6myf9iz23p60vd00mrmhnizw8dgh54gb0msh8wbasidq";
      aarch64-darwin = "01z1dx77briqzhfx45c2f2np78r11b5xm92smi9idivbsia800i3";
      armv7l-linux = "0h3f9sy7d4ylk0ay63adhnz9s7jlpwlf3x831v8pygzm2r7k9zgc";
    }
    .${system} or throwSystem;

  sourceRoot = lib.optionalString (!stdenv.hostPlatform.isDarwin) ".";
in
callPackage "${toString nixpkgsDrvRootPath}/generic.nix" rec {
  inherit
    sourceRoot
    commandLineArgs
    useVSCodeRipgrep
    sourceExecutableName
    ;

  # Please backport all compatible updates to the stable release.
  # This is important for the extension ecosystem.
  version = "1.96.0.24341-insider";
  pname = "vscodium";

  executableName = "codium" + lib.optionalString isInsiders "-insiders";
  longName = "VSCodium" + lib.optionalString isInsiders " - Insiders";
  shortName = "vscodium" + lib.optionalString isInsiders " -insiders";

  src = builtins.fetchurl {
    url = "https://github.com/VSCodium/vscodium-insiders/releases/download/${version}/VSCodium-linux-arm64-${version}.tar.gz";
    sha256 = "sha256:01vvm2cdqak6cz95sai8l3h7iaflf51m72cjgk155b235i7v30w8";
  };

  tests = nixosTests.vscodium;

  updateScript = "${toString nixpkgsDrvRootPath}/update-vscodium.sh";

  meta = with lib; {
    description = ''
      Open source source code editor developed by Microsoft for Windows,
      Linux and macOS (VS Code without MS branding/telemetry/licensing)
    '';
    longDescription = ''
      Open source source code editor developed by Microsoft for Windows,
      Linux and macOS. It includes support for debugging, embedded Git
      control, syntax highlighting, intelligent code completion, snippets,
      and code refactoring. It is also customizable, so users can change the
      editor's theme, keyboard shortcuts, and preferences
    '';
    homepage = "https://github.com/VSCodium/vscodium";
    downloadPage = "https://github.com/VSCodium/vscodium/releases";
    license = licenses.mit;
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
    maintainers = with maintainers; [
      synthetica
      bobby285271
      ludovicopiero
    ];
    mainProgram = "codium";
    platforms = [
      "x86_64-linux"
      "x86_64-darwin"
      "aarch64-linux"
      "aarch64-darwin"
      "armv7l-linux"
    ];
  };
}
