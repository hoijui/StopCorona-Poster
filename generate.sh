#!/usr/bin/env bash
# Generates portable versions of the posters:
# SVG, PNG and PDF

# Exit immediately on each error and unset variable;
# see: https://vaneyckt.io/posts/safer_bash_scripts_with_set_euxo_pipefail/
#set -Eeuo pipefail
set -Eeu

output_dir="output"
mkdir -p "$output_dir"

for poster_ai in *.ai
do
	poster=$(basename --suffix=".ai" "$poster_ai")

	echo
	echo "Generating $poster PNG, PDF and SVG) ..."

	# Generate PNG
	inkscape --without-gui "$poster_ai" \
		--export-png "$output_dir/$poster.png"

	# Generate PDF
	inkscape --without-gui "$poster_ai" \
		--export-pdf "$output_dir/$poster.pdf"

	# Generate SVG
	# NOTE `--export-text-to-path` is required
	#      for text to render properly/at all
	inkscape --without-gui "$poster_ai" \
		--export-text-to-path \
		--export-plain-svg "$output_dir/$poster.svg"
done

echo
echo "done."
