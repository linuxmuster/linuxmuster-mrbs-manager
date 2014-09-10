# $Id: mysql.sql 2489 2012-10-12 12:26:01Z cimorrison $

# Restore the original timestamp at the beginning of the previous upgrade

# We save the current value of the timestamp before updating and restore it 
# afterwards because we do not want the timestamp to be changed by this operation

UPDATE %DB_TBL_PREFIX%repeat SET timestamp=saved_ts;
ALTER TABLE %DB_TBL_PREFIX%repeat
DROP COLUMN saved_ts;
