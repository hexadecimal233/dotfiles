# Darwin system: nix daemon, fish shell (user-level only), system packages
{
  lib,
  config,
  ...
}: let
  cfg = config.hex.darwin.system;
in {
  options.hex.darwin.system = {
    enable = lib.mkEnableOption "darwin system (nix daemon)";
  };

  config = lib.mkIf cfg.enable {
    # nix daemon
    nix.enable = true;

    # fish is a *user-level* shell (installed via hex.shared.home.shell) and is
    # launched by each terminal emulator, NOT by switching the login shell.
    # There is deliberately NO system-level `programs.fish` here (no /etc/fish,
    # no /run/current-system/sw/bin/fish): PATH for nix/homebrew is handled in
    # the fish conf.d (67-idk.fish), and zsh-side tool integrations live in
    # dotfiles/dot_zshrc.
    #
    # Login shell: left as the macOS default. Set/change manually with:
    #   sudo chsh -s /bin/zsh hexzii
  };
}
