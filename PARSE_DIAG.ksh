#!/bin/ksh
## PARSE_DIAG.ksh | Feb 15, 2018 | Version 1 | Script: M. Krafick | No Warranty implied, use at your won risk.
##
## Purpose: To dynamically query the DB2 error log via the PD_GET_DIAG_HIST function. This provides the past 24 hours of data.
##
## Execution Notes:
## Run as Instance ID (usually db2inst1)
##
## Usage: ./PARSE_DIAG.ksh DBNAME

## Variable Assignments
DBNAME=$1
LAST24=`date -d yesterday '+%Y%m%d%H%M%S'`

## CONNECT TO DATABASE
db2 "CONNECT TO $DBNAME" > /dev/null

## Execute PD_GET_DIAG_HIST function for errors
## Knowledge Center Article - https://tinyurl.com/ycrcbvag
## Original SQL:
##   SELECT TIMESTAMP, LEVEL, IMPACT, substr(DBNAME,1,10) as DBNAME, substr(APPL_ID,1,25) as APPL_ID, substr(AUTH_ID,1,20) as AUTH_ID, substr(MSG,1,50) as MESSAGE
##   FROM TABLE (PD_GET_DIAG_HIST( 'MAIN', 'ALL', '', NULL, NULL ) ) AS T

db2 "SELECT TIMESTAMP,
LEVEL, IMPACT,
substr(DBNAME,1,10) as DBNAME,
substr(APPL_ID,1,25) as APPL_ID,
substr(AUTH_ID,1,20) as AUTH_ID,
substr(MSG,1,50) as MESSAGE
FROM TABLE (PD_GET_DIAG_HIST( 'MAIN', 'ALL', '', '$LAST24', NULL ) ) AS T"

## Disconnect from database
db2 "TERMINATE" > /dev/null