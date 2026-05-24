{...}: {
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
}
