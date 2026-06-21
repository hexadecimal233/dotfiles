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
      programs.git = {
        enable = true;
        # gitFull includes git-credential-libsecret (Linux only; macOS uses osxkeychain natively)
        package = lib.mkIf pkgs.stdenv.hostPlatform.isLinux pkgs.gitFull;
        settings = {
          user.name = "hexzii";
          user.email = "hexzii${"@"}nichijou.moe";
          init.defaultBranch = "main";
          http.postBuffer = 524288000;
          signing.signByDefault = true;
          credential = lib.optionalAttrs pkgs.stdenv.hostPlatform.isLinux {
            helper = "${pkgs.gitFull}/bin/git-credential-libsecret";
          } // {
            "https://github.com".helper = "${pkgs.gh}/bin/gh auth git-credential";
          };
          alias = {
            st = "status -sb";
            co = "checkout";
            cb = "checkout -b";
            br = "branch -vv";
            ci = "commit";
            cm = "commit -m";
            ca = "commit --amend";
            fuck = "commit --amend --no-edit";

            lg = ''log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit'';
            lga = ''log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit --all'';

            diff = "diff --color";
            diffs = "diff --staged";
            difft = "-c diff.external=difft --no-pager diff";

            acp = "!f() { git add . && git commit -m \"$*\" && git push; }; f";
            psh = "push";
            pshf = "push --force-with-lease";
            pl = "pull";
            fch = "fetch --prune";

            undo = "reset --soft HEAD^";
            amend = "commit --amend --no-edit";
            unstage = "reset HEAD --";
          };
        };
      };

      home.packages = with pkgs; [
        difftastic
        git-lfs # TODO: wip
        gh # TODO: maybe move to dotfiles
        jujutsu
        lazygit
      ];

      programs.delta = {
        enable = true;
        enableGitIntegration = true;
      };
    };
  };
}
