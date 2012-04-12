$( "form#gift_message" ).bind( "ajax:success", function( evt, xhr, settings ) {
    document.location = $( "a.continue" ).attr( "href" );
});

$( ".continue" ).click( function() {
    $( "form#gift_message" ).submit();
})

$( "#gift_gift_wrapped" ).change( function() {
    $( "#gift_wrapped" ).submit();
    if ( $(this).attr('checked') == 'checked' ) {
        $('.hidden_row').slideDown("slow");
    }
    else {
        $('.hidden_row').slideUp("slow");
    }
});
