if(!olook) var olook = {};
olook.checkFreebie = function() {
  $('input[name="i_want_freebie"]').unbind('change').change(function(){
    var it = $(this);
    var val = it.is(':checked') ? '1' : '0';
    $.ajax({
      url: it.data('url'),
      data: { i_want_freebie: val }
    });
  });
}

$(function(){
  olook.checkFreebie();
});
