{
  self,
  pkgs,
  home-manager,
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
    hex.darwin.system.enable = true;
    hex.shared.system.enable = true;
    hex.shared.home.shell.enable = true;
    hex.shared.home.git.enable = true;
    hex.shared.home.editor.enable = true;
    hex.shared.home.dev.enable = true;
    hex.shared.home.packages.enable = true;
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
        "middleclick"
      ];
    };
  };
}
