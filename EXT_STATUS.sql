-- EXT_STATUS.sql | July 17, 2018 | Version 1 | No Warranty implied, use at your own risk.
-- Original Author Ian Bjorhovde and written for datageek.blog
--      https://datageek.blog/2016/07/12/monitoring-extent-movement-progress/
--
-- Purpose: Monitor extent movement progress that is running in the background
--
-- Execution Notes:
-- Run as Instance ID (usually db2inst1) or ID with proper SELECT and EXECUTE authorities.
--
-- Usage: db2 -tf EXT_STATUS.sql


SELECT
 char(TBSP_NAME,30) TBSP_NAME,
 decimal(NUM_EXTENTS_MOVED*100.0/(NUM_EXTENTS_MOVED+NUM_EXTENTS_LEFT),5,2) as percent_complete,
 decimal(TOTAL_MOVE_TIME*1.0/NUM_EXTENTS_MOVED,6,1) as ms_per_extent,
 CURRENT TIMESTAMP + ((TOTAL_MOVE_TIME*1.0/NUM_EXTENTS_MOVED/1000)*NUM_EXTENTS_LEFT) seconds as est_completion_ts
FROM
 TABLE(SYSPROC.MON_GET_EXTENT_MOVEMENT_STATUS('', -1))
WHERE
 NUM_EXTENTS_LEFT <> -1;    