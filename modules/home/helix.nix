{...}: {
  programs.helix = {
    enable = true;
    defaultEditor = true;
    # we do not explicitly manage config here
    # TODO: use dotfiles later
  };
}
