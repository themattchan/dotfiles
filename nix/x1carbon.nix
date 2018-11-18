{ config, lib, builtins, pkgs, ... }:

{
  imports = [
    ./nixos-hardware/lenovo/thinkpad/x1/6th-gen/default.nix
  ];

  networking.hostName = "adrastea";

  # trackpoint
  hardware.trackpoint = {
    enable = true;
    device = "TPPS/2 Elan TrackPoint";
    emulateWheel = true;
    sensitivity = 30; # default 128, 0--255
    speed = 10; # default 97, 0--255
  };

  services.thinkfan = {
    enable = true;
    # find /sys/devices -type f -name \'temp*_input\' | sed -r -e \'s/^/hwmon /\'
    sensors =
      ''
        hwmon /sys/class/hwmon/hwmon0/temp1_input
        hwmon /sys/class/hwmon/hwmon0/temp2_input
        hwmon /sys/class/hwmon/hwmon0/temp3_input
        hwmon /sys/class/hwmon/hwmon0/temp4_input
        hwmon /sys/class/hwmon/hwmon0/temp5_input
      '';
  };

  services.xserver.dpi = 210;
  fonts.fontconfig.dpi = 210;
  hardware.opengl = {
    enable = true;
    extraPackages = with pkgs; [
      vaapiIntel
      vaapiVdpau
      libvdpau-va-gl
    ];
    driSupport32Bit = true;
  };

}
