#!/bin/sh
cwd=$(pwd)
file_dpi=$1
work_dir=$2
width=$3
filename=$4
base_exec="$cwd/bin/"

if [ "$(uname)" = "Darwin" ]; then
  base_exec=""
fi

echo $(pwd)

cd "$work_dir"

echo $(pwd)

if [ "1400" != "$width" ]; then
  ${base_exec}pdftoppm -jpeg -r $file_dpi -scale-to-x $width -scale-to-y -1 index.pdf "jpeg-$width-page"
fi

${base_exec}pdftoppm -jpeg -r $file_dpi -scale-to-x 1400 -scale-to-y -1 index.pdf jpeg-1400-page
${base_exec}pdftohtml -p -xml -hidden index.pdf
${base_exec}pdftoppm -r $file_dpi index.pdf ppm-page

if [ -f "jpeg-1400-page-01.jpg " ]; then
  cp -f jpeg-1400-page-01.jpg index.jpg || true
else
  cp -f jpeg-1400-page-1.jpg index.jpg || true
fi

cp -f index.jpg "$filename"

# finally, rename index pdf to prevent infinit loop of bucket reprocessing
mv -f index.pdf index.pdx
