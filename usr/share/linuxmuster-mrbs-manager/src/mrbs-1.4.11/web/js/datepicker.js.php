<?php

// $Id: datepicker.js.php 2804 2014-01-20 20:59:59Z cimorrison $

require "../defaultincludes.inc";

header("Content-type: application/x-javascript");
expires_header(60*30); // 30 minute expiry

if ($use_strict)
{
  echo "'use strict';\n";
}

// Set the default values for datepicker, including the default regional setting
?>
$(function() {
  <?php
  // We set the regional setting by setting locales in reverse order of priority.
  // If you try and set a datepicker locale that doesn't exist, then nothing is
  // changed and the regional setting stays as it was before.   The reverse order
  // of priority is:
  // - the MRBS default language
  // - locales taken from the browser in increasing order of browser preference,
  //   taking for each locale
  //     - the language part only (in case the xx-YY localisation does not exist)
  //     - the full locale
  // - then, if automatic language changing is disabled, 
  //      - the MRBS default language setting again
  //      - the language part of the override_locale
  //      - the full override_locale
  // This algorithm is designed to ensure that datepicker is set to the closest
  // available locale to that specified in the config file.   If automatic language
  // changing is disabled, we fall back to a browser specified locale if the locale
  // in the config file is not available in datepicker.
  
  $default_lang = locale_format($default_language_tokens, '-');
  
  // Note that we use [''] rather than dot notation for the regional settings because
  // settings such as 'en-US' would break dot notation.
  echo "$.datepicker.setDefaults($.datepicker.regional['$default_lang']);\n";
  $datepicker_langs = get_language_qualifiers();
  $datepicker_langs = alias_qualifiers($datepicker_langs);
  asort($datepicker_langs, SORT_NUMERIC);
  foreach ($datepicker_langs as $lang => $qual)
  {
    // Get the locale in the format that datepicker likes: language lower case
    // and country upper case (xx-XX)
    $datepicker_locale = locale_format($lang, '-');
    // First we'll try and get the correct language and then we'll try and
    // overwrite that with the correct country variant
    if (strlen($datepicker_locale) > 2)
    {
      $datepicker_lang = substr($datepicker_locale, 0, 2);
      echo "$.datepicker.setDefaults($.datepicker.regional['$datepicker_lang']);\n";
    }
    echo "$.datepicker.setDefaults($.datepicker.regional['$datepicker_locale']);\n";
  }
  if ($disable_automatic_language_changing)
  {
    // They don't want us to use the browser language, so we'll set the datepicker
    // locale setting back to the default language (as a fall-back) and then we'll
    // try and set it to the override_locale
    echo "$.datepicker.setDefaults($.datepicker.regional['$default_lang']);\n";
    if (!empty($override_locale))
    {
      if ($server_os == 'windows')
      {
        // If the server is running on Windows we'll have to try and translate the 
        // Windows style locale back into an xx-YY locale
        $datepicker_locale = array_search($override_locale, $lang_map_windows);
      }
      else
      {
        $datepicker_locale = $override_locale;
      }
      if (!empty($datepicker_locale))  // in case the array_search() returned FALSE
      {
        $datepicker_locale = locale_format($datepicker_locale, '-');
        $datepicker_locale = substr($datepicker_locale, 0, 5);  // strip off anything after the country (eg charset)
        $datepicker_lang = substr($datepicker_locale, 0, 2);
        // First we'll try and get the correct language and then we'll try and
        // overwrite that with the correct country variant
        echo "$.datepicker.setDefaults($.datepicker.regional['$datepicker_lang']);\n";
        echo "$.datepicker.setDefaults($.datepicker.regional['$datepicker_locale']);\n";
      }
    }
  }
  ?>
  $.datepicker.setDefaults({
    showOtherMonths: true,
    selectOtherMonths: true,
    changeMonth: true,
    changeYear: true,
    duration: 'fast',
    showWeek: <?php echo ($view_week_number) ? 'true' : 'false' ?>,
    firstDay: <?php echo $weekstarts ?>,
    altFormat: 'yy-mm-dd',
    onSelect: function(dateText, inst) {datepickerSelect(inst);}
  });
});


