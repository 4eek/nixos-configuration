{ config, pkgs, ... }:

{
  networking.firewall.allowedTCPPorts = [
    4001 # This is IPFS swarm port
  ];
  services.ipfs = {
    enable = true;
    enableGC = true;
  };
}

