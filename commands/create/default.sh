#!/bin/bash
#
# NAME
#
#   create
#
# DESCRIPTION
#
#   create a new node
#

# Read module function library
source $RERUN_MODULES/yana/lib/functions.sh || exit 1 ;

# Parse the command options
[ -r $RERUN_MODULES/yana/commands/create/options.sh ] && {
  source $RERUN_MODULES/yana/commands/create/options.sh || exit 2 ;
}


# ------------------------------
flags="" #-v --silent --fail --show-error"

cookie=/tmp/yana-create-cookiejar.txt
response=/tmp/yana-create-response.txt


#
# Login and create a session
#
curl --fail --silent \
    --data "j_username=admin&j_password=admin" \
    ${URL}/springSecurityApp/j_spring_security_check \
    --cookie-jar ${cookie} || rerun_die "login failed for admin"

#
# Parse the data. Input file defines one attribute:value pair per line.
#

data=$(for line in $(cat $FILE)
do
attribute=${line%%:*}
value=${line##*:}
printf "%s:\"%s\"," $attribute $value
done)



#
# Post the data to Yana and create the node
#
curl --fail --silent --request POST --header "Content-Type: application/json" \
    -d { "${data}" } \
    ${URL}/api/node \
    --cookie ${cookie} || rerun_die "failed posting Yana data"


#
# Validate the response 
#

#
# Output the data
#



# ------------------------------

exit $?

# Done
