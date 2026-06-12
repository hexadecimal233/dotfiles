# Standalone audit: print hex config tree for any host
# Usage: nix eval '.#nixosConfigurations.<host>.config.hex' --apply 'import ./scripts/audit.nix'
hexConfig:
let
  esc = builtins.fromJSON ''"\u001b"'';
  green = "${esc}[38;5;46m";
  dim   = "${esc}[38;5;244m";
  bold  = "${esc}[1m";
  reset = "${esc}[0m";

  pipe       = "│   ";
  space      = "    ";
  branch     = "├── ";
  lastBranch = "└── ";

  build = nodePrefix: contPrefix: name: value:
    let
      line = if builtins.isBool value then
        if value
        then "${nodePrefix}${green}✅ ${name}${reset}"
        else "${nodePrefix}${dim}⬜ ${name}${reset}"
      else if builtins.isAttrs value then
        "${nodePrefix}${bold}${name}${reset}"
      else
        "${nodePrefix}${dim}${name}${reset}";
    in
    if ! builtins.isAttrs value then [line]
    else
      let
        names = builtins.attrNames value;
        go = idx: acc:
          if idx >= builtins.length names then acc
          else
            let
              n = builtins.elemAt names idx;
              isLast = idx == builtins.length names - 1;
              np = contPrefix + (if isLast then lastBranch else branch);
              cp = contPrefix + (if isLast then space else pipe);
            in
            go (idx + 1) (acc ++ build np cp n value.${n});
      in
      go 0 [line];

  lines = build "" "" "hex" hexConfig;
in
builtins.trace (builtins.concatStringsSep "\n" lines) null
