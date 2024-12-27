#!/usr/bin/env bash

import os
import subprocess
import shutil
import argparse
import platform

def get_dependencies(file):
    """
    Get the list of dependencies for a given file using otool.
    """
    # Determine the architecture
    arch = platform.machine()
    homebrew_dir = '/opt/homebrew' if arch == 'arm64' else '/usr/local'

    result = subprocess.run(['otool', '-L', file], capture_output=True, text=True)
    output = result.stdout

    print(output)

    dependencies = []
    for line in output.splitlines()[1:]:
        dep_path = line.split()[0]
        if dep_path.startswith(homebrew_dir):
            dependencies.append(dep_path)
    return dependencies

def copy_dependencies(file, dest_dir, copied_files, trim=''):
    """
    Recursively copy the dependencies of a file to the destination directory.
    """
    if file in copied_files:
        return

    copied_files.add(file)
    shutil.copy(file, dest_dir)
    dependencies = get_dependencies(file)
    print(f"{trim}{file} -> {dependencies}")
    for dep in dependencies:
        dep_path = os.path.realpath(dep)
        if not os.path.exists(dep_path):
            print(f"Warning: Dependency {dep_path} does not exist.")
            continue
        copy_dependencies(dep_path, dest_dir, copied_files, f"{trim}  ")

def main():
    parser = argparse.ArgumentParser(description="Copy library and its dependencies.")
    parser.add_argument('libmpv_path', help="Path to the libmpv library file.")
    parser.add_argument('dest_dir', help="Destination directory to copy dependencies.")
    args = parser.parse_args()

    libmpv_path = args.libmpv_path
    dest_dir = os.path.expanduser(args.dest_dir)

    # Create the destination directory if it doesn't exist
    os.makedirs(dest_dir, exist_ok=True)

    # Copy libmpv.dylib and its dependencies
    copied_files = set()
    copy_dependencies(libmpv_path, dest_dir, copied_files)

    print(f"Copied {len(copied_files)} files to {dest_dir}")

if __name__ == '__main__':
    main()