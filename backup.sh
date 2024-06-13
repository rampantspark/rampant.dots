#!/bin/bash

# Define the source directory
src_dir="$HOME/.config"

# Define the destination directory
dest_dir="."

# Array of directories to copy files from
copy_dirs=("bspwm" "dunst" "fish" "hypr" "kitty" "neofetch" "nvim" "picom" "polybar" "ranger" "rofi" "sxhkd" "tmux" "zathura")

# Function to copy directories recursively
copy_directories() {
    local src="$1"
    local dest="$2"

    # Copy directory recursively
    cp -R "$src" "$dest"

    # Check if copy was successful
    if [ $? -eq 0 ]; then
        echo "Copied: $src to $dest"
    else
        echo "Failed to copy: $src"
    fi
}

# Main function
main() {
    # Check if source directory exists
    if [ ! -d "$src_dir" ]; then
        echo "Source directory $src_dir does not exist."
        exit 1
    fi

    # Check if destination directory exists
    if [ ! -d "$dest_dir" ]; then
        echo "Destination directory $dest_dir does not exist."
        exit 1
    fi

    # Iterate through directories to copy
    for dir in "${copy_dirs[@]}"; do
        src_path="$src_dir/$dir"
        if [ -d "$src_path" ]; then
            copy_directories "$src_path" "$dest_dir"
        else
            echo "Directory $dir does not exist in $src_dir"
        fi
    done
}

# Run the main function
main
