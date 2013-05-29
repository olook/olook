#!/bin/bash
if [[ $1 == 'development' ]]; then
  echo "Copying gsg keys for deploy and servers access"
  mkdir -p ~/.ec2
  cp ./config/deploy/gsg-keypair* ~/.ec2/
  chmod 0600 ~/.ec2/gsg-keypair*
fi

for f in config/deploy/*.yml.erb; do
  dest="config/$(echo $f | sed 's/.*\/\(.*\).erb/\1/')"
  if [[ ! -e $dest ]]; then
    cat $f | sed  's/<%= "#{Rubber.env}" %>/development/g' | sed 's/<%= "#{application}_\([^"]*\)" %>/olook_\1/' | sed 's/<%.*%>//' > $dest
    echo "$f -> $dest"
  fi
done
