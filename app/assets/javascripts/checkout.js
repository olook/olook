$(function() {

  $( "#checkout_credits_use_credits" ).change(function() {
    $.ajax({
      url: '/sacola',
      type: 'PUT',
      data: {
        cart: {
          use_credits: $(this).attr('checked') == 'checked'
        }
      }
    });
  });

});

