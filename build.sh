#!/bin/bash

# Function to download a file from GitHub
download_file() {
    local github_url="$1"
    local target_dir="$2"
    local file_name="$3"

    # Check if cURL is installed
    if ! command -v curl &> /dev/null; then
        echo "cURL is not installed. Please install cURL to proceed."
        exit 1
    fi

    # Check if the target directory exists, if not, create it
    mkdir -p "$target_dir"

    # Download the file from GitHub
    curl -o "$target_dir/$file_name" "$github_url"

    # Check whether the download process was successful
    if [ $? -eq 0 ]; then
        echo "Downloaded file $file_name successfully."
    else
        echo "An error occurred during the file download process."
        exit 1
    fi
}

# Path to the resources/views directory of Laravel for elFinder setup
laravel_view_dir="resources/views/elfinder"
download_file "https://raw.githubusercontent.com/manh-dan/laravel-elfinder-ckeditor/main/setup.blade.php" "$laravel_view_dir" "setup.blade.php"

# Path to the public/packages/barryvdh/elfinder/js directory of Laravel for CKEditor 5 setup
laravel_public_dir="public/packages/barryvdh/elfinder/js"
download_file "https://raw.githubusercontent.com/manh-dan/laravel-elfinder-ckeditor/main/ckeditor5.min.js" "$laravel_public_dir" "ckeditor5.min.js"
