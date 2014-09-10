<?php

// $Id: edit_users.js.php 2519 2012-10-22 16:53:57Z cimorrison $

require "../defaultincludes.inc";

header("Content-type: application/x-javascript");
expires_header(0); // Cannot cache file because it depends on $HTTP_REFERER

if ($use_strict)
{
  echo "'use strict';\n";
}

// =================================================================================

// Extend the init() function 
?>

var oldInitEditUsers = init;
init = function(args) {
  oldInitEditUsers.apply(this, [args]);

  <?php // Turn the list of users into a dataTable ?>
  
  var tableOptions = {};
  <?php
  // Use an Ajax source if we can - gives much better performance for large tables
  if (function_exists('json_encode'))
  {
    if (strpos($HTTP_REFERER, '?') !== FALSE)
    {
      list( ,$query_string) = explode('?', $HTTP_REFERER, 2);
    }
    $ajax_url = "edit_users.php?" . (empty($query_string) ? '' : "$query_string&") . "ajax=1";
    ?>
    tableOptions.sAjaxSource = "<?php echo $ajax_url ?>";
    <?php
  }

  // Get the sTypes and feed those into dataTables
  ?>
  tableOptions.aoColumnDefs = getSTypes($('#users_table'));
  var usersTable = makeDataTable('#users_table',
                                 tableOptions,
                                 {sWidth: "relative", iWidth: 33});
};

