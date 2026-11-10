#!/bin/sh
printf '\033c\033]0;%s\a' RTS-src
base_path="$(dirname "$(realpath "$0")")"
"$base_path/RTS-src.x86_64" "$@"
