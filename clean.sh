#! /bin/sh

find . -name "*.backup" -exec sh -c 'mv "$1" "${1%.backup}"' _ {} \; 
