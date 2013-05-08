#!/bin/bash
echo "Copying gsg keys for deploy and servers access"
[[ ! -a ~/.ec2 ]] && mkdir ~/.ec2
cp ./config/deploy/gsg-keypair* ~/.ec2/
chmod 0600 ~/.ec2/gsg-keypair*

for f in config/deploy/*.yml.erb; do
  dest="config/$(echo $f | sed 's/.*\/\(.*\).erb/\1/')"
  cat $f | sed 's/<%= "#{application}_\([^"]*\)" %>/olook_\1/' | sed 's/<%.*%>//' > $dest
  echo "$f -> $dest"
done
