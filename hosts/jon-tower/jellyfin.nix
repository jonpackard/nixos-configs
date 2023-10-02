{ config, pkgs, ... }:

let
  # Allow for packages from nixos-unstable
  unstable = import <nixos-unstable> { config = { allowUnfree = true; };
};

in 
{

  services.jellyfin = {
    enable = true;
    package = unstable.jellyfin;
  };

  # Open ports in the firewall.
  networking.firewall.allowedTCPPorts = [ 8096 8920 ];
  networking.firewall.allowedUDPPorts = [ 1900 7359 ];

}
