# ==================== Shell: Zsh ====================
{...}: {
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;

    initContent = ''
      # ---- Proxy ----
      _PROXY_DEFAULT="http://192.168.2.149:10808"
      _PROXY_FILE="''${HOME}/.cache/proxy-state"

      # 持久化: 上次 proxy_on 的状态
      if [[ -f "$_PROXY_FILE" ]]; then
        source "$_PROXY_FILE"
      fi

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
      cd = "z"; # make it default as z
      ls = "eza";
      ll = "eza -l";
      la = "eza -la";
      lt = "eza --tree";
      top = "btop";
    };
  };

  programs.starship.enable = true;
  programs.atuin = {
    enable = true;
    enableZshIntegration = true;
  };

  programs.zoxide = {
    enable = true;
    enableZshIntegration = true;
  };

  programs.direnv = {
    enable = true;
    enableZshIntegration = true;
    nix-direnv.enable = true;
  };
}
