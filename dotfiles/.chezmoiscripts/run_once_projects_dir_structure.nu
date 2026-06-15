#!/usr/bin/env nu
# my project structure bones


let BASE = $"($env.HOME)/projects"

let CATEGORIES = [
    # "nixos-config": clone this repo into the directory!!

    "archived" # (permanently) archived code
    "raw-src" # raw src (prob randomly downloaded code for some purposes)

    "me-related"          # my website / profile / blogs

    # game dev
    "games/general" # godot, unity, phaser, or self built engine games
    "games/mod" # mod development
    "games/mod/minecraft" # minecraft mod

    "general"             # multilingual / large projects
    "docs"                # documentational projects

    # art / design related stuff
    "art/visual"          # motion graphics, pixel art, shaders, etc.
    "art/audio"           # audio experiments

    # code forks / contributions
    "contributions/_archive"  # archived / stale contribs

    # language-specific projects
    "languages/rust"
    "languages/swift"
    "languages/js"        # nodejs / bun library / projects
    "languages/web"       # web-stack related
    "languages/dotnet"    # csharp / dotnet projects
    "languages/java"      # java / kotlin / jvm projects
    "languages/python"
    "languages/nix"
    "languages/dart"      # dart / flutter
    "languages/c"         # good ol' c language (c, c++, c3)
    "languages/go"

    # platform-specific projects
    "platform/hardware" # hardware/embedded
    "platform/android"
    "platform/linux"
    "platform/windows"
    "platform/apple"
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

print "Ciallo～(∠・ω< )⌒★！！Folders have been created~"
