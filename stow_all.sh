#!/usr/bin/env bash

# Change directory to dotfiles for cleaner path handling
cd ~/dotfiles

# Loop through each directory in the current directory (excluding .)
for directory in */; do
  # Get the directory name (package name)
  package_name="${directory%%/}"

  # Check if it's a directory (avoid hidden files)
  if [ -d "$directory" ]; then
    # Use stow with the -R flag (restow) to overwrite existing symlinks
    stow -R "$package_name"
    echo "Stowed package: $package_name"
  fi
done

echo "All dotfiles stowed!"
