<?php
// $Id: day.php 2784 2013-11-21 10:48:22Z cimorrison $



require "defaultincludes.inc";
require_once "mincals.inc";
require_once "functions_table.inc";

// Get non-standard form variables
$timetohighlight = get_form_var('timetohighlight', 'int');
$ajax = get_form_var('ajax', 'int');

$inner_html = day_table_innerhtml($day, $month, $year, $room, $area, $timetohighlight);

if ($ajax)
{
  if (checkAuthorised(TRUE))
  {
    echo $inner_html;
  }
  exit;
}

// Check the user is authorised for this page
checkAuthorised();

// Form the room parameter for use in query strings.    We want to preserve room information
// if possible when switching between views
$room_param = (empty($room)) ? "" : "&amp;room=$room";

$timestamp = mktime(12, 0, 0, $month, $day, $year);

// print the page header
print_header($day, $month, $year, $area, isset($room) ? $room : "");

echo "<div id=\"dwm_header\" class=\"screenonly\">\n";

// Show all available areas
echo make_area_select_html('day.php', $area, $year, $month, $day);

// Draw the three month calendars
if (!$display_calendar_bottom)
{
  minicals($year, $month, $day, $area, $room, 'day');
}

echo "</div>\n";


//y? are year, month and day of yesterday
//t? are year, month and day of tomorrow

// find the last non-hidden day
$d = $day;
do
{  
  $d--;
  $i= mktime(12,0,0,$month,$d,$year);
}
while (is_hidden_day(date("w", $i)) && ($d > $day - 7));  // break the loop if all days are hidden
$yy = date("Y",$i);
$ym = date("m",$i);
$yd = date("d",$i);

// find the next non-hidden day
$d = $day;
do
{
  $d++;
  $i= mktime(12, 0, 0, $month, $d, $year);
}
while (is_hidden_day(date("w", $i)) && ($d < $day + 7));  // break the loop if all days are hidden
$ty = date("Y",$i);
$tm = date("m",$i);
$td = date("d",$i);



// Show current date and timezone
echo "<div id=\"dwm\">\n";
echo "<h2>" . utf8_strftime($strftime_format['date'], $timestamp) . "</h2>\n";
if ($display_timezone)
{
  echo "<div class=\"timezone\">";
  echo get_vocab("timezone") . ": " . date('T', $timestamp) . " (UTC" . date('O', $timestamp) . ")";
  echo "</div>\n";
}
echo "</div>\n";
  
// Generate Go to day before and after links
$before_after_links_html = "
<div class=\"screenonly\">
  <div class=\"date_nav\">
    <div class=\"date_before\">
      <a href=\"day.php?year=$yy&amp;month=$ym&amp;day=$yd&amp;area=$area$room_param\">&lt;&lt;&nbsp;". get_vocab("daybefore") ."
      </a>
    </div>
    <div class=\"date_now\">
      <a href=\"day.php?area=$area$room_param\">" . get_vocab("gototoday") . "</a>
    </div>
    <div class=\"date_after\">
      <a href=\"day.php?year=$ty&amp;month=$tm&amp;day=$td&amp;area=$area$room_param\">". get_vocab("dayafter") . "&nbsp;&gt;&gt;
      </a>
    </div>
  </div>
</div>\n";

// and output them
echo $before_after_links_html;

echo "<table class=\"dwm_main\" id=\"day_main\" data-resolution=\"$resolution\">\n";
echo $inner_html;
echo "</table>\n";
  
echo $before_after_links_html;

show_colour_key();
// Draw the three month calendars
if ($display_calendar_bottom)
{
  minicals($year, $month, $day, $area, $room, 'day');
}


output_trailer();

