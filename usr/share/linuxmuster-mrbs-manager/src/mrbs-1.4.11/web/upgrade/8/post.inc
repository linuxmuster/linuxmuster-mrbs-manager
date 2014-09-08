<?php

// $Id: post.inc 2784 2013-11-21 10:48:22Z cimorrison $

// Populate the room sort_key with the room name (the default value)

global $tbl_room;

if (sql_command("UPDATE $tbl_room SET sort_key=room_name") < 0)
{
  fatal_error(0, "Error updating table. " . sql_error());
}

