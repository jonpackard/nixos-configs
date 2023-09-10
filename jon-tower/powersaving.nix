{ config, pkgs, ... }:

# References
## https://www.reddit.com/r/NixOS/comments/10adqyb/what_do_people_use_to_manage_their_cpu_frequency/

let
  # Allow for packages from nixos-unstable
  unstable = import <nixos-unstable> { config = { allowUnfree = true; };
};

in 
{
  powerManagement.cpuFreqGovernor = "ondemand";
  services.thermald.enable = true;
  services.xserver.displayManager.gdm.autoSuspend = true; # this is the default
}
