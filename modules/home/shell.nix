{pkgs, ...}: {
  programs.fish = {
    enable = true;

    shellInit = ''
      # ---- Proxy ----
      set -g _PROXY_DEFAULT "http://192.168.2.149:10808"
      set -g _PROXY_FILE "$HOME/.cache/proxy-state"

      # 持久化: 上次 proxy_on 的状态
      if test -f "$_PROXY_FILE"
        source "$_PROXY_FILE"
      end

      # 开启代理 (持久化到 ~/.cache/proxy-state)
      function proxy_on -d "Enable proxy"
        set proxy (test -n "$argv[1]"; and echo "$argv[1]"; or echo "$_PROXY_DEFAULT")
        mkdir -p (dirname "$_PROXY_FILE")
        echo "set -gx http_proxy $proxy
        set -gx https_proxy $proxy
        set -gx HTTP_PROXY $proxy
        set -gx HTTPS_PROXY $proxy" > "$_PROXY_FILE"
        source "$_PROXY_FILE"
        echo "proxy ON  → $proxy"
      end

      # 关闭代理 (清除持久化)
      function proxy_off -d "Disable proxy"
        set -e http_proxy https_proxy HTTP_PROXY HTTPS_PROXY
        rm -f "$_PROXY_FILE"
        echo "proxy OFF"
      end
    '';

    # shell command shorthands
    shellAliases = {
      cd = "z";
      cat = "bat";
      ls = "eza";
      ll = "eza -l";
      la = "eza -la";
      lt = "eza --tree";
      top = "btop";
    };
  };

  programs.starship.enable = true;

  # atuin - a bit heavy
  # programs.atuin = {
  #   enable = true;
  #   enableFishIntegration = true;
  # };

  programs.zoxide = {
    enable = true;
    enableFishIntegration = true;
  };

  programs.direnv = {
    enable = true;
    enableFishIntegration = true;
    nix-direnv.enable = true;
  };

  # multiplexing
  home.packages = with pkgs; [
    tmux
    zellij
  ];
}
