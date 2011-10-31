$(document).ready(function() {
  $("#import-contacts form").hide();
  $("#import-contacts .gmail, #import-contacts .yahoo").click(function(event){
    event.preventDefault();
    $("#import-contacts form").show();
    var email_provider = $(this).attr('class');
    $("#email_provider").val(email_provider);
  });
});

