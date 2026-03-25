#! /usr/bin/env zsh

find . -name "*.backup" -exec sh -c 'mv "$1" "${1%.backup}"' _ {} \;
