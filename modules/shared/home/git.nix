{
  lib,
  config,
  pkgs,
  ...
}: let
  cfg = config.hex.shared.home.git;
in {
  options.hex.shared.home.git.enable = lib.mkEnableOption "git with gh, lazygit, delta";

  config = lib.mkIf cfg.enable {
    home-manager.users.hexzii = {
      home.packages = with pkgs; [
        difftastic
        git-lfs # TODO: wip
        git # todo: linux lib.mkIf pkgs.stdenv.hostPlatform.isLinux pkgs.gitFull
        gh
        prek # a pre-commit alternative
        jujutsu
        delta
        lazygit
      ];
    };
  };
}
