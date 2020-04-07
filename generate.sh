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

# Create an HTML index that links to all the generated image files
cd "$output_dir"
idx="index.html"
echo "<html>" > "$idx"
echo "<head>" >> "$idx"
echo "<title>StopCorona-Poster (generated files)</title>" >> "$idx"
echo "</head>" >> "$idx"
echo "<body>" >> "$idx"
echo "<h1>StopCorona-Poster (generated files)</h1>" >> "$idx"
echo "<p>This output is generated after each commit to <a href=\"https://gitlab.com/opencultureagency/StopCorona-Poster\">the StopCorona-Poster repo</a></p>" >> "$idx"
echo "<h3>as PNG bitmap images</h3>" >> "$idx"
echo "<ul>" >> "$idx"
for file in *.png; do
  echo "<li><a href=\"$file\">$file - <img src=\"$file\" alt=\"$file\" width=\"320\"/></a></li>" >> "$idx"
done
echo "</ul>" >> "$idx"
echo "<h3>as PDF documents</h3>" >> "$idx"
echo "<ul>" >> "$idx"
for file in *.pdf; do
  echo "<li><a href=\"$file\">$file</a></li>" >> "$idx"
done
echo "</ul>" >> "$idx"
echo "<h3>as SVG vector images</h3>" >> "$idx"
echo "<ul>" >> "$idx"
for file in *.svg; do
  echo "<li><a href=\"$file\">$file - <img src=\"$file\" alt=\"$file\" width=\"320\"/></a></li>" >> "$idx"
done
echo "</ul>" >> "$idx"
echo "</body>" >> "$idx"
echo "</html>" >> "$idx"

echo
echo "done."
