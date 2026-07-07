{
  lib,
  config,
  ...
}: let
  cfg = config.hex.shared.home.editor;
in {
  options.hex.shared.home.editor.enable = lib.mkEnableOption "helix editor";

  config = lib.mkIf cfg.enable {
    home-manager.users.hexzii = {
      # TODO: might use dotfiles manager (chezmoi) later
      programs.helix = {
        enable = true;
      };
    };
  };
}
