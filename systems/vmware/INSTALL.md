# VMware Installation Notes

See [INSTALL.md](/INSTALL.md) at the repo root for general installation instructions using disko-install / disko / nixos-anywhere.

## VMware-Specific

- **Disk device**: Typically `/dev/sda`. Verify with `lsblk` before running disko.
- **Firmware**: This config uses `systemd-boot` (UEFI). Make sure the VM is set to UEFI firmware (not BIOS).
- **VMware Tools**: Not enabled (open-vm-tools intentionally excluded).
- **Minimal desktop**: Hyprland with basic config for testing — not a full rice.
