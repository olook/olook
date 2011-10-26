$(document).ready(function() {
  $("#facebook_invite_friends").click(function() {
    sendFacebookMessage();
  });

 $("#facebook_post_wall").click(function() {
    postToFacebookFeed();
  });

  var options = {
    styleClass: 'olookSelect',
    jScrollPane: 1
  }

  $('select').styleSelect(options);

});
