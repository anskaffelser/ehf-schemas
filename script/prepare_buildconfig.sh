#!/bin/sh

set -e
set -u

identifier="ehf-schemas"

echo "<?xml version=\"1.0\" encoding=\"UTF-8\"?>"
echo "<buildConfigurations xmlns=\"http://difi.no/xsd/vefa/validator/1.0\">"
echo "\t<configuration>"
echo "\t\t<identifier>${identifier}</identifier>"
echo "\t\t<title>EHF Schemas</title>"
echo "\t\t<file type=\"xml.xsd\" path=\"xsd/_includes.xsd\"/>"
echo "\t</configuration>"

echo

if [ -e aliases ]; then
  for alias in $(cat aliases); do
    echo "\t<configuration>"
    echo "\t\t<identifier>${alias}</identifier>"
    echo "\t\t<inherit>${identifier}</inherit>"
    echo "\t</configuration>"
  done
fi

echo

for path in $(find xsd -type f -name '*.xsd' | sort); do
  echo "\t<include path=\"$path\"/>"
done

echo "</buildConfigurations>"
