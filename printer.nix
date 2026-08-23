{ config, lib, pkgs, ... }: {
  
  # Enable CUPS to print documents.
  services.printing = {
    enable = true;
    drivers = [ pkgs.cups-brother-hl3140cw ];
  };

  # Enable Avahi for automatic network printer discovery (recommended for wireless printers)
  services.avahi = {
    enable = true;
    nssmdns4 = true;
    openFirewall = true;
  };
}
