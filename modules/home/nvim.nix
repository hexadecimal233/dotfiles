{...}: {
  programs.neovim = {
    enable = true;
    viAlias = true;
    vimAlias = true;
  };

  home.sessionVariables.EDITOR = "nvim";
  home.sessionVariables.VISUAL = "nvim";
  
  # warning silencer
  programs.neovim.withRuby = false;
  programs.neovim.withPython3 = false;
}
