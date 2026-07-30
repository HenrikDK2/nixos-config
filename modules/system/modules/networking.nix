{ pkgs, ... }:
{
  # System hostname shown on the network
  networking.hostName = "nixos";

  # Enable Wi-Fi support
  networking.wireless.enable = true;

  # Enable NetworkManager tray applet for desktop environments
  programs.nm-applet.enable = true;

  # NetworkManager configuration and VPN plugin support
  networking.networkmanager = {
    enable = true;

    plugins = with pkgs; [
      # OpenVPN support for NetworkManager connections
      networkmanager-openvpn
    ];
  };

  networking.firewall = {
    # Enable NixOS stateful firewall (default: deny incoming, allow outgoing)
    enable = true;

    # Block ICMP echo requests (disable ping responses)
    allowPing = false;

    # Disable firewall refusal logging to reduce system log noise
    logRefusedConnections = false;

    # Publicly accessible TCP ports
    allowedTCPPorts = [
      443  # HTTPS - encrypted web traffic available from any network
      1065 # SSH - remote administration using a non-default port
    ];

    extraCommands = ''
      # Allow HTTP web traffic from private LAN networks only
      # Accessible only by devices inside 192.168.0.0/16
      iptables -A nixos-fw -p tcp -s 192.168.0.0/16 --dport 80 -j nixos-fw-accept

      # Allow CUPS printing services from LAN devices only
      # Used for network printers and printer discovery
      iptables -A nixos-fw -p tcp -s 192.168.0.0/16 --dport 631 -j nixos-fw-accept

      # Allow FTP access from LAN devices only
      # Intended for local file transfers; not exposed to the internet
      iptables -A nixos-fw -p tcp -s 192.168.0.0/16 --dport 21 -j nixos-fw-accept

      # Allow LocalSend file sharing over TCP from LAN devices only
      iptables -A nixos-fw -p tcp -s 192.168.0.0/16 --dport 53317 -j nixos-fw-accept

      # Allow LocalSend file sharing discovery/data over UDP from LAN devices only
      iptables -A nixos-fw -p udp -s 192.168.0.0/16 --dport 53317 -j nixos-fw-accept
    '';
  };

  services.openssh = {
    # Enable SSH server for remote administration
    enable = true;

    # Use custom SSH port instead of the default port 22
    ports = [
      1065
    ];

    settings = {
      # Disable password authentication to prevent password brute-force attacks
      PasswordAuthentication = false;

      # Prevent direct root login over SSH
      PermitRootLogin = "no";
    };
  };
}
