#!/bin/sh

echo '<?xml version="1.0" encoding="UTF-8"?>'
echo '<buildConfigurations xmlns="http://difi.no/xsd/vefa/validator/1.0">'
echo '\t<configuration>'
echo '\t\t<identifier>no.anskaffelser.ehf.schemas::all</identifier>'
echo '\t\t<title>EHF Schemas</title>'
echo '\t\t<file type="xml.xsd" path="xsd/_includes.xsd"/>'
echo '\t</configuration>'

echo

for p in $(find xsd -type f -name '*.xsd' | sort); do
  echo -n '\t<include path="'
  echo -n $p
  echo '" />'
done

echo '</buildConfigurations>'
