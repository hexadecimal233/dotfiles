{
  self,
  pkgs,
  ...
}: {
  imports = [
    self.darwinModules.darwin
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
      };
    };
    hex.shared.system = {
      enable = true;
      tools.enable = true;
    };
    hex.shared.home.shell.enable = true;
    hex.shared.home.git.enable = true;
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
    hex.shared.home.pgp.enable = true;

    # macOS user
    users.users.hexzii = {
      home = "/Users/hexzii"; # depreacted, just make home manager work
    };

    # nix-darwin platform
    nixpkgs.hostPlatform = "aarch64-darwin";
  };
}
