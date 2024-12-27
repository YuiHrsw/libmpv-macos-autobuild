#!/bin/bash

# Exit immediately if a command exits with a non-zero status
set -e

# Function to display usage instructions
usage() {
    echo "Usage: $0 <path/to/lib.so> <path/to/output>"
    exit 1
}

# Check if exactly two arguments are provided
if [ "$#" -ne 2 ]; then
    echo "Error: Incorrect number of arguments."
    usage
fi

# Assign arguments to variables for clarity
LIB_PATH="$1"
OUTPUT_DIR="$2"

# Check if the input .so file exists
if [ ! -f "$LIB_PATH" ]; then
    echo "Error: The specified library '$LIB_PATH' does not exist."
    exit 1
fi

# Create the output directory if it doesn't exist
mkdir -p "$OUTPUT_DIR"

# Declare an associative array to keep track of processed libraries
declare -A processed_libs

# Function to process a library and its dependencies
process_library() {
    local current_lib="$1"

    # If the library has already been processed, skip it
    if [[ -n "${processed_libs["$current_lib"]}" ]]; then
        return
    fi

    # Mark the library as processed
    processed_libs["$current_lib"]=1

    echo "Processing '$current_lib'..."

    # Run ldd on the current library and extract DLL paths
    ldd "$current_lib" | grep '=>' | awk '{print $3}' | grep -v '^/c/Windows' | while read -r dll_path; do
        # Skip if the path is empty
        if [ -z "$dll_path" ]; then
            continue
        fi

        # Normalize the DLL path
        dll_path=$(cygpath -u "$dll_path")

        # Extract the DLL name from the path
        dll_name=$(basename "$dll_path")

        # Define the destination path in the output directory
        dest_path="$OUTPUT_DIR/$dll_name"

        # Check if the DLL already exists in the output directory
        if [ -f "$dest_path" ]; then
            echo "Skipped '$dll_name' as it already exists in the output directory."
            continue
        fi

        # Check if the DLL exists
        if [ ! -f "$dll_path" ]; then
            echo "Warning: '$dll_path' does not exist and will be skipped."
            continue
        fi

        # Copy the DLL to the output directory
        cp "$dll_path" "$OUTPUT_DIR"
        echo "Copied '$dll_name' to '$OUTPUT_DIR'"

        # Recursively process the copied DLL
        process_library "$dll_path"
    done
}

# Start processing with the initial library
process_library "$LIB_PATH"

echo "All dependencies have been successfully extracted to '$OUTPUT_DIR'."