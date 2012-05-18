#!/bin/bash
#
# NAME
#
#   delete
#
# DESCRIPTION
#
#   delete a node
#

# Read module function library
source $RERUN_MODULES/yana/lib/functions.sh || exit 1 ;

# Parse the command options
[ -r $RERUN_MODULES/yana/commands/delete/options.sh ] && {
  source $RERUN_MODULES/yana/commands/delete/options.sh || exit 2 ;
}


# ------------------------------
flags="" #-v --silent --fail --show-error"

cookie=/tmp/yana-delete-cookiejar.txt
response=/tmp/yana-delete-response.txt


#
# Login and create a session
#
curl --fail --silent \
    --data "j_username=admin&j_password=admin" \
    ${URL}/springSecurityApp/j_spring_security_check \
    --cookie-jar ${cookie} || rerun_die "login failed for admin"

#
# Send the delete request 
#
curl  --fail --silent --request DELETE ${URL}/api/node/${ID} \
    --cookie-jar ${cookie}

# ------------------------------

exit $?

# Done
