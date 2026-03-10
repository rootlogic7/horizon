# system/nvidia.nix
{ config, lib, pkgs, ... }:

with lib;
let
  cfg = config.horizon.hardware.nvidia;
in {
  options.horizon.hardware.nvidia = {
    enable = mkEnableOption "Enable Proprietary Nvidia Drivers and Wayland tweaks";
  };

  config = mkIf cfg.enable {
    # 1. Grafik-Treiber aktivieren (hardware.opengl heißt in neueren NixOS-Versionen hardware.graphics)
    hardware.graphics = {
      enable = true;
      enable32Bit = true; # Wichtig für Steam/Gaming!
    };

    # 2. Xserver anweisen, den Nvidia-Treiber zu laden
    services.xserver.videoDrivers = [ "nvidia" ];

    # 3. Nvidia-spezifische Konfiguration
    hardware.nvidia = {
      # Modesetting ist PFLICHT für Wayland/Hyprland
      modesetting.enable = true;

      # Power Management (Experimentell, aber oft nützlich auf Desktop-Karten für sauberen Sleep/Wake)
      powerManagement.enable = false;
      powerManagement.finegrained = false;

      # Open-Source Kernel Module: Für RTX 5000 wird oft 'open = true' empfohlen, 
      # aber der proprietäre Treiber ('false') ist aktuell für Hyprland oft noch stabiler.
      open = false;

      # Nvidia Settings Menü zugänglich machen
      nvidiaSettings = true;

      # WICHTIG: Für die RTX 5060 brauchen wir zwingend den aktuellsten Treiber!
      package = config.boot.kernelPackages.nvidiaPackages.latest;
    };

    # 4. Systemweite Environment-Variablen für Wayland + Nvidia
    environment.sessionVariables = {
      LIBVA_DRIVER_NAME = "nvidia";
      XDG_SESSION_TYPE = "wayland";
      GBM_BACKEND = "nvidia-drm";
      __GLX_VENDOR_LIBRARY_NAME = "nvidia";
      # Falls Firefox/Electron-Apps zicken:
      NVD_BACKEND = "direct"; 
    };
  };
}
