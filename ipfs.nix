{ config, pkgs, ... }:

{
  networking.firewall.allowedTCPPorts = [
    4001 # This is IPFS swarm port
  ];
  services.ipfs = {
    enable = true;
    swarmAddress = [ "/ip4/0.0.0.0/tcp/5000" "/ip6/::/tcp/5000" ];
    gatewayAddress = "/ip4/0.0.0.0/tcp/8080";
    autoMount = true;
    enableGC = true;
  };

}

