#
# MySQL MRBS table creation script
#
# $Id: tables.my.pre41.sql 2803 2014-01-17 14:25:01Z cimorrison $
#
# Notes:
# (1) If you have decided to change the prefix of your tables from 'mrbs_'
#     to something else using $db_tbl_prefix then you must edit each
#     'CREATE TABLE' and 'INSERT INTO' line below to replace 'mrbs_' with
#     your new table prefix.
#
# (2) If you change the varchar lengths here, then you should check
#     to see whether a corresponding length has been defined in the config file
#     in the array $maxlength.
#
# (3) If you add new fields then you should also change the global variable
#     $standard_fields.   Note that if you are just adding custom fields for
#     a single site then this is not necessary.

CREATE TABLE mrbs_area
(
  id                        int NOT NULL auto_increment,
  disabled                  tinyint(1) DEFAULT 0 NOT NULL,
  area_name                 varchar(30),
  timezone                  varchar(50),
  area_admin_email          text,
  resolution                int,
  default_duration          int,
  default_duration_all_day  tinyint(1) DEFAULT 0 NOT NULL,
  morningstarts             int,
  morningstarts_minutes     int,
  eveningends               int,
  eveningends_minutes       int,
  private_enabled           tinyint(1),
  private_default           tinyint(1),
  private_mandatory         tinyint(1),
  private_override          varchar(32),
  min_book_ahead_enabled    tinyint(1),
  min_book_ahead_secs       int,
  max_book_ahead_enabled    tinyint(1),
  max_book_ahead_secs       int,
  max_per_day_enabled       tinyint(1) DEFAULT 0 NOT NULL,
  max_per_day               int DEFAULT 0 NOT NULL,
  max_per_week_enabled      tinyint(1) DEFAULT 0 NOT NULL,
  max_per_week              int DEFAULT 0 NOT NULL,
  max_per_month_enabled     tinyint(1) DEFAULT 0 NOT NULL,
  max_per_month             int DEFAULT 0 NOT NULL,
  max_per_year_enabled      tinyint(1) DEFAULT 0 NOT NULL,
  max_per_year              int DEFAULT 0 NOT NULL,
  max_per_future_enabled    tinyint(1) DEFAULT 0 NOT NULL,
  max_per_future            int DEFAULT 0 NOT NULL,
  custom_html               text,
  approval_enabled          tinyint(1),
  reminders_enabled         tinyint(1),
  enable_periods            tinyint(1),
  confirmation_enabled      tinyint(1),
  confirmed_default         tinyint(1),

  PRIMARY KEY (id)
);

CREATE TABLE mrbs_room
(
  id               int NOT NULL auto_increment,
  disabled         tinyint(1) DEFAULT 0 NOT NULL,
  area_id          int DEFAULT '0' NOT NULL,
  room_name        varchar(25) DEFAULT '' NOT NULL,
  sort_key         varchar(25) DEFAULT '' NOT NULL,
  description      varchar(60),
  capacity         int DEFAULT '0' NOT NULL,
  room_admin_email text,
  custom_html      text,

  PRIMARY KEY (id),
  KEY idxSortKey (sort_key)
);

CREATE TABLE mrbs_entry
(
  id             int NOT NULL auto_increment,
  start_time     int DEFAULT '0' NOT NULL,
  end_time       int DEFAULT '0' NOT NULL,
  entry_type     int DEFAULT '0' NOT NULL,
  repeat_id      int DEFAULT '0' NOT NULL,
  room_id        int DEFAULT '1' NOT NULL,
  timestamp      timestamp,
  create_by      varchar(80) DEFAULT '' NOT NULL,
  modified_by    varchar(80) DEFAULT '' NOT NULL,
  name           varchar(80) DEFAULT '' NOT NULL,
  type           char DEFAULT 'E' NOT NULL,
  description    text,
  status         tinyint unsigned NOT NULL DEFAULT 0,
  reminded       int,
  info_time      int,
  info_user      varchar(80),
  info_text      text,
  ical_uid       varchar(255) DEFAULT '' NOT NULL,
  ical_sequence  smallint DEFAULT 0 NOT NULL,
  ical_recur_id  varchar(16) DEFAULT '' NOT NULL,

  PRIMARY KEY (id),
  KEY idxStartTime (start_time),
  KEY idxEndTime   (end_time)
);

CREATE TABLE mrbs_repeat
(
  id             int NOT NULL auto_increment,
  start_time     int DEFAULT '0' NOT NULL,
  end_time       int DEFAULT '0' NOT NULL,
  rep_type       int DEFAULT '0' NOT NULL,
  end_date       int DEFAULT '0' NOT NULL,
  rep_opt        varchar(32) DEFAULT '' NOT NULL,
  room_id        int DEFAULT '1' NOT NULL,
  timestamp      timestamp,
  create_by      varchar(80) DEFAULT '' NOT NULL,
  modified_by    varchar(80) DEFAULT '' NOT NULL,
  name           varchar(80) DEFAULT '' NOT NULL,
  type           char DEFAULT 'E' NOT NULL,
  description    text,
  rep_num_weeks  smallint NULL,
  month_absolute smallint DEFAULT NULL,
  month_relative varchar(4) DEFAULT NULL,
  status         tinyint unsigned NOT NULL DEFAULT 0,
  reminded       int,
  info_time      int,
  info_user      varchar(80),
  info_text      text,
  ical_uid       varchar(255) DEFAULT '' NOT NULL,
  ical_sequence  smallint DEFAULT 0 NOT NULL,
  
  PRIMARY KEY (id)
);

CREATE TABLE mrbs_variables
(
  id               int NOT NULL auto_increment,
  variable_name    varchar(80),
  variable_content text,
      
  PRIMARY KEY (id)
);

CREATE TABLE mrbs_zoneinfo
(
  id                 int NOT NULL auto_increment,
  timezone           varchar(255) DEFAULT '' NOT NULL,
  outlook_compatible tinyint unsigned NOT NULL DEFAULT 0,
  vtimezone          text,
  last_updated       int NOT NULL DEFAULT 0,
      
  PRIMARY KEY (id)
);

CREATE TABLE mrbs_users
(
  /* The first four fields are required. Don't remove. */
  id        int NOT NULL auto_increment,
  level     smallint DEFAULT '0' NOT NULL,  /* play safe and give no rights */
  name      varchar(30),
  password  varchar(40),
  email     varchar(75),

  PRIMARY KEY (id)
);

INSERT INTO mrbs_variables (variable_name, variable_content)
  VALUES ( 'db_version', '36');
INSERT INTO mrbs_variables (variable_name, variable_content)
  VALUES ( 'local_db_version', '1');
