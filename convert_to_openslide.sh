#!/bin/bash

# Check if the directory argument is provided
if [ $# -eq 0 ]; then
    echo "Usage: $0 <directory>"
    exit 1
fi

# Directory containing the .tif files (passed as the first argument)
directory="$1"

# Check if the provided directory exists
if [ ! -d "$directory" ]; then
    echo "Error: Directory '$directory' does not exist."
    exit 1
fi

# Make a new directory for the converted files
convertedDirectory="${directory}/converted"

if [ ! -d "$convertedDirectory" ]; then
    mkdir -p "$convertedDirectory"
    echo "Created directory '$convertedDirectory'"
fi

# Loop through each .tif file in the directory
for file in "$directory"/*.tiff; do
    # Check if file is a regular file
    if [ -f "$file" ]; then
        # Extract filename without extension
        filename=$(basename -- "$file")
        filename="${filename%.*}"
    
        # Perform the ImageMagick conversion
        tiledFile="${convertedDirectory}/${filename}_tiled.tiff"
        convert "$file" -define tiff:tile-geometry=256x256 -compress jpeg "ptif:${tiledFile}"
        echo "Converted $file to ${tiledFile}"

        # Perform the tifftools command
        tifftools set -y -s ImageDescription "Aperio Fake |AppMag = 40|MPP = 0.23" "${tiledFile}"
        echo "Updated image description for ${tiledFile}"
    fi
done

echo "All conversions and updates completed."
