#!/bin/ksh
## UPDATE_DB_PREF.ksh | December 12, 2017 | Version 1 | Script: M. Krafick | No Warranty implied, use at your won risk.
##
## Purpose: To Make adjustment to the DB2 Database (DB) Configuration Settings (Database Level).
##
## Execution Notes:
## Run as Instance ID (usually db2inst1)
## Make sure to swap out @VALUE@ where appropriate. (Database Name, Package Cache, LOG Paths, Log Quantity and Size, Log Archive Directory)
##
## Usage: ./UPDATE_DB_PREF.ksh

## Failsafe
clear
echo "STOP!"
echo ""
echo "You are about to make changes to the DB2 Database Manager (DB) Configuration Settings. These changes can affect functionality and performance."
echo "This script WILL FORCE OFF ALL CONNECTIONS, BRING DOWN YOUR DATABASE, AND TAKE A TEMPORARY BACKUP for changes to take affect."
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
echo "Adjusting Database (DB) Configuration Settings (Database Level)"

## SHUT OFF DATABASE AUTO START
echo ""
echo ""
echo ""
echo ""
echo "Disabling Database Auto-Start ..."
db2 -v UPDATE DB CFG FOR @DBNAME@ USING AUTORESTART OFF

## REMOVE AUTONOMIC SETTING, INCREASE PACKAGECACHE (Dynamic SQL cache internal to DB2)
## Possible starting point: 8192
echo ""
echo ""
echo ""
echo ""
echo "Hard Set DB2 Package Cache (from Automatic) ..."
db2 -v UPDATE DB CFG FOR @DBNAME@ USING PCKCACHESZ @PKGSIZE@

## TURN OFF AUTOMATIC MAINTENANCE
echo ""
echo ""
echo ""
echo ""
echo "Disabling Automatic Maintenance ..."
db2 -v UPDATE DB CFG FOR @DBNAME@ USING AUTO_MAINT OFF
db2 -v UPDATE DB CFG FOR @DBNAME@ USING AUTO_DB_BACKUP OFF
db2 -v UPDATE DB CFG FOR @DBNAME@ USING AUTO_TBL_MAINT OFF
db2 -v UPDATE DB CFG FOR @DBNAME@ USING AUTO_RUNSTATS OFF
db2 -v UPDATE DB CFG FOR @DBNAME@ USING AUTO_STMT_STATS OFF
db2 -v UPDATE DB CFG FOR @DBNAME@ USING AUTO_STATS_VIEWS OFF
db2 -v UPDATE DB CFG FOR @DBNAME@ USING AUTO_SAMPLING OFF
db2 -v UPDATE DB CFG FOR @DBNAME@ USING AUTO_REORG OFF

## LOGGING: Active Log Path, Log Size, Log Quantity
## Posssible LOGFILSZ 8192; LOGPRIMARY 15; LOGSECOND 20
echo ""
echo ""
echo ""
echo ""
echo "Adusting Active Log Location, Size, and Quanity ..."
db2 -v UPDATE DB CFG FOR @DBNAME@ USING NEWLOGPATH @LOGDIRECTORY@
db2 -v UPDATE DB CFG FOR @DBNAME@ USING LOGFILSIZ @LOGFILESIZE@
db2 -v UPDATE DB CFG FOR @DBNAME@ USING LOGPRIMARY @NOPRIMLOG@
db2 -v UPDATE DB CFG FOR @DBNAME@ USING LOGSECOND @NUMSECLOG@

## LOGGING: Turn on Archive Logging, Compress Logs
##          Allows Point In Time Recovery
##          Comment this section out if you DO NOT want point in time recoverability
##            If you do comment out this section issue a DEACTIVATE/ACTIVATE to make sure changed take affect
echo ""
echo ""
echo ""
echo ""
echo "Turning on Log Archiving (Allows Point In Time Recovery) ..."
db2 -v UPDATE DB CFG FOR @DBNAME@ USING LOGARCHMETH1 DISK:@ARCHLOGDIR@
db2 -v UPDATE DB CFG FOR @DBNAME@ USING LOGARCHCOMPR1 ON

echo ""
echo ""
echo "Activating Point in Time (LOGARCHIVE) requires a database backup."
echo "Stopping database | Backing up database | Starting database"
echo ""
db2 FORCE APPLICATIONS ALL > /dev/null 2>&1
db2 DEACTIVATE DATABASE @DBNAME@ > /dev/null 2>&1
echo "Backing up Database to /dev/null (bitbucket). Required when Log Archive is activated ..."
db2 -v BACKUP DATABASE @DBNAME@ TO /dev/null
db2 ACTIVATE DATABASE @DBNAME@ > /dev/null 2>&1


echo ""
echo ""
echo "Script is complete."
echo "If the database was not restarted during the Log Archive Configuration, you will need to recycle the database."
echo "To confirm changes are in place and current, issue:"
echo "   db2 CONNECT TO <DBNAME>"
echo "   db2 GET DB CFG SHOW DETAIL"
echo "   db2 TERMINATE"
echo ""