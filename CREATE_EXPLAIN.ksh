#!/bin/ksh
## CREATE_EXPLAIN.ksh | December 12, 2017 | Version 1 | Script: M. Krafick | No Warranty implied, use at your won risk.
##
## Purpose: This script will create the tables needed for the Explain tool.
##
## Execution Notes:
## Run as Instance ID (usually db2inst1)
## Make sure to swap out @VALUE@ where appropriate. (DB Name, etc)
##
## Usage: ./EXPLAIN_CREATE.ksh

## Failsafe
clear
echo "STOP!"
echo ""
echo "Unlike my other scripts, there is probably no reason to PANIC and TYPE IN CAPS. But I'm going to anyway."
echo "Nothing will be rebooted or shut off. This should be harmless. I think."
echo ""
echo "This is one of those easy ones where you should probably put on your big-boy DBA pants and learn to run via command line."
echo "It's only one command."
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
echo "Connecting to database and creating explain tables ..."
db2 CONNECT TO @DBNAME@ > /dev/null
db2 -v "call sysproc.sysinstallobjects('EXPLAIN','C',NULL,NULL)"
db2 TERMINATE > /dev/null

echo ""
echo ""
echo ""
echo "Script Complete."