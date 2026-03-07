#! /usr/bin/env zsh -e

find . -name "*.backup" -exec sh -c 'mv "$1" "${1%.backup}"' _ {} \;
