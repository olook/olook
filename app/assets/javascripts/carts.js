$( "form#gift_message" ).bind( "ajax:success", function( evt, xhr, settings ) {
  document.location = $( "a.continue" ).attr( "href" );
});

$( ".continue" ).click( function() {
  $( "form#gift_message" ).submit();
})

$( "#gift_gift_wrap" ).change( function() {
  $( "#gift_wrap" ).submit();
  if ( $(this).attr('checked') == 'checked' ) {
    $('.message_row').slideDown("slow");
  }
  else {
    $('.message_row').slideUp("slow");
  }
});


$(document).ready(function(){
  $("#gift_message li p span").text($("#gift_gift_message").attr('maxlength'));
});
$("#gift_gift_message").keyup(function(){
  $("#gift_message li p span").text($(this).attr('maxlength') - $(this).val().length);
});

