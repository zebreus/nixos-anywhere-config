{ modulesPath, lib, pkgs, ... }:

{
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
    (modulesPath + "/profiles/qemu-guest.nix")
    ./disk-config.nix
    ./modules/hetzner.nix
    ./matrix.nix
  ];
  boot.loader.grub = {
    # no need to set devices, disko will add all devices that have a EF02 partition to the list already
    # devices = [ ];
    efiSupport = true;
    efiInstallAsRemovable = true;
  };
  services.openssh.enable = true;
  services.fail2ban.enable = true;
  system.stateVersion = "23.11";

  environment.systemPackages = map lib.lowPrio [
    pkgs.curl
    pkgs.gitMinimal
  ];

  system.autoUpgrade = {
    enable = true;
    flake = "github:zebreus/nixos-anywhere-config";
    flags = [
      "--impure"
      "--update-input"
      "nixpkgs"
      "-L" # print build logs
    ];
    dates = "03:40";
    randomizedDelaySec = "45min";
    allowReboot = true;
  };

  users.users.root.openssh.authorizedKeys.keys = [
    "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDSzz3v/BNDgCZErzszVq064goCNv3KiQzt97DVXHFMg3VeYDv1okVXD2/jrf1Hxvjnh1LVeMN8vMbCp3jODYSI/nsXFqF2Br57QPN96fczUu/ew82iE3jlq5N0ZIMx9DUgIdvGBkj1Oj1W47K17bdE1+7EV03xwsWDVCVJid+ZtoSIF86IUZBaEmR29X/dsHrkTYMYjP0cCg4w8ihSQ1YBo//qI2KDS9ynj62vcOLEB67vKFX7U3Z7cmvYHWGJmSzQKwKsVTTOBGjhAumJPzSvo0ZdwinvZyKNq5ZPr3r9YEDKjzuwReKJSIse0+frbver3fEhD0y00pHD1QNij93231w7HfpSNT5MymdIpV4MKC/cdVbd598+p32CFur+iXQZfo7IkPH4hi7o66elv4yJF8Tk3w3bIOX7uCBL3+wiHkIQ/hq3dZ2slOA9J13uVfMSr/FVJRM8NnIB0kWdjzbYWYMJEDUEjmL6eJizIizL6JThstaYSXX0C/k1kpelKUs= lennart@t15g"
  ];

  networking.hostName = "matrix";
  networking.domain = "zebre.us";
  networking.useDHCP = false;
  networking.useNetworkd = true;

  modules.hetzner.wan = {
    enable = true;
    macAddress = "96:00:02:da:0e:63";
    ipAddresses = [
      "65.109.236.106/32"
      "2a01:4f9:c010:9ee1::1/64"
    ];
  };
}
