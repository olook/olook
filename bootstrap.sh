#!/bin/bash
if [[ $1 == 'development' ]]; then
  echo "Copying gsg keys for deploy and servers access"
  mkdir -p ~/.ec2
  cp ./config/dev/gsg-keypair* ~/.ec2/
  chmod 0600 ~/.ec2/gsg-keypair*
fi

for f in config/*.yml.example; do
  dest="config/$(echo $f | sed 's/.*\/\(.*\).example/\1/')"
  if [[ ! -e $dest ]]; then
    cat $f > $dest
    echo "$f -> $dest"
  fi
done
