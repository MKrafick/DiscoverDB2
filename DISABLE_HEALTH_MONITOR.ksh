#!/bin/ksh
## DISABLE_HEALTH_MONITOR.ksh | December 12, 2017 | Version 1 | Script: M. Krafick | No Warranty implied, use at your won risk.
##
## Purpose: To disable DB2 Health Monitor (db2hmon)
##
## Execution Notes:
## Make sure to review IBM's Original Technote: http://www-01.ibm.com/support/docview.wss?uid=swg21646336
##   If you plan on using automatic maintenance, you need to avoid running commands around (AUTO_RUNSTATS,AUTO_REORG,AUTO_BACKUP,AUTO_MAINT,AUTO_TBL_MAINT)
##
## Run as Instance ID (usually db2inst1)
## Make sure to swap out @VALUE@ where appropriate. (DB Name, etc)
##
## Usage: ./DISABLE_HEALTH_MONITOR.ksh

## Failsafe
clear
echo "STOP!"
echo ""
echo "You are about to disable DB2 Health Monitor. This will stop DB2 from collecting health indicators."
echo "IF YOU ARE RUNNING AUTOMATIC MAINTENANCE - STOP AND READ NOTES WITHIN SCRIPT HEADER."
echo ""
echo "This will FORCE OFF ALL CONNECTIONS and RESTART THE DB2 ENVIRONMENT."
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


## Disable Health Monitor from Instance Level.
echo ""
echo ""
echo ""
echo "Disabling Health Monitor at the instance level (DBM CFG) ..."
db2 -v UPDATE DBM CFG USING HEALTH_MON OFF IMMEDIATE

## The following six statements NEED TO BE COMMENTED OUT if you plan on using automatic maintenance.
## See technote in script header.
echo ""
echo ""
echo ""
echo "Disabling automatic maintenance at database level (DB CFG) ..."
db2 -v UPDATE DB CFG FOR @DBNAME@ USING AUTO_MAINT OFF
db2 -v UPDATE DB CFG FOR @DBNAME@ USING AUTO_TBL_MAINT OFF
db2 -v UPDATE DB CFG FOR @DBNAME@ USING AUTO_RUNSTATS OFF
db2 -v UPDATE DB CFG FOR @DBNAME@ USING AUTO_STATS_PROF OFF
db2 -v UPDATE DB CFG FOR @DBNAME@ USING AUTO_REORG OFF
db2 -v UPDATE DB CFG FOR @DBNAME@ USING AUTO_DB_BACKUP OFF

## Update specific alerts to NO
echo ""
echo ""
echo ""
echo ""
echo "Updating alert check threshold to 'NO' ..."
db2 -v CONNECT TO @DBNAME@ > /dev/null
db2 -v UPDATE ALERT CFG FOR DATABASES USING db.apps_waiting_locks SET THRESHOLDSCHECKED NO
db2 -v UPDATE ALERT CFG FOR DATABASES USING db.auto_storage_util SET THRESHOLDSCHECKED NO
db2 -v UPDATE ALERT CFG FOR DATABASES USING db.catcache_hitratio SET THRESHOLDSCHECKED NO
db2 -v UPDATE ALERT CFG FOR DATABASES USING db.db_backup_req SET THRESHOLDSCHECKED NO
db2 -v UPDATE ALERT CFG FOR DATABASES USING db.db_heap_util SET THRESHOLDSCHECKED NO
db2 -v UPDATE ALERT CFG FOR DATABASES USING db.db_op_status SET THRESHOLDSCHECKED NO
db2 -v UPDATE ALERT CFG FOR DATABASES USING db.deadlock_rate SET THRESHOLDSCHECKED NO
db2 -v UPDATE ALERT CFG FOR DATABASES USING db.fed_nicknames_op_status SET THRESHOLDSCHECKED NO
db2 -v UPDATE ALERT CFG FOR DATABASES USING db.fed_servers_op_status SET THRESHOLDSCHECKED NO
db2 -v UPDATE ALERT CFG FOR DATABASES USING db.hadr_delay SET THRESHOLDSCHECKED NO
db2 -v UPDATE ALERT CFG FOR DATABASES USING db.hadr_op_status SET THRESHOLDSCHECKED NO
db2 -v UPDATE ALERT CFG FOR DATABASES USING db.lock_escal_rate SET THRESHOLDSCHECKED NO
db2 -v UPDATE ALERT CFG FOR DATABASES USING db.locklist_util SET THRESHOLDSCHECKED NO
db2 -v UPDATE ALERT CFG FOR DATABASES USING db.log_fs_util SET THRESHOLDSCHECKED NO
db2 -v UPDATE ALERT CFG FOR DATABASES USING db.log_util SET THRESHOLDSCHECKED NO
db2 -v UPDATE ALERT CFG FOR DATABASES USING db.max_sort_shrmem_util SET THRESHOLDSCHECKED NO
db2 -v UPDATE ALERT CFG FOR DATABASES USING db.pkgcache_hitratio SET THRESHOLDSCHECKED NO
db2 -v UPDATE ALERT CFG FOR DATABASES USING db.shrworkspace_hitratio SET THRESHOLDSCHECKED NO
db2 -v UPDATE ALERT CFG FOR DATABASES USING db.sort_shrmem_util SET THRESHOLDSCHECKED NO
db2 -v UPDATE ALERT CFG FOR DATABASES USING db.spilled_sorts SET THRESHOLDSCHECKED NO
db2 -v UPDATE ALERT CFG FOR DATABASES USING db.tb_reorg_req SET THRESHOLDSCHECKED NO
db2 -v UPDATE ALERT CFG FOR DATABASES USING db.tb_runstats_req SET THRESHOLDSCHECKED NO
db2 -v TERMINATE > /dev/null

## Recycle DB and instance so changes take affect
echo ""
echo ""
echo ""
echo "Restarting database and DB2 instance to allow new configuration to take affect ..."
echo "Force Connections | Restart Instance | Restart Database"
db2 FORCE APPLICATIONS ALL > /dev/null
db2 DEACTIVATE DATABASE @DBNAME@ > /dev/null
db2stop force > /dev/null
db2start > /dev/null
db2 ACTIVATE DATABASE @DBNAME@ > /dev/null

echo ""
echo ""
echo ""
echo "Script Complete."