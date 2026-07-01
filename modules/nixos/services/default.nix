{...}: {
  imports = [
    ./ddns-go.nix
    ./fail2ban.nix
    ./ssh.nix
    ./tailscale.nix
    ./virtualization.nix
  ];
}
