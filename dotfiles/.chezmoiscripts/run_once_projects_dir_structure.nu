#!/usr/bin/env nu
# my project structure bones


let FOLDERS = [
    # data folder
    "data/extracted-exts" # chrome extracted extensions
    "data/src" # random src (downloaded or private ig)
    "data/archived"

    # "nixos-config": clone this repo into the directory!!
    "projects/me-related"            # my website / profile / blogs
    "projects/contributions" # code forks / contributions
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
