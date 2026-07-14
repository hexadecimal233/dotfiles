#!/usr/bin/env nu
# my project structure bones


let FOLDERS = [
    # data folder
    "data/extracted-exts" # chrome extracted extensions
    "data/src" # random src (downloaded or private ig)
    "data/archived" # (permanently) archived code

    # "nixos-config": clone this repo into the directory!!
    "projects/me-related"            # my website / profile / blogs
    # game dev
    "projects/games/general"         # godot, unity, phaser, or self built engine games
    "projects/games/mod"             # mod development
    "projects/games/mod/minecraft"   # minecraft mod
    "projects/general"               # multilingual / large projects
    "projects/docs"                  # documentational projects
    # art / design related stuff
    "projects/art/visual"            # motion graphics, pixel art, shaders, etc.
    "projects/art/audio"             # audio experiments
    "projects/contributions" # code forks / contributions
    # language-specific projects
    "projects/languages/rust"
    "projects/languages/swift"
    "projects/languages/js"          # nodejs / bun library / projects
    "projects/languages/web"         # web-stack related
    "projects/languages/dotnet"      # csharp / dotnet projects
    "projects/languages/java"        # java / kotlin / jvm projects
    "projects/languages/python"
    "projects/languages/nix"
    "projects/languages/dart"        # dart / flutter
    "projects/languages/c"           # good ol' c language (c, c++, c3)
    "projects/languages/go"
    # platform-specific projects
    "projects/platform/hardware"     # hardware/embedded
    "projects/platform/android"
    "projects/platform/linux"
    "projects/platform/windows"
    "projects/platform/apple"
]

print $"(ansi green)ensuring project folder structure under ($nu.home-dir) ...(ansi reset)"

for folder in $FOLDERS {
    let target = $"($nu.home-dir)/($folder)"
    if not ($target | path exists) {
        mkdir $target
        print $"- created: ($target)"
    } else {
        print $"- exists:  ($target)"
    }
}

print "Ciallo～(∠・ω< )⌒★！！Folders have been created~"
