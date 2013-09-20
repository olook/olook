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
  var els = $(selector).change(setText);
  for (var i = 0, l = els.length; i < l; i ++) {
    var el = els[i];
    setText(el);
  }
}
