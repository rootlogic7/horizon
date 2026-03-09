# system/power.nix
{ config, lib, pkgs, ... }:

with lib;
let
  cfg = config.horizon.power;
in {
  # 1. Interface / Optionen definieren
  options.horizon.power = {
    enable = mkEnableOption "Enable Power Management (TLP, Thermald, Upower)";
    chargeThreshold = mkOption {
      type = types.int;
      default = 80; # Standardmäßig auf 80% begrenzen, um den Akku zu schonen
      description = "Maximale Akkuladung in Prozent.";
    };
  };

  # 2. Implementierung
  config = mkIf cfg.enable {
    # Upower aktivieren (wichtig, damit deine Waybar den Akkustand zuverlässig ausliest)
    services.upower.enable = true;

    # Thermald verhindert Überhitzung bei Intel CPUs
    services.thermald.enable = true;

    # WICHTIG: Den Standard-Daemon deaktivieren, da er mit TLP in Konflikt steht
    services.power-profiles-daemon.enable = false;

    # TLP Konfiguration (Das Gehirn für ThinkPads)
    services.tlp = {
      enable = true;
      settings = {
        # --- Automatische Nutzungsprofile (AC vs. Batterie) ---
        CPU_SCALING_GOVERNOR_ON_AC = "performance";
        CPU_SCALING_GOVERNOR_ON_BAT = "powersave";

        CPU_ENERGY_PERF_POLICY_ON_AC = "performance";
        CPU_ENERGY_PERF_POLICY_ON_BAT = "power";

        # Stromsparen an den PCIe-Schnittstellen (hilft massiv bei Laptops)
        PCIE_ASPM_ON_AC = "default";
        PCIE_ASPM_ON_BAT = "powersupersave";

        # --- Akku schonen (Ladeschwellen) ---
        # Lade erst wieder, wenn der Akku 5% unter dem Threshold ist.
        # Wir sprechen BAT0 und BAT1 an, da das T470 oft einen internen und einen externen Akku hat.
        START_CHARGE_THRESH_BAT0 = cfg.chargeThreshold - 5;
        STOP_CHARGE_THRESH_BAT0 = cfg.chargeThreshold;
        START_CHARGE_THRESH_BAT1 = cfg.chargeThreshold - 5;
        STOP_CHARGE_THRESH_BAT1 = cfg.chargeThreshold;

        # Funkmodule beim Booten: WLAN an, Bluetooth aus (spart Strom)
        DEVICES_TO_DISABLE_ON_STARTUP = "bluetooth";
        DEVICES_TO_ENABLE_ON_STARTUP = "wifi";
      };
    };
  };
}
