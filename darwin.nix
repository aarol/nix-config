{ config, pkgs, ... }:

{
  home.username = "aarol";
  home.homeDirectory = "/Users/aarol";

  home.sessionVariables = {
    EDITOR = "zed";
    VCPKG_ROOT = "${config.home.homeDirectory}/dev/vcpkg";
    ANDROID_HOME = "${config.home.homeDirectory}/Library/Android/sdk";
  };

  home.sessionPath = [
    "${config.home.homeDirectory}/.lmstudio/bin"
    "${config.home.homeDirectory}/.antigravity/antigravity/bin"
  ];
}
