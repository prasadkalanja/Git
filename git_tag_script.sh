#!/bin/bash

read -p "Enter version numbers (comma-separated, e.g., 2.24.0,2.25.0,2.26.0): " versions

# Convert comma-separated string to array
IFS=',' read -ra version_array <<< "$versions"

for version in "${version_array[@]}"; do
  tag="v$version"
  git tag -a "$tag" -m "Release $tag"
done

echo "Tags created successfully!"
