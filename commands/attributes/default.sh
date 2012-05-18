#!/bin/bash
#
# NAME
#
#   attributes
#
# DESCRIPTION
#
#   get attributes
#

# Read module function library
source $RERUN_MODULES/yana/lib/functions.sh || exit 1 ;

# Parse the command options
[ -r $RERUN_MODULES/yana/commands/attributes/options.sh ] && {
  source $RERUN_MODULES/yana/commands/attributes/options.sh || exit 2 ;
}


# ------------------------------
flags="" #-v --silent --fail --show-error"

cookie=/tmp/yana-attributes-cookiejar.txt
response=/tmp/yana-attributes-response.txt


#
# Login and create a session
#
curl --fail --silent \
    --data "j_username=admin&j_password=admin" \
    ${URL}/springSecurityApp/j_spring_security_check \
    --cookie-jar ${cookie} || rerun_die "login failed for admin"
#
# Retrieve the data from Yana
#
curl --fail --silent ${URL}/node/show/${ID}?format=xml \
    --cookie ${cookie} -o ${response} || rerun_die "failed obtaining Yana data"


#
# Validate the response is well formed XML
#
xmlstarlet val --well-formed --quiet ${response} 2>/dev/null || die "Yana response failed XML validation"
#
# Output the data
#
NAME=$(xmlstarlet sel -t -m /nodes/node -v @name $response)
TYPE=$(xmlstarlet sel -t -m /nodes/node -v @type $response)
DESC=$(xmlstarlet sel -t -m /nodes/node -v description $response)
echo "name:$NAME"
echo "type:$TYPE"
printf "description:$DESC"

xmlstarlet sel -t -m /nodes/node/attributes/attribute -v @name -o ":" -v @value -n $response|sort


# ------------------------------

exit $?

# Done
