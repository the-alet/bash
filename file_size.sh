#!/bin/bash

# Function to display usage
usage() {
  echo "Usage: $0 [options] [--] file1 file2 ..."
  echo "Options:"
  echo "  -s      Output total size at the end."
  echo "  -S      Output only the total size."
  echo "  --usage Display this usage information."
  echo "  --help  Display detailed help."
}

# Function to display help
help() {
  echo "This script outputs information about the size of files."
  echo "The list of files is passed as parameters."
  echo
  usage
  echo
  echo "If no options are given, the information is output in the format:"
  echo "  Size filename"
  echo
  echo "If the -s option is given, the total size of the files is output at the end."
  echo "If the -S option is specified, only the total file size is output."
  echo "-s and -S options can also be given in between and after arguments."
  echo
  echo "The script supports file names containing spaces and shell characters,"
  echo "as well as files whose names begin with '-', including having the -- option"
  echo "and file list delimiter."
  echo
  echo "Determine the size of each file using stat."
  echo "Do not use utilities like du/ls/find etc."
}

# Initialize variables
show_total=false
only_total=false
exit_code=0
total_size=0
files=()

# Parse options and files
while [[ $# -gt 0 ]]; do
  case "$1" in
    -s)
      show_total=true
      shift
      ;;
    -S)
      only_total=true
      shift
      ;;
    --usage)
      usage
      exit 0
      ;;
    --help)
      help
      exit 0
      ;;
    --)
      shift
      files+=("$@")
      break
      ;;
    -*)
      echo "Error: Unsupported option $1"
      exit 2
      ;;
    *)
      files+=("$1")
      shift
      ;;
  esac
done

# Process each file
for file in "${files[@]}"; do
  if [[ -e "$file" ]]; then
    size=$(stat -c%s "$file" 2>/dev/null)
    if [[ $? -eq 0 ]]; then
      total_size=$((total_size + size))
      if [[ "$only_total" == false ]]; then
        echo "$size $file"
      fi
    else
      echo "Error: Could not determine size of $file"
      exit_code=1
    fi
  else
    echo "Error: File $file does not exist"
    exit_code=1
  fi
done

# Output total size if needed
if [[ "$show_total" == true || "$only_total" == true ]]; then
  echo "Total size: $total_size"
fi

exit $exit_code