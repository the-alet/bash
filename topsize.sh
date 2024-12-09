#!/bin/bash

# Default values
N=""
minsize=1
is_readable=false
directories=(".")
help=false

# Function to display help
display_help() {
    echo "Usage: topsize [--help] [-h] [-N] [-s minsize] [--] [dir...]"
    echo ""
    echo "Options:"
    echo "  --help       Display this help message"
    echo "  -h           Output size in readable format"
    echo "  -N           Number of files to display (e.g., -10)"
    echo "  -s minsize   Minimum file size in bytes (default: 1 byte)"
    echo "  dir...       Directories to search (default: current directory)"
    echo "  --           Option and directory separation"
}

# Parse options
while [[ $# -gt 0 ]]; do
    case "$1" in
        -h)
            is_readable=true
            shift
            ;;
        -N)
            if [[ -n "$2" && "$2" != -* ]]; then
                N="$2"
                shift 2
            else
                echo "Option -N requires an argument." >&2
                exit 1
            fi
            ;;
        -s)
            if [[ -n "$2" && "$2" != -* ]]; then
                minsize="$2"
                shift 2
            else
                echo "Option -s requires an argument." >&2
                exit 1
            fi
            ;;
        --help)
            display_help
            exit 0
            ;;
        --)
            shift
            break
            ;;
        -*)
            echo "Invalid option: $1" >&2
            exit 1
            ;;
        *)
            break
            ;;
    esac
done

shift $((OPTIND -1))

# Remaining arguments are directories
if [ "$#" -gt 0 ]; then
    directories=("$@")
fi

# Find files larger than minsize
find "${directories[@]}" -type f -size +"${minsize}"c -printf "%s %p\n" 2>/dev/null | \
sort -nr | \
{
    if [ -n "$N" ]; then
        head -n "$N"
    else
        cat
    fi
} | \
{
    if [ "$is_readable" = true ]; then
        awk '{ split("B KB MB GB TB", units); s=$1; for (i=1; s>=1024 && i<5; i++) s/=1024; printf "%.2f %s %s\n", s, units[i], $2 }'
    else
        cat
    fi
}