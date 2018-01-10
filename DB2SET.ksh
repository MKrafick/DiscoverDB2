#!/bin/ksh
## DB2SET.ksh | December 12, 2017 | Version 1 | Script: M. Krafick | No Warranty implied, use at your won risk.
##
## Purpose: To Make adjustment to DB2 profile variables.
##
## Execution Notes:
## Run as Instance ID (usually db2inst1)
##
## Usage: ./DBSET.ksh


clear

echo "Current DB2 profile settings:"
db2set -all

echo ""
echo "STOP!"
echo ""
echo "You are about to make changes to DB2 profile variables. These can affect functionality and performance."
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

echo ""
echo ""
echo ""
echo "Adjusting DB2 Profile Variables ..."

echo ""
echo "Updating DB2_PARALLEL_IO (How DB2 Handles I/O Parallelism)"
db2set DB2_PARALLEL_IO=*

echo ""
echo "Updating DB2_RESTORE_GRANT_ADMIN_AUTHORITIES (Helps with authorities when restoring DB in alternate location)."
db2set DB2_RESTORE_GRANT_ADMIN_AUTHORITIES=ON

echo ""
echo ""
echo ""
echo "Script Complete."
echo "Current DB2 profile settings:"
db2set -all