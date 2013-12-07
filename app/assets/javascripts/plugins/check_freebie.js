$(function(){
  $('input[name="i_want_freebie"]').unbind('change').change(function(){
    $.ajax({
      url: $(this).data('url'),
      data: { i_want_freebie: $(this).val() }
    });
  });
});
