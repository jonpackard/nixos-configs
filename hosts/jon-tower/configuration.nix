# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running `nixos-help`).

# Dependencies on distrobox:
#   Arch Linux:
#     pCloud - (AppImage does not run in NixOS... libfuse issue? Tested 9 Sep 2023.
#     nativefier - used to create electron apps for specific websites. Used AUR instead of the python packager.
#     tgpt - "terminal gpt chat" - seems broken in NixOS unstable as of 13 Sep 2023.

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      # Enable Jellyfin server
      ./jellyfin.nix
      # Enable power saving
      ./powersaving.nix
    ];

  # Enable Flakes and the new command-line tool
  nix.settings.experimental-features = [ "nix-command" "flakes" ];


  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  
  # Disable USB ethernet in dock. Was causing kernel crashes when both onboard and USB NICs were connected.
  boot.blacklistedKernelModules = [
    "r8152"
    "r8153_ecm"
  ];

  fileSystems = {
    "/".options = [ "compress=zstd" ];
    "/home".options = [ "compress=zstd" ];
    "/nix".options = [ "compress=zstd" "noatime" ];
    "/storage".options = [ "compress=zstd" ];
  };

  networking.hostName = "jon-tower"; # Define your hostname.
  # Pick only one of the below networking options.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  networking.networkmanager.enable = true;  # Easiest to use and most distros use this by default.

  # Set your time zone.
  time.timeZone = "America/New_York";

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";
  console = {
    font = "Lat2-Terminus16";
    # keyMap = "us";
    useXkbConfig = true; # use xkbOptions in tty.
  };

  # Enable the X11 windowing system.
  services.xserver.enable = true;


  # Enable the GNOME Desktop Environment.
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;
  services.xserver.displayManager.gdm.wayland = false; # Disable Wayland. Use X11 instead.
  
  # Configure keymap in X11
  # services.xserver.layout = "us";
  # services.xserver.xkbOptions = "eurosign:e,caps:escape";

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound.
  sound.enable = true;
  hardware.pulseaudio.enable = true;
  hardware.pulseaudio.daemon.config = {
    default-sample-rate = 48000; # SteamVR sound fix
    alternate-sample-rate = 48000; # SteamVR sound fix
  };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;
  
  hardware.logitech.wireless = {
    enable = true;
    enableGraphical = true;
  };
  
  # Enable FUSE filesystems - needed by pcloud
  boot.supportedFilesystems = [ "fuse" ];
  boot.kernelModules = [ "fuse" ];

  # Allow non-free packages
  nixpkgs.config.allowUnfree = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.jonathan = {
    isNormalUser = true;
    extraGroups = [ "wheel" ]; # Enable ‘sudo’ for the user.
    packages = with pkgs; [
      firefox
      tree
      remmina
      tmux
      nmap
      bitwarden
      cryptomator
      element
      notepadqq
      wol
      git
      vscodium
      unigine-superposition
      element-desktop
      prusa-slicer
      cura
      blender
      freecad
      podman-compose
      distrobox
      appimage-run
      p7zip
      anydesk
      discord
      jellyfin-mpv-shim
      fortune
      neofetch
      vlc
      lighthouse-steamvr # Power management for SteamVR lighthouses
    ];
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.brandon = {
    isNormalUser = true;
    # extraGroups = [ "wheel" ]; # Enable ‘sudo’ for the user.
    packages = with pkgs; [
      firefox
      tree
      remmina
      tmux
      nmap
      bitwarden
      cryptomator
      element
      notepadqq
      wol
      git
      vscodium
      unigine-superposition
      element-desktop
      prusa-slicer
      cura
      blender
      freecad
      podman-compose
      distrobox
      appimage-run
      p7zip
      anydesk
      discord
      jellyfin-mpv-shim
      fortune
      neofetch
      vlc
      lighthouse-steamvr # Power management for SteamVR lighthouses
      #minecraft
      prismlauncher
    ];
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  # Created alias... alias nixsearch="nix --extra-experimental-features \"nix-command flakes\" search nixpkgs"
  
  environment.systemPackages = with pkgs; [
    vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    wget
    fuse # needed by pcloud
    libimobiledevice # Needed for iPhone integration
    ifuse # Needed for iPhone integration
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;
  services.openssh.settings.X11Forwarding = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Note: Anydesk uses port 7070/tcp+udp by default
  # Or disable the firewall altogether.
  networking.firewall.enable = false;

  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
    dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
  };
  
  programs.gamemode.enable = true;

  # Tailscale VPN
  services.tailscale.enable = true;
  services.tailscale.useRoutingFeatures = "both";

  # ==START NVIDIA==

  # Enable OpenGL
  hardware.opengl = {
    enable = true;
    driSupport = true;
    driSupport32Bit = true;
  };

  # Load nvidia driver for Xorg and Wayland
  services.xserver.videoDrivers = ["nvidia"];

  hardware.nvidia = {

    # Modesetting is required.
    modesetting.enable = true;

    # Enable power management (do not disable this unless you have a reason to).
    # Likely to cause problems on laptops and with screen tearing if disabled.
    powerManagement.enable = false; # Changed from true to false to fix suspend issue
	
    # Use the NVidia open source kernel module (not to be confused with the
    # independent third-party "nouveau" open source driver).
    # Support is limited to the Turing and later architectures. Full list of 
    # supported GPUs is at: 
    # https://github.com/NVIDIA/open-gpu-kernel-modules#compatible-gpus 
    # Only available from driver 515.43.04+
    # Do not disable this unless your GPU is unsupported or if you have a good reason to.
    open = false; # SteamVR had terrible framerate with this set to true!

    # Enable the Nvidia settings menu,
    # accessible via `nvidia-settings`.
    nvidiaSettings = true;

    # Optionally, you may need to select the appropriate driver version for your specific GPU.
    package = config.boot.kernelPackages.nvidiaPackages.stable;
  };

  # ==END NVIDIA==

  virtualisation = {
      podman = {
        enable = true;

        # Create a `docker` alias for podman, to use it as a drop-in replacement
        dockerCompat = true;

        # Required for containers under podman-compose to be able to talk to each other.
        defaultNetwork.settings.dns_enabled = true;
      };
    };

  systemd.coredump.enable = true; # Enables debugging applications.
  
  services.usbmuxd.enable = true; # Needed for iPhone integration

  # Copy the NixOS configuration file and link it from the resulting system
  # (/run/current-system/configuration.nix). This is useful in case you
  # accidentally delete configuration.nix.
  # system.copySystemConfiguration = true;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It's perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.05"; # Did you read the comment?

}
