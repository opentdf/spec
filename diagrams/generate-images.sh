#!/usr/bin/env bash
set -euo pipefail

FILES="$(PWD)/*.mmd"

for f in $FILES
do
    filename=${f##*/}
    #$file is now 'file.gif'
    base=${filename%.*}
    #${base} is now 'file'.

    echo "Rendering $filename Mermaid markup to SVG..."
    mmdc -i "$f" -o "$base".svg

    echo "Rendering $filename Mermaid markup to PNG..."
    mmdc -i "$f" -o "$base".png
done
