#!/usr/bin/env nu

# Set chezmoi sourceDir to the current directory
let config_dir = ($nu.home-dir | path join ".config" "chezmoi")
let config_file = ($config_dir | path join "chezmoi.toml")

mkdir $config_dir

let current_dir = (pwd)
let source_dir_unix = ($current_dir | str replace -a '\' '/')   # \ -> /

$"sourceDir = \"($source_dir_unix)\"" | save -f $config_file

print $"✓ Set chezmoi sourceDir: ($source_dir_unix)"