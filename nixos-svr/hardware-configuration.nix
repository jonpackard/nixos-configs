# Do not modify this file!  It was generated by ‘nixos-generate-config’
# and may be overwritten by future invocations.  Please make changes
# to /etc/nixos/configuration.nix instead.
{ config, lib, pkgs, modulesPath, ... }:

{
  imports =
    [ (modulesPath + "/profiles/qemu-guest.nix")
    ];

  boot.initrd.availableKernelModules = [ "uhci_hcd" "ehci_pci" "ahci" "virtio_pci" "sr_mod" "virtio_blk" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-amd" ];
  boot.extraModulePackages = [ ];

  fileSystems."/" =
    { device = "/dev/disk/by-uuid/ecd4dca7-6b93-4bdc-a9ae-fe38bb5ef8cf";
      fsType = "btrfs";
    };

  fileSystems."/boot" =
    { device = "/dev/disk/by-uuid/42E6-0E37";
      fsType = "vfat";
    };

  fileSystems."/storage" =
    { device = "/dev/disk/by-uuid/987ffb53-9674-4600-9c68-182a4d804ed8";
      fsType = "btrfs";
    };

  swapDevices =
    [ { device = "/dev/disk/by-uuid/eddf929e-2bb6-4be6-9407-59ede34332f7"; }
    ];

  hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
