{ config, pkgs, ... }:

let
  kub = config.services.kubernetes;
  devCert = kub.lib.mkCert {
    name = "gui";
    CN = "kubernetes-cluster-ca";
    fields = {
      O = "system:masters";
    };
    privateKeyOwner = "gui";
  };
  kubeConfig = kub.lib.mkKubeConfig "gui" {
    server = kub.apiserverAddress;
    certFile = devCert.cert;
    keyFile = devCert.key;
  };
in
{
  services = {
    kubernetes = {
      roles = ["master" "node"];
      easyCerts = true;
      masterAddress = "localhost";
      pki.certs = { dev = devCert; };
      kubelet.extraOpts = "--fail-swap-on=false";
    };
  };

  programs.zsh = {
    interactiveShellInit = ''
      export KUBECONFIG="${kubeConfig}:$HOME/.kube/config";
    '';
  };
}
