#!/bin/bash
# Sam Havron
# NOTE: to be used in conjunction with Makefile, 
# which handles year directories and calls this script
# at the proper time in deployment
for y in ./content/blog/*/ 
do
  if [ -d "${y}" ]; then
    # get the years by finding aptly-named directories 
    # in the blog's source markdown content
    year=`echo $y | grep -Eo '[^/]+/?$' | cut -d / -f1` 

    if [ ! -d "public/blog/$year/raw" ]; then
    mkdir -p public/blog/$year/raw # assumes public and $year are created already! Makefile does this.
    fi

    # take all Markdown blogs, strip the TOML frontmatter, and store them in raw/
    # then make a converted copy from .md to .txt with pandoc
    for v in content/blog/$year/*.md
    do 
      bn=`basename -s .md $v`
      sed '1,/+++/d' $v > public/blog/$year/raw/$bn.md
      pandoc -t markdown -o public/blog/$year/raw/$bn.md public/blog/$year/raw/$bn.md
      pandoc --reference-links -t plain -o public/blog/$year/raw/$bn.txt public/blog/$year/raw/$bn.md
    done
  fi
done
