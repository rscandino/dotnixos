{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.modules.system.networkManager;
in {
  options.modules.system.networkManager = {
    enable = lib.mkEnableOption "Enabling networkManager";

    hostName = lib.mkOption {
      type = lib.types.str;
      default = "nixos";
      description = "HostName, default nixos";
    };

    randomizeMac = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Randomize the Wi-Fi MAC address per connection (privacy on public networks)";
    };

    vpnPlugins = lib.mkOption {
      type = lib.types.listOf lib.types.package;
      default = [];
      example = lib.literalExpression "[pkgs.networkmanager-openvpn]";
      description = "NetworkManager VPN plugins (WireGuard is built in)";
    };
  };

  config = lib.mkIf cfg.enable {
    networking.hostName = cfg.hostName;

    networking.networkmanager = {
      enable = true;

      wifi = {
        backend = "wpa_supplicant";
        macAddress = lib.mkIf cfg.randomizeMac "random";
        scanRandMacAddress = true;
      };

      # Let systemd-resolved handle DNS (split DNS, VPNs, caching)
      dns = "systemd-resolved";

      plugins = cfg.vpnPlugins;

      # Keep NM away from container interfaces (you use podman)
      unmanaged = [
        "interface-name:podman*"
        "interface-name:veth*"
      ];
    };

    # gives correct per-link DNS, helpw with some VPNs
    services.resolved.enable = true;

    # Needed for WireGuard/VPNs with strict reverse path filtering
    networking.firewall.checkReversePath = "loose";

    # Don't block boot waiting for the network on a laptop
    systemd.services.NetworkManager-wait-online.enable = false;

    environment.systemPackages = with pkgs; [
      networkmanagerapplet
    ];
  };
}
