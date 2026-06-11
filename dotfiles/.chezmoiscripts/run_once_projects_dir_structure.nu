#!/usr/bin/env nu

let BASE = $"($env.HOME)/projects"

let CATEGORIES = [
    # "nixos-config": clone this repo into the directory!!
    "archived"            # (permanently) archived code
    "me-related"          # my website / profile / blogs
    "hardware"            # embedded development
    "games"               # engine-based, godot, unity, phaser, etc.
    "general"             # multilingual / large projects
    "docs"                # documentational projects
    # art / design related stuff
    "art"
    "art/visual"          # motion graphics, pixel art, shaders, etc.
    "art/audio"           # audio experiments
    # code forks / contributions
    "contributions"
    "contributions/_archive"  # archived / stale contribs
    # language-specific projects
    "languages"
    "languages/rust"
    "languages/js"        # nodejs / bun library / projects
    "languages/web"       # web-stack related
    "languages/dotnet"    # csharp / dotnet projects
    "languages/java"      # java / kotlin / jvm projects
    "languages/python"
    "languages/nix"
    "languages/dart"      # dart / flutter
    "languages/c"         # good ol' c language (c++)
    "languages/go"
]

print $"(ansi green)ensuring project folder structure under ($BASE) ...(ansi reset)"

mkdir $BASE

for cat in $CATEGORIES {
    let target = $"($BASE)/($cat)"
    if not ($target | path exists) {
        mkdir $target
        print $"- created: ($target)"
    } else {
        print $"- exists:  ($target)"
    }
}

print "Ciallo～(∠・ω< )⌒★"