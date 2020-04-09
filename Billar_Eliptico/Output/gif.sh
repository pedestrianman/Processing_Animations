#!/bin/sh

palette="/tmp/palette.png"
filters="fps=20,scale=1000:-1:flags=lanczos"

ffmpeg -v warning -i frame_%04d.png -vf "$filters,palettegen" -y $palette
ffmpeg -v warning -i frame_%04d.png -i $palette -lavfi "$filters [x]; [x][1:v] paletteuse" -y $1