<?php
// Populate the three sub-fields associated with the alt input altID
?>
function populateAltComponents(altId)
{
  var date = $('#' + altId).val().split('-');

  $('#' + altId + '_year').val(date[0]);
  $('#' + altId + '_month').val(date[1]);
  $('#' + altId + '_day').val(date[2]);
}


<?php
// Writes out the day, month and year values to the three hidden inputs
// created by the PHP function genDateSelector().    It gets the date values
// from the _alt input, which is the alternate field populated by datepicker
// and is populated by datepicker with a date in yy-mm-dd format.
//
// (datepicker can only have one alternate field, which is why we need to write
// to the three fields ourselves).
//
// Blur the datepicker input field on select, so that the datepicker will reappear
// if you select it.    (Not quite sure why you need this.  It only seems
// to be necessary when you are using Firefox and the datepicker is draggable).

// If formId is defined, submit the form
//
// Finally, trigger a datePickerUpdated event so that it can be dealt with elsewhere
// by code that relies on having updated values in the alt fields
?>
function datepickerSelect(inst, formId)
{
  var id = inst.id,
      datepickerInput = $('#' + id);

  populateAltComponents(id + '_alt');
  datepickerInput.blur();
  
  if (formId)
  {
    $('#' + formId).submit();
  }
  
  datepickerInput.trigger('datePickerUpdated');
}

<?php
// =================================================================================

// Extend the init() function 
?>

var oldInitDatepicker = init;
init = function() {
  oldInitDatepicker.apply(this);

  <?php
  // Overwrite the date selectors with a datepicker
  ?>
  $('span.dateselector').each(function() {
      var span = $(this);
      var prefix  = span.data('prefix'),
          minYear = span.data('minYear'),
          maxYear = span.data('maxYear'),
          formId  = span.data('formId');
      var dateData = {day:   parseInt(span.data('day'), 10),
                      month: parseInt(span.data('month'), 10),
                      year:  parseInt(span.data('year'), 10)};
      var unit;
      var initialDate = new Date(dateData.year,
                                 dateData.month - 1,  <?php // JavaScript months run from 0 to 11 ?>
                                 dateData.day);
      var disabled = span.find('select').first().is(':disabled'),
          baseId = prefix + 'datepicker';
      
      span.empty();

      <?php
      // The next input is disabled because we don't need to pass the value through to
      // the form and we don't want the value cluttering up the URL (if it's a GET).
      // It's just used as a holder for the date in a known format so that it can
      // then be used by datepickerSelect() to populate the following three inputs.
      ?>
      $('<input>').attr('type', 'hidden')
                  .attr('id', baseId + '_alt')
                  .attr('name', prefix + '_alt')
                  .attr('disabled', 'disabled')
                  .val(dateData.year + '-' + dateData.month + '-' + dateData.day)
                  .appendTo(span);
      <?php
      // These three inputs (day, week, month) we do want
      ?>
      for (unit in dateData)
      {
        if (dateData.hasOwnProperty(unit))
        {
          $('<input>').attr('type', 'hidden')
                      .attr('id', baseId + '_alt_' + unit)
                      .attr('name', prefix + unit)
                      .val(dateData[unit])
                      .appendTo(span);
        }
      }
      <?php // Finally the main datepicker field ?>
      $('<input>').attr('class', 'date')
                  .attr('type', 'text')
                  .attr('id', baseId)
                  .datepicker({altField: '#' + baseId + '_alt',
                               disabled: disabled,
                               yearRange: minYear + ':' + maxYear})
                  .datepicker('setDate', initialDate)
                  .change(function() {
                      <?php // Allow the input field to be updated manually ?>
                      $(this).datepicker('setDate', $(this).val());
                      populateAltComponents(baseId + '_alt');
                      $(this).trigger('datePickerUpdated');
                    })
                  .appendTo(span);
                  
      if (formId.length > 0)
      {
        $('#' + baseId).datepicker('option', 'onSelect', function(dateText, inst) {
            datepickerSelect(inst, formId);
          });
      }
      
      $('.ui-datepicker').draggable();
      
    });
};

