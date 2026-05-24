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

    initContent = ''
      # ---- Editor ----
      export EDITOR="vim"
      export VISUAL="vim"

      # ---- Proxy (从 .bashrc 迁移) ----
      _PROXY_DEFAULT="http://192.168.2.149:10808"
      _PROXY_FILE="''${HOME}/.cache/proxy-state"

      # 持久化: 上次 proxy_on 的状态
      if [[ -f "$_PROXY_FILE" ]]; then
        source "$_PROXY_FILE"
      fi

      # sudo 时携带 proxy 环境变量
      sudoe() {
        local proxy_vars=(
          http_proxy https_proxy HTTP_PROXY HTTPS_PROXY
          NO_PROXY   no_proxy
        )
        local env_args=()
        for var in "''${proxy_vars[@]}"; do
          [[ -n "''${(P)var}" ]] && env_args+=("$var=''${(P)var}")
        done
        if [[ "''${#env_args[@]}" -gt 0 ]]; then
          command sudo "''${env_args[@]}" "$@"
        else
          command sudo "$@"
        fi
      }

      # 开启代理 (持久化到 ~/.cache/proxy-state)
      proxy_on() {
        local proxy="''${1:-$_PROXY_DEFAULT}"
        mkdir -p "''${_PROXY_FILE:h}"
        cat > "$_PROXY_FILE" <<EOF
        export http_proxy="''${proxy}"
        export https_proxy="''${proxy}"
        export HTTP_PROXY="''${proxy}"
        export HTTPS_PROXY="''${proxy}"
      EOF
        source "$_PROXY_FILE"
        echo "proxy ON  → $proxy"
      }

      # 关闭代理 (清除持久化)
      proxy_off() {
        unset http_proxy https_proxy HTTP_PROXY HTTPS_PROXY
        rm -f "$_PROXY_FILE"
        echo "proxy OFF"
      }
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
      cd = "z";
      ls = "eza";
      ll = "eza -l";
      la = "eza -la";
      lt = "eza --tree";
      cat = "bat";
      top = "btop";
      gs = "git status";
      gp = "git push";
      gc = "git commit";
      gl = "git log --oneline --graph";
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
    settings = {
      user.name = "hexzii";
      user.email = "hexzii@nichijou.moe";
      init.defaultBranch = "main";
      http.postBuffer = 524288000;
      signing.signByDefault = true;
    };
  };

  programs.lazygit.enable = true;

  services.gpg-agent = {
    enable = true;
    enableSshSupport = true;
    pinentry.package = pkgs.pinentry-curses; # 终端
  };

  # ==================== 用户级包（从 configuration.nix 迁来） ====================
  home.packages = with pkgs; [
    # 系统工具 — 用户级别
    tmux
    gnupg
    uv

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
