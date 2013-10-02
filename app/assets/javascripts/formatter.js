/**
  * Formatter. This object may be used by the whole applicaton
  */

var Formatter = Formatter || {
  /**
    * Converts number to currency (Real with ',' for decimal)
    *
    */
  toCurrency: function(value) {
    return "R$ " + value.toFixed(2).toString().replace('.',',');
  }
};