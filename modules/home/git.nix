{pkgs, ...}: {
  programs.git = {
    enable = true;
    settings = {
      user.name = "hexzii";
      user.email = "hexzii${"@"}nichijou.moe";
      init.defaultBranch = "main";
      http.postBuffer = 524288000;
      signing.signByDefault = true;
      # just manually added
      credential."https://github.com".helper = "${pkgs.gh}/bin/gh auth git-credential";
      alias = {
        # basic
        st = "status -sb";
        co = "checkout";
        cb = "checkout -b";
        br = "branch -vv";
        ci = "commit";
        cm = "commit -m";
        ca = "commit --amend";
        fuck = "commit --amend --no-edit";

        # logs
        lg = ''log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit'';
        lga = ''log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit --all'';

        # diffing
        diff = "diff --color";
        diffs = "diff --staged";
        difft = "-c diff.external=difft --no-pager diff";

        # push and pull
        psh = "push";
        pshf = "push --force-with-lease";
        pl = "pull";
        fch = "fetch --prune";

        # reverting
        undo = "reset --soft HEAD^";
        amend = "commit --amend --no-edit";
        unstage = "reset HEAD --";
      };
    };
  };

  home.packages = with pkgs; [
    difftastic
    gh
  ];

  # TODO: maybe move to dotfiles
  #  programs.gh = {
  #   enable = true;
  #   gitCredentialHelper.enable = true;  
  # };


  programs.lazygit.enable = true;
  programs.delta = {
    enable = true;
    enableGitIntegration = true;
  };
}
