#!/bin/ksh
## UPDATE_DBM_PREF.ksh | December 12, 2017 | Version 1 | Script: M. Krafick | No Warranty implied, use at your won risk.
##
## Purpose: To Make adjustment to the DB2 Database Manager (DBM) Configuration Settings (Instance Level).
##
## Execution Notes:
## Run as Instance ID (usually db2inst1)
## Make sure to swap out @VALUE@ where appropriate. (SYSMON_GROUP; DB2DIAG Directory, DB2 Instance ID)
##
## Usage: ./UPDATE_DBM_PREF.ksh

## Failsafe
clear
echo "STOP!"
echo ""
echo "You are about to make changes to the DB2 Database Manager (DBM) Configuration Settings. These changes can affect functionality and performance."
echo "This script WILL FORCE OFF ALL CONNECTION AND RESTART DB2 for changes to take affect."
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


### Adjust Database Manager Configuration ###
echo ""
echo ""
echo "Adjusting Database Manager (DBM) Configuration Settings (Instance Level)"

echo ""
echo ""
echo "Adjusting commonly used default database monitor switches ..."
db2 -v "UPDATE DBM CFG USING DFT_MON_BUFPOOL ON IMMEDIATE"
db2 -v "UPDATE DBM CFG USING DFT_MON_LOCK ON IMMEDIATE"
db2 -v "UPDATE DBM CFG USING DFT_MON_SORT ON IMMEDIATE"
db2 -v "UPDATE DBM CFG USING DFT_MON_STMT ON IMMEDIATE"
db2 -v "UPDATE DBM CFG USING DFT_MON_TABLE ON IMMEDIATE"
db2 -v "UPDATE DBM CFG USING DFT_MON_TIMESTAMP ON IMMEDIATE"
db2 -v "UPDATE DBM CFG USING DFT_MON_UOW ON IMMEDIATE"
db2 -v "UPDATE DBM CFG USING HEALTH_MON OFF IMMEDIATE"

echo ""
echo ""
echo ""
echo ""
echo "Adding SYSMON_GROUP often used for monitoring ..."
db2 -v "UPDATE DBM CFG USING SYSMON_GROUP @SYSMONGROUP@ IMMEDIATE"

echo ""
echo ""
echo ""
echo ""
echo "Redirecting DB2 Error Log to isolated directory ... "
db2 -v "UPDATE DBM CFG USING DIAGPATH @ERRORLOGPATH@ IMMEDIATE"

echo ""
echo ""
echo ""
echo ""
echo "Shutting off automatic instance start after system bounce ..."
db2iauto -off db2inst1

echo ""
echo ""
echo ""
echo ""
echo "Recycling DB2 Environment to allow changes to take affect ..."
echo "Stop DB2 (db2stop) | Clean Memory (ipclean) | Start DB2 (db2start)"
db2stop force > /dev/null 2>&1
ipclean > /dev/null 2>&1
db2start > /dev/null 2>&1

echo ""
echo ""
echo ""
echo "Script is complete."
echo "To confirm changes are in place and current, issue:"
echo "   db2 ATTACH TO <INSTANCEID>"
echo "   db2 GET DBM CFG SHOW DETAIL"
echo "   db2 DETACH"
echo ""