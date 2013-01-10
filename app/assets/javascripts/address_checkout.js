$(function() {
  $("#zip_code_btn").bind('click', function() {
    $.ajax({
      url: '/address_data',
      type: 'POST',
      data: {
        zip_code: $("#checkout_address_zip_code").val()
      }
    });
  });
});