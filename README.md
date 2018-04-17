# DiscoverDB2
Scripts, SQL, and files used for the DISCOVER.DB2 YouTube channel.

### Disclaimer:
I am not an advanced scripter or SQL writer. No warranty implied, use these at your own risk.

### Purpose:
The following Scripts, SQL, or files were used in an episode of Discover.DB2 (Youtube). If you watched an episoide and want to get your hands on something I used, this is the place to get it.

### Notes:
Make sure to read comments and headers of each script. In each case, you will probably have to swap out a few placeholders (@VALUE@) for a specific value you would like set.

### Available SQL and Scripts:

*CREATE_EXPLAIN.ksh (Episode 5)*

This script will call a procedure to create tables needed for the EXPLAIN or db2advis utilities.


*CRONTAB_TEMPLATE (Episode 3)*

A basic template to create a crontab entry for your DB2 instance. Includes a header, example entries, and syntax examples.


*DB2SET.ksh (Episode 4)*

This script will adjust DB2 profile variables to some specific settings I use when creating a new database instance from scratch.


*DISABLE_HEALTH_MONITOR.ksh (Episode 5)*

This script will completely deactivate the (depricated) DB2 Health Monitor. Pay attention to comments in the script and follow the URL within the script to an IBM Technote.


*PARSE_DIAG.ksh (Episode 11)*

A quick script that takes a database name and pulls 24 hours of DB2DIAG.log details via PD_GET_DIAG_HIST.


*PROFILE_TEMPLATE (Episode 3)*

A basic template to create a user profile (.profile) for your instance ID. Includes items like command line recall, prompt formatting, and splashscreens.


*REVOKE_PUBLIC.ksh (Episode 5)*

This script will revoke some implicit access PUBLIC is granted upon initial DB creation. CAUTION: If your database is established already (with users, application connections, etc) be careful and test the affects in a lower level environment first.


*UPDATE_DBM_PREF.ksh (Episode 4)*

This script will makes adjustments to the DB2 Database Manager (DBM) Configuration Settings (Instance Level). These are settings I use when creating a database from scratch.


*UPDATE_DBM_PREF.ksh (Episode 5)*

This script will makes adjustments to the Database Configuration settings (Database Level). These are settings I use when creating a database from scratch.


