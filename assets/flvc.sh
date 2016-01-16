#!/bin/bash

# Adds FLVC namespace and extension to target record
# $1 is target record w/ full path 
# $2 is batch ID

xmlstarlet ed -L -i //_:mods -t attr -n xmlns:flvc -v info:flvc/manifest/v1 $1
if [[ ! -n $( xmlstarlet el $1 | grep "extension" ) ]]; then
  xmlstarlet ed -L -s //_:mods -t elem -n extension $1
fi
xmlstarlet ed -L -s //_:extension -t elem -n flvc:flvc $1
xmlstarlet ed -L -s //flvc:flvc -t elem -n flvc:owningInstitution -v FSU $1
xmlstarlet ed -L -s //flvc:flvc -t elem -n flvc:submittingInstitution -v FSU $1

# Add IID identifier
DID=`basename ${1} | sed "s/.xml//"`
xmlstarlet ed -L -s //_:mods -t elem -n identifier -v FSU_${2}_${DID} $1
perl -pi -e 's/<identifier>/<identifier type="IID">/g' $1
