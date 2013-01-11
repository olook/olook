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

function retrieve_zip_data(zip_code) {
  $.ajax({
    url: '/address_data',
    type: 'POST',
    data: {
      zip_code: zip_code
    }
  });
}