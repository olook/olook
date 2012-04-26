$("form#gift_message").bind("ajax:success", function(evt, xhr, settings) {
  document.location = $("a.continue").attr("href");
});

$(".continue").click(function() {
  $("form#gift_message").submit();
})

function change_value(wrap) {
  wrap_value = $("form#gift_wrap .inputs li p").text().match(/[0-9,]+/);
  wrap_value = parseFloat(wrap_value[0].replace( ",", "." ));

  actual_value = $('#cart .last .value').text().match(/[0-9,]+/);
  actual_value = parseFloat(actual_value[0].replace( ",", "." ));

  new_value = actual_value + ((wrap) ? wrap_value : - wrap_value);
  $('#cart .last .value').text("R$ " + new_value.toString().replace( ".", "," ));
}


$( "#gift_gift_wrap" ).change(function() {
  $( "#gift_wrap" ).submit();
  if ( $(this).attr('checked') == 'checked' ) {
    // $('.message_row').slideDown("slow");
    change_value (true);
  }
  else {
    // $('.message_row').slideUp("slow");
    change_value (false);
  }
});


// $(document).ready(function(){
//   $("#gift_message li p span").text($("#gift_gift_message").attr('maxlength'));
// });
// $("#gift_gift_message").keyup(function(){
//   $("#gift_message li p span").text($(this).attr('maxlength') - $(this).val().length);
// });

