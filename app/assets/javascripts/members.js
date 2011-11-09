$(document).ready(function() {
  $('.import-dropdown').hide();
  $("#import-contacts .gmail").click(function(event){
    event.preventDefault();
    $(".import-dropdown > span").removeClass();
    $("#import-contacts .import-dropdown").show();
    var email_provider = $(this).attr('class');
    $("#email_provider").val(email_provider);
    $(".import-dropdown > span").addClass(email_provider);
  });

  $('.import-dropdown a').live('click', function(event){
    event.preventDefault();
    $(this).parent().hide();
  });

  $(document).bind('keydown', 'esc',function () {
    $('.import-dropdown').hide();
    return false; 
  });
});

