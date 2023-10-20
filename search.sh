#! /bin/bash

set -e

search_term=$1
source_dir=$2
output_flag=$3
output_dir=$4

version="1.1.0"

function getAbosolutePath { 
    echo $(cd $1; pwd) 
}

function print_help {
    cat << EOF
Usage: $0 [-ohv] [search_term] [source_dir] -o [output_dir]

Options:
    -h, --help          Print this help
    -o, --output        Output directory for headers 
    -v, --version       Current version
EOF
}

function exit_script {
    exit_code=$1
    exit $exit_code
}

function show_syntax {
    echo $0 [search_term] [source_dir] -o [output_dir]
}

function show_version {
    echo $0 current version $version
}

case "$1" in
    "--output" | "-o")
        show_syntax
        exit_script
    ;;
    "--help" | "-h")
        print_help
        exit_script
    ;;
    "--version" | "-v")
        show_version
        exit_script
    ;;
    *)
        #show_version
    ;;
esac

#The "" around search_term makes the string empty if no arguments are supplied to the script or else
#the if else just doesn't work

if ! [ -n "$search_term" ]; then
    print_help
    exit_script 1
fi

if ! [ -d "$source_dir" ]; then
    echo Error source directory does not exist
    exit_script 1
fi

if ! [[ $output_flag = "-o" || $output_flag = "-output" ]]; then
    show_syntax
    exit_script 1
fi

if ! [ -n "$output_dir" ]; then
    echo Error no output directory inputted
    exit_script 1
fi

mkdir $output_dir

for header in $source_dir/*; do
    if grep -q -i $search_term $header; then
        echo "found $(search_term) in $(basename $header) copying header to "; 
        echo "$(getAbosolutePath $output_dir)";
        cp $header $output_dir 
    fi
done








