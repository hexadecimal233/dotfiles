{
  self,
  pkgs,
  ...
}: {
  imports = [
    self.darwinModules.profile
  ];

  config = {
    # host identity
    system.stateVersion = 6; # nix-darwin uses integer stateVersion

    home-manager.users.hexzii.home.stateVersion = "26.05";

    # hex options
    hex.shared.nix.enable = true;
    hex.darwin.system = {
      enable = true;
      virtualization.enable = true;
    };
    hex.shared.desktop = {
      enable = true;
      fonts = {
        enable = true;
        source = true;
      };
    };
    hex.shared.system = {
      enable = true;
      tools.enable = true;
    };
    hex.shared.home.shell.enable = true;
    hex.shared.home.git.enable = true;
    hex.shared.home.editor.enable = true;
    hex.shared.home.dev = {
      enable = true;
      ai.enable = true;
      nodejs.enable = true;
    };
    hex.shared.home.packages = {
      enable = true;
      systemTools = true;
      dataProcessing = true;
      fileTools = true;
      mediaUtils = true;
      network = true;
      beautify = true;
    };
    hex.shared.home.gpg.enable = true;

    # host-specific proxy
    home-manager.users.hexzii.home.sessionVariables = {
      PROXY_DEFAULT = "http://localhost:7897";
    };

    # macOS user
    users.users.hexzii = {
      name = "hexzii";
      home = "/Users/hexzii";
      shell = pkgs.fish;
    };

    # nix-darwin platform
    nixpkgs.hostPlatform = "aarch64-darwin";
    system.primaryUser = "hexzii";

    # homebrew (macOS-native apps)
    homebrew = {
      enable = true;
      onActivation.cleanup = "none"; # keep manually installed packages
      casks = [
        "ghostty"
        "firefox"
        "freetube"
        "utm"
        "stats"
        "vscodium"
        "rekordbox"
        # "middleclick" # does not work very well duh
        # bitwarden: installed via appstore
        "vesktop"
        "julyx10/lap/lap"
        "viarotel-org/escrcpy/escrcpy"
        "iina"
        "zed"
        "sourcegit"
        # "brewforge/extras/lyricsx-mxiris"
        "tabby" # multi-remote shell client
        # "warp"
        # "clash-verge-rev" install separately to prevent install conflicts
        # "gitbutler" 这东西太超前了只能说
        "hewigovens/tap/jayjay" # for jujustu, TODO: there's a crossplatform edit coming soon
        "neighbor-z/swiftmtp/swiftmtp"
        # fixme: fails after 2026/09/01due to fails_gatekeeper_check
        "glance-chamburr" # quicklook enhancements
        "ayugram"
      ];
    };
  };
}
