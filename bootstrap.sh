#!/bin/bash
for filename in config/*.sample 
do
  echo -n "$filename => ";
  file_without_ext=`basename $filename .sample`;
  cp -vn $filename config/$file_without_ext;
  echo ""
done
