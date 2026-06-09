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
    hex.darwin.enable = true;
    hex.system.enable = true;
    hex.shell.enable = true;
    hex.git.enable = true;
    hex.editor.enable = true;
    hex.dev.enable = true;
    hex.packages.enable = true;
    hex.gpg.enable = true;

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
      ];
    };
  };
}
