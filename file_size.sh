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
s_flag=0
S_flag=0
exit_code=0
total_size=0
_flag=0
files=()

# Parse options and files
while [[ $# -gt 0 ]]; do
  case "$1" in
    -s)
      s_flag=1
      break
      ;;
    -S)
      S_flag=1
      break
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
      break
      ;;
    -*)
      echo "Error: Unsupported option $1"
      exit 2
      ;;
  esac
done

# Process each file
for file in "$@"
do
  if [[ "$file" == "--" && $_flag -eq 0 ]]; then
    _flag=1
    continue
  fi

  if [[ "$file" == "-s" || "$file" == "-S" ]] && [ $_flag -eq 0 ]; then
    continue
  fi

  if ! [ -e "$file" ]; then
    echo "File $file doesn't exists!" >&2
    exit_code=1
    continue
  fi

  if [[ $s_flag -eq 1 || $S_flag -eq 1 ]]; then
    total_size=$(($total_size + $(stat -c%s -- "$file")))
  fi
  if [[ $S_flag -eq 0 ]]; then
    echo $(stat -c%s" "%n -- "$file")
  fi
done

if [[ $s_flag -eq 1 || $S_flag -eq 1 ]]
then
  echo $total_size
fi

exit $exit_code