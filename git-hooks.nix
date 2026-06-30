{
  git-hooks,
  pkgs,
  system,
}:
git-hooks.lib.${system}.run {
  src = ./.;

  hooks = {
    # Scan staged changes for secrets using betterleaks
    betterleaks = {
      enable = true;
      name = "betterleaks";
      description = "Scan pre-commit changes for secrets";
      entry = "${pkgs.betterleaks}/bin/betterleaks dir .";
      pass_filenames = false; # pre-commit copies staged files to temp dir
    };
  };
}
