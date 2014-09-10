-- $Id: pgsql.sql 2489 2012-10-12 12:26:01Z cimorrison $

-- Add a month_absolute column so that monthly repeats can be converted to the
-- new format.   The conversion itself is done in post.inc

ALTER TABLE %DB_TBL_PREFIX%repeat
ADD COLUMN month_absolute smallint DEFAULT NULL;
