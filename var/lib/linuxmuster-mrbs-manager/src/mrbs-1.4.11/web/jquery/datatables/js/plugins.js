// $Id: plugins.js 2064 2011-10-03 13:01:55Z cimorrison $

// Selected plugins from http://datatables.net/plug-ins/api

$.fn.dataTableExt.oApi.fnGetFilteredData = function ( oSettings ) {
  var a = [];
  for ( var i=0, iLen=oSettings.aiDisplay.length ; i<iLen ; i++ ) {
    a.push(oSettings.aoData[ oSettings.aiDisplay[i] ]._aData);
  }
  return a;
};


$.fn.dataTableExt.oApi.fnReloadAjax = function ( oSettings, sNewSource, fnCallback, bStandingRedraw )
{
  if ( typeof sNewSource != 'undefined' && sNewSource != null )
  {
    oSettings.sAjaxSource = sNewSource;
  }
  this.oApi._fnProcessingDisplay( oSettings, true );
  var that = this;
  var iStart = oSettings._iDisplayStart;
  
  oSettings.fnServerData( oSettings.sAjaxSource, [], function(json) {
    /* Clear the old information from the table */
    that.oApi._fnClearTable( oSettings );
    
    /* Got the data - add it to the table */
    for ( var i=0 ; i<json.aaData.length ; i++ )
    {
      that.oApi._fnAddData( oSettings, json.aaData[i] );
    }
    
    oSettings.aiDisplay = oSettings.aiDisplayMaster.slice();
    that.fnDraw();
    
    if ( typeof bStandingRedraw != 'undefined' && bStandingRedraw === true )
    {
      oSettings._iDisplayStart = iStart;
      that.fnDraw( false );
    }
    
    that.oApi._fnProcessingDisplay( oSettings, false );
    
    /* Callback user function - for event handlers etc */
    if ( typeof fnCallback == 'function' && fnCallback != null )
    {
      fnCallback( oSettings );
    }
  }, oSettings );
};


// Sorting plugins

$.fn.dataTableExt.oSort['title-numeric-asc']  = function(a,b) {
  var x = a.match(/title="*(-?[0-9\.]+)/)[1];
  var y = b.match(/title="*(-?[0-9\.]+)/)[1];
  x = parseFloat( x );
  y = parseFloat( y );
  return ((x < y) ? -1 : ((x > y) ?  1 : 0));
  };

$.fn.dataTableExt.oSort['title-numeric-desc'] = function(a,b) {
  var x = a.match(/title="*(-?[0-9\.]+)/)[1];
  var y = b.match(/title="*(-?[0-9\.]+)/)[1];
  x = parseFloat( x );
  y = parseFloat( y );
  return ((x < y) ?  1 : ((x > y) ? -1 : 0));
  };

// Filtering plugins

$.fn.dataTableExt.ofnSearch['title-numeric'] = function ( sData ) {
   return sData.replace(/\n/g," ").replace( /<.*?>/g, "" );
   };

