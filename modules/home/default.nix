{
  config,
  pkgs,
  lib,
  ...
}: {
  # ==================== Shell: Zsh ====================
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;

    initExtra = ''
      export EDITOR="vim"
      export VISUAL="vim"
    '';

    zplug = {
      enable = true;
      plugins = [
        {
          name = "plugins/git";
          tags = ["from:oh-my-zsh"];
        }
        {
          name = "fdellwing/zsh-bat";
          tags = ["as:command"];
        }
      ];
    };

    shellAliases = {
      ls = "eza";
      ll = "eza -l";
      la = "eza -la";
      lt = "eza --tree";
      cat = "bat";
      grep = "rg";
      find = "fd";
      top = "btop";
      gs = "git status";
      gp = "git push";
      gc = "git commit";
      gl = "git log --oneline --graph";
      nrs = "sudo nixos-rebuild switch --flake .#";
    };
  };

  programs.starship.enable = true;

  # ==================== Shell 工具 ====================
  programs.zoxide = {
    enable = true;
    enableZshIntegration = true;
  };

  programs.direnv = {
    enable = true;
    enableZshIntegration = true;
    nix-direnv.enable = true;
  };

  programs.bat.enable = true;
  programs.fzf.enable = true;
  programs.eza = {
    enable = true;
    enableZshIntegration = true;
  };

  # ==================== Git ====================
  programs.git = {
    enable = true;
    userName = "hexzii";
    userEmail = "hexzii@nichijou.moe";
    extraConfig = {
      init.defaultBranch = "main";
      pull.rebase = true;
    };
    ignores = [".direnv" ".envrc" "result*"];
  };

  programs.lazygit.enable = true;

  # ==================== 用户级包（从 configuration.nix 迁来） ====================
  home.packages = with pkgs; [
    # 系统工具 — 用户级别
    tmux

    # 文件工具（原来在 systemPackages）
    ripgrep
    fd
    fzf

    # 美化
    starship
    eza
    bat
    fastfetch
    hyfetch
  ];

  # ==================== 环境变量 ====================
  home.sessionVariables = {
    EDITOR = "vim";
    VISUAL = "vim";
  };

  home.stateVersion = "25.11";
}
