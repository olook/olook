if(!olook) var olook = {};
olook.customSelect = function(selector){
  var setText = function(e) {
    if(!e)
      var it = $(this)
    else
      var it = $(e);

    var txt = it.find('option:selected').text();
    it.prev().children("span").text(txt);
  }
  $(selector).each(setText).change(setText);
}
