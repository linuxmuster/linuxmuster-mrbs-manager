<?php

/* $Id: escapeshellarg.inc 2784 2013-11-21 10:48:22Z cimorrison $
 *
 * Included if your PHP version is less than 4.0.3 and therefore this
 * function doesn't exist.
 *
 */

function escapeshellarg($x)
{
  return "'".preg_replace("/'/", "\\'", $x)."'";
} 

