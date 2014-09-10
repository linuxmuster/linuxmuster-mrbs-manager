-- $Id: tables.pg.pre73.sql 2803 2014-01-17 14:25:01Z cimorrison $
--
-- MRBS table creation script - for PostgreSQL
--
-- Notes:
-- (1) MySQL inserts the current date/time into any timestamp field which is not
--     specified on insert. To get the same effect, use PostgreSQL default
--     value current_timestamp.
--
-- (2) If you have decided to change the prefix of your tables from 'mrbs_'
--     to something else using $db_tbl_prefix then you must edit each
--     'CREATE TABLE', 'create index' and 'INSERT INTO' line below to replace
--     'mrbs_' with your new table prefix.
--
-- (3) If you change the varchar lengths here, then you should check
--     to see whether a corresponding length has been defined in the config file
--     in the array $maxlength.
--
-- (4) If you add new (standard) fields then you should also change the global variable
--     $standard_fields.    Note that if you are just adding custom fields for
--     a single site then this is not necessary.

CREATE TABLE mrbs_area
(
  id                        serial primary key,
  disabled                  smallint DEFAULT 0 NOT NULL,
  area_name                 varchar(30),
  timezone                  varchar(50),
  area_admin_email          text,
  resolution                int,
  default_duration          int,
  default_duration_all_day  smallint DEFAULT 0 NOT NULL,
  morningstarts             int,
  morningstarts_minutes     int,
  eveningends               int,
  eveningends_minutes       int,
  private_enabled           smallint,
  private_default           smallint,
  private_mandatory         smallint,
  private_override          varchar(32),
  min_book_ahead_enabled    smallint,
  min_book_ahead_secs       int,
  max_book_ahead_enabled    smallint,
  max_book_ahead_secs       int,
  max_per_day_enabled       smallint DEFAULT 0 NOT NULL,
  max_per_day               int DEFAULT 0 NOT NULL,
  max_per_week_enabled      smallint DEFAULT 0 NOT NULL,
  max_per_week              int DEFAULT 0 NOT NULL,
  max_per_month_enabled     smallint DEFAULT 0 NOT NULL,
  max_per_month             int DEFAULT 0 NOT NULL,
  max_per_year_enabled      smallint DEFAULT 0 NOT NULL,
  max_per_year              int DEFAULT 0 NOT NULL,
  max_per_future_enabled    smallint DEFAULT 0 NOT NULL,
  max_per_future            int DEFAULT 0 NOT NULL,
  custom_html               text,
  approval_enabled          smallint,
  reminders_enabled         smallint,
  enable_periods            smallint,
  confirmation_enabled      smallint,
  confirmed_default         smallint
);

CREATE TABLE mrbs_room
(
  id                serial primary key,
  disabled          smallint DEFAULT 0 NOT NULL,
  area_id           int DEFAULT 0 NOT NULL,
  room_name         varchar(25) DEFAULT '' NOT NULL,
  sort_key          varchar(25) DEFAULT '' NOT NULL,
  description       varchar(60),
  capacity          int DEFAULT 0 NOT NULL,
  room_admin_email  text,
  custom_html       text
);
create index mrbs_idxSortKey on mrbs_room(sort_key);

CREATE TABLE mrbs_entry
(
  id             serial primary key,
  start_time     int DEFAULT 0 NOT NULL,
  end_time       int DEFAULT 0 NOT NULL,
  entry_type     int DEFAULT 0 NOT NULL,
  repeat_id      int DEFAULT 0 NOT NULL,
  room_id        int DEFAULT 1 NOT NULL,
  timestamp      timestamp DEFAULT current_timestamp,
  create_by      varchar(80) DEFAULT '' NOT NULL,
  modified_by    varchar(80) DEFAULT '' NOT NULL,
  name           varchar(80) DEFAULT '' NOT NULL,
  type           char DEFAULT 'E' NOT NULL,
  description    text,
  status         smallint DEFAULT 0 NOT NULL,
  reminded       int,
  info_time      int,
  info_user      varchar(80),
  info_text      text,
  ical_uid       varchar(255) DEFAULT '' NOT NULL,
  ical_sequence  smallint DEFAULT 0 NOT NULL,
  ical_recur_id  varchar(16) DEFAULT '' NOT NULL
);
create index mrbs_idxStartTime on mrbs_entry(start_time);
create index mrbs_idxEndTime on mrbs_entry(end_time);

CREATE TABLE mrbs_repeat
(
  id             serial primary key,
  start_time     int DEFAULT 0 NOT NULL,
  end_time       int DEFAULT 0 NOT NULL,
  rep_type       int DEFAULT 0 NOT NULL,
  end_date       int DEFAULT 0 NOT NULL,
  rep_opt        varchar(32) DEFAULT '' NOT NULL,
  room_id        int DEFAULT 1 NOT NULL,
  timestamp      timestamp DEFAULT current_timestamp,
  create_by      varchar(80) DEFAULT '' NOT NULL,
  modified_by    varchar(80) DEFAULT '' NOT NULL,
  name           varchar(80) DEFAULT '' NOT NULL,
  type           char DEFAULT 'E' NOT NULL,
  description    text,
  rep_num_weeks  smallint DEFAULT NULL NULL,
  month_absolute smallint DEFAULT NULL,
  month_relative varchar(4) DEFAULT NULL,
  status         smallint DEFAULT 0 NOT NULL,
  reminded       int,
  info_time      int,
  info_user      varchar(80),
  info_text      text,
  ical_uid       varchar(255) DEFAULT '' NOT NULL,
  ical_sequence  smallint DEFAULT 0 NOT NULL
);

CREATE TABLE mrbs_variables
(
  id               serial primary key,
  variable_name    varchar(80),
  variable_content text
);

CREATE TABLE mrbs_zoneinfo
(
  id                 serial primary key,
  timezone           varchar(255) DEFAULT '' NOT NULL,
  outlook_compatible smallint NOT NULL DEFAULT 0,
  vtimezone          text,
  last_updated       int NOT NULL DEFAULT 0
);

CREATE TABLE mrbs_users
(
  /* The first four fields are required. Don't remove. */
  id        serial primary key,
  level     smallint DEFAULT '0' NOT NULL,  /* play safe and give no rights */
  name      varchar(30),
  password  varchar(40),
  email     varchar(75)
);

INSERT INTO mrbs_variables (variable_name, variable_content)
  VALUES ('db_version', '36');
INSERT INTO mrbs_variables (variable_name, variable_content)
  VALUES ('local_db_version', '1');
