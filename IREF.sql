-- IREF.sql | June 14, 2018 | Version 1 | Script: M. Krafick | No Warranty implied, use at your won risk.
--
-- Purpose: Determine Avg Result Set at database lavel, Index Read efficiency at database level,
--          and Index Read Efficiency at the statement level.
--
-- Execution Notes:
-- Run as Instance ID (usually db2inst1) or ID with proper SELECT and EXECUTE authorities.
--
-- Usage: db2 -tf IREF.sql

-- Avg Result Set Size (ARSS)
-- ARSS is not index read efficiency, that is further in this SQL file. This tells you the avg rows retured
-- at a database level. This helps you determine what type of workload you typically run in this environment.

SELECT ROWS_RETURNED/SELECT_SQL_STMTS AS DB_AVG_RESULT_SIZE,
CASE
  WHEN (ROWS_RETURNED/SELECT_SQL_STMTS) <=10 THEN 'OLTP'
  WHEN ((ROWS_RETURNED/SELECT_SQL_STMTS) >10 AND (ROWS_RETURNED/SELECT_SQL_STMTS) <=15) THEN 'MIXED WORKLOAD'
  ELSE 'WAREHOUSE'
END AS WORKLOAD_TYPE
FROM TABLE(MON_GET_DATABASE(-2)) WITH UR;


-- When interpreting Index Read Efficiency (IREF) keep workload (above) in context. If you are truly OLTP then
-- the results below should be looked at in a unforgiving manner. If your workload is mixed, being outside the
-- norm may be acceptable in some cases. If in DW you can look at the results liberally.


-- DB Level Index Read Efficiency
-- Used with permission from DataGeek.Blog (https://tinyurl.com/ya2w9q5v)
SELECT ROWS_READ as TOTAL_ROWS_READ, ROWS_RETURNED AS TOTAL_ROWS_RETURNED, ROWS_READ/ROWS_RETURNED as DB_INDEX_READ_EFFICIENCY
FROM TABLE(MON_GET_WORKLOAD(NULL,-2)) AS T where WORKLOAD_NAME='SYSDEFAULTUSERWORKLOAD' WITH UR;


-- Statement Level Index Read Efficiency
-- Adjust SUBSTR of STMT_TEXT to see more of the SQL, uncomment and comment the ORDER BY clause to show
-- results from different perspectives.

SELECT SUBSTR(STMT_TEXT,1,20) AS SQL, NUM_EXECUTIONS as NUM_EXECUTIONS, STMT_EXEC_TIME as TOTAL_TIME_EXEC, ROWS_READ, ROWS_RETURNED,
CASE
  WHEN ROWS_RETURNED > 0 THEN
    DECIMAL(FLOAT(ROWS_READ)/FLOAT(ROWS_RETURNED),10,2)
    ELSE -1
END AS STMT_INDEX_READ_EFFICIENCY,
CASE
  WHEN ROWS_RETURNED <= 0 THEN 'N/A'
  WHEN (DECIMAL(FLOAT(ROWS_READ)/FLOAT(ROWS_RETURNED),10,2) >= 1) and (DECIMAL(FLOAT(ROWS_READ)/FLOAT(ROWS_RETURNED),10,2) <= 10) THEN 'PASS'
  WHEN (DECIMAL(FLOAT(ROWS_READ)/FLOAT(ROWS_RETURNED),10,2) > 10) and (DECIMAL(FLOAT(ROWS_READ)/FLOAT(ROWS_RETURNED),10,2) <= 100) THEN 'POSSIBLE'
  WHEN (DECIMAL(FLOAT(ROWS_READ)/FLOAT(ROWS_RETURNED),10,2) > 100) and (DECIMAL(FLOAT(ROWS_READ)/FLOAT(ROWS_RETURNED),10,2) <= 1000) THEN 'POOR'
  WHEN DECIMAL(FLOAT(ROWS_READ)/FLOAT(ROWS_RETURNED),10,2) > 1000 THEN 'SEVERE'
END AS SEVERITY
FROM TABLE(MON_GET_PKG_CACHE_STMT( NULL, NULL, NULL, -2))
ORDER BY ROWS_READ DESC
-- ORDER BY NUM_EXECUTIONS DESC
-- ORDER BY STMT_EXEC_TIME DESC
FETCH FIRST 10 ROWS ONLY WITH UR;