{ config, pkgs, ... }:

# References
## https://www.reddit.com/r/NixOS/comments/10adqyb/what_do_people_use_to_manage_their_cpu_frequency/

{
  powerManagement.cpuFreqGovernor = "ondemand";
  services.thermald.enable = true;
  services.xserver.displayManager.gdm.autoSuspend = true; # this is the default
}
