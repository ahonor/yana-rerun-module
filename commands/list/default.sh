#!/bin/bash
#
# NAME
#
#   list
#
# DESCRIPTION
#
#   list nodes
#

# Read module function library
source $RERUN_MODULES/yana/lib/functions.sh || exit 1 ;

# Parse the command options
[ -r $RERUN_MODULES/yana/commands/list/options.sh ] && {
  source $RERUN_MODULES/yana/commands/list/options.sh || exit 2 ;
}


# ------------------------------
flags="" #-v --silent --fail --show-error"

cookie=/tmp/yana-list-cookiejar.txt
response=/tmp/yana-list-response.txt


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
curl --fail --silent ${URL}/node/list?format=xml \
    --cookie ${cookie} -o ${response} || rerun_die "failed obtaining Yana data"


#
# Validate the response is well formed XML
#
xmlstarlet val --well-formed --quiet ${response} 2>/dev/null || die "Yana response failed XML validation"

#
# Output the data
#
if [ -n "$TYPE" ]
then
xmlstarlet sel -t -m /nodes/node[@type=\'"${TYPE}"\'] -v @type -o ":" -v @name -o ":" -v @id -n  $response
else
xmlstarlet sel -t -m /nodes/node -v @type -o ":" -v @name -o ":" -v @id  -n  $response
fi
# ------------------------------

exit $?

# Done
