#!/bin/ksh
## REVOKE_PUBLIC.ksh | December 12, 2017 | Version 1 | Script: M. Krafick | No Warranty implied, use at your won risk.
##
## Purpose: To revoke some of the implicit access PUBLIC has been granted during database creation.
##
## Execution Notes:
## Run as Instance ID (usually db2inst1)
## Make sure to swap out @VALUE@ where appropriate. (DB Name, etc)
##
## Usage: ./REVOKE_PUBLIC.ksh

## Failsafe
clear
echo "STOP!"
echo ""
echo "You are about to revoke some implicit access from PUBLIC."
echo "  If this is an already established database or a database used for a tool backend -- BE CAREFUL!"
echo "  You may be taking advantage of access PUBLIC has and don't realize it. Be diligent and TEST access of system IDs and tools once done."
echo ""
echo "If this is being done immediately after database creation, you should have no ill affects."
echo ""
echo "Do you wish to proceed? (Y/N)"
read  CONTINUE
case $CONTINUE in
    Y|y|"")
      echo ""
      echo "Proceeding ..."
      ;;
    N|n)
      echo "Aborting Script."
      exit 1
      ;;
esac

## Revoke some implicit access from PUBLIC.
## NOTE: This is in no way an exhaustive means to remove public access, but is a good first step.
echo ""
echo ""
echo ""
echo "Issuing REVOKE commands ..."
db2 CONNECT TO @DBNAME@ > /dev/null
db2 -v REVOKE BINDADD ON DATABASE FROM PUBLIC;
db2 -v REVOKE CREATETAB ON DATABASE FROM PUBLIC;
db2 -v REVOKE CONNECT ON DATABASE FROM PUBLIC;
db2 -v REVOKE IMPLICIT_SCHEMA ON DATABASE FROM PUBLIC;
db2 -v REVOKE USE OF TABLESPACE USERSPACE1 FROM PUBLIC;
db2 TERMINATE > /dev/null

echo ""
echo ""
echo ""
echo "Script Complete."