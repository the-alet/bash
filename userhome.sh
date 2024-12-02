#!/bin/bash

error_exit() {
    echo "$1" >&2
    exit "$2"
}

file="/etc/passwd"
login=""

while [[ $# -gt 0 ]]; do
    case "$1" in
        -f)
            shift
            file="$1"
            ;;
        -*)
            error_exit "Wrong argument: $1" 2
            ;;
        *)
            login="$1"
            ;;
    esac
    shift
done

if [ -z "$login" ]; then
    login="$(whoami)"
fi

if [ ! -f "$file" ]; then
    error_exit "File '$file' not found." 2
fi

home_dir=$(grep "^$login:" "$file" | cut -d: -f6)

if [ -z "$home_dir" ]; then
    error_exit "User '$login' not found." 1
fi

echo "$home_dir"
exit 0