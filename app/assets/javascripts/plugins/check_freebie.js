$(function(){
  $('input[nam="i_want_freebie"]').change(function(){
    $.ajax({
      url: $(this).data('url'),
      data: { i_want_freebie: $(this).val() }
    });
  });
});
