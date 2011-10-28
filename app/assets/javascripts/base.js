$(document).ready(function() {
  $("#facebook_invite_friends").click(function() {
    sendFacebookMessage();
  });

 $("#facebook_post_wall").click(function() {
    postToFacebookFeed();
  });

 $(document).bind('keydown', 'esc',function (evt) {
    $('#sign-in-dropdown').hide();
    $('body').removeClass('dialog-opened');
    return false; 
  });

});
