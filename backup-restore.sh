#!/bin/bash

# Define the source directory
src_dir="$HOME/.config"

# Define the base destination directories
config_dest_dir="./config/"
themes_base_dir="./themes/"

# Array of directories to copy files from
config_src_dirs=("dunst" "ranger" "tmux" "zathura")
x11_theme_src_dirs=("bspwm" "kitty" "picom" "polybar" "rofi" "sxhkd" "tmux")
hypr_theme_src_dirs=("hypr" "kitty" "rofi" "tmux")

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

# Function to perform backup
backup() {
    window_system="$1"
    theme_dest_dir="$themes_base_dir$2"

    case $window_system in
        x11)
            theme_src_dirs=("${x11_theme_src_dirs[@]}")
            ;;
        wayland)
            theme_src_dirs=()
            echo "Wayland specific directories are not defined. Exiting."
            exit 1
            ;;
        hypr)
            theme_src_dirs=("${hypr_theme_src_dirs[@]}")
            ;;
        *)
            echo "Invalid argument: $window_system. Use x11, wayland, or hypr."
            exit 1
            ;;
    esac

    # Check if source directory exists
    if [ ! -d "$src_dir" ]; then
        echo "Source directory $src_dir does not exist."
        exit 1
    fi

    # Check if destination config directory exists
    if [ ! -d "$config_dest_dir" ]; then
        echo "Destination directory $config_dest_dir does not exist."
        exit 1
    fi

    # Create the destination theme directory if it doesn't exist
    if [ ! -d "$theme_dest_dir" ]; then
        mkdir -p "$theme_dest_dir"
        if [ $? -eq 0 ]; then
            echo "Created destination theme directory: $theme_dest_dir"
        else
            echo "Failed to create destination theme directory: $theme_dest_dir"
            exit 1
        fi
    fi

    # Copy config directories
    for dir in "${config_src_dirs[@]}"; do
        src_path="$src_dir/$dir"
        if [ -d "$src_path" ]; then
            copy_directories "$src_path" "$config_dest_dir"
        else
            echo "Directory $dir does not exist in $src_dir"
        fi
    done

    # Copy theme directories
    for dir in "${theme_src_dirs[@]}"; do
        src_path="$src_dir/$dir"
        if [ -d "$src_path" ]; then
            copy_directories "$src_path" "$theme_dest_dir"
        else
            echo "Directory $dir does not exist in $src_dir"
        fi
    done
}

# Function to install a theme
install_theme() {
    window_system="$1"
    theme_dest_dir="$themes_base_dir$2"

    case $window_system in
        x11)
            theme_src_dirs=("${x11_theme_src_dirs[@]}")
            ;;
        wayland)
            theme_src_dirs=()
            echo "Wayland specific directories are not defined. Exiting."
            exit 1
            ;;
        hypr)
            theme_src_dirs=("${hypr_theme_src_dirs[@]}")
            ;;
        *)
            echo "Invalid argument: $window_system. Use x11, wayland, or hypr."
            exit 1
            ;;
    esac

    # Check if source directory exists
    if [ ! -d "$src_dir" ]; then
        echo "Source directory $src_dir does not exist."
        exit 1
    fi

    # Create the destination theme directory if it doesn't exist
    if [ ! -d "$theme_dest_dir" ]; then
        mkdir -p "$theme_dest_dir"
        if [ $? -eq 0 ]; then
            echo "Created destination theme directory: $theme_dest_dir"
        else
            echo "Failed to create destination theme directory: $theme_dest_dir"
            exit 1
        fi
    fi

    # Copy theme directories
    for dir in "${theme_src_dirs[@]}"; do
        src_path="$src_dir/$dir"
        if [ -d "$src_path" ]; then
            copy_directories "$src_path" "$theme_dest_dir"
        else
            echo "Directory $dir does not exist in $src_dir"
        fi
    done
}

# Main function
main() {
    # Check if the correct number of arguments is provided
    if [ "$#" -lt 2 ]; then
        echo "Usage: $0 {backup|install} {x11|wayland|hypr} [theme_destination_directory]"
        exit 1
    fi

    operation="$1"
    window_system="$2"
    
    case $operation in
        backup)
            if [ "$#" -ne 3 ]; then
                echo "Usage for backup: $0 backup {x11|wayland|hypr} <theme_destination_directory>"
                exit 1
            fi
            theme_dest_dir="$3"
            backup "$window_system" "$theme_dest_dir"
            ;;
        install)
            if [ "$#" -ne 3 ]; then
                echo "Usage for install: $0 install {x11|wayland|hypr} <theme_destination_directory>"
                exit 1
            fi
            theme_dest_dir="$3"
            install_theme "$window_system" "$theme_dest_dir"
            ;;
        *)
            echo "Invalid operation: $operation. Use backup or install."
            exit 1
            ;;
    esac
}

# Run the main function with the provided arguments
main "$@"
