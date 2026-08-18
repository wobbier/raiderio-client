{
  lib,
  appimageTools,
  fetchurl,
}:

let
  version = "5.0.0";
  pname = "raiderio-client";

  src = fetchurl {
    url = "https://github.com/RaiderIO/raiderio-client-builds/releases/download/v${version}/RaiderIO_Installer_Linux_x86_64.AppImage";
    hash = "sha256-lR/jIjgOPp/34nS7VSebFdu3mixhCSg88twjfEi/XC4=";
  };

  appimageContents = appimageTools.extract { inherit pname version src; };
in
appimageTools.wrapType2 {
  inherit pname version src;

  extraInstallCommands = ''
    install -Dm444 /dev/stdin $out/share/applications/${pname}.desktop <<EOF
    [Desktop Entry]
    Name=RaiderIO
    Exec=${pname} --no-sandbox %U
    Terminal=false
    Type=Application
    Icon=${pname}
    StartupWMClass=RaiderIO
    Comment=RaiderIO Client
    Categories=Utility;
    EOF

    install -Dm444 \
      "${appimageContents}/usr/share/icons/hicolor/scalable/${pname}.svg" \
      "$out/share/icons/hicolor/scalable/apps/${pname}.svg"
  '';

  meta = {
    description = "Desktop client for RaiderIO, a World of Warcraft Mythic+ and raid progress tracking service";
    homepage = "https://raiderio.com";
    downloadPage = "https://github.com/RaiderIO/raiderio-client-builds/releases";
    license = lib.licenses.unfree;
    mainProgram = "raiderio-client";
    maintainers = with lib.maintainers; [ wobbier ];
    platforms = [ "x86_64-linux" ];
  };
}
