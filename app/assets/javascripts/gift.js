$(function () {
  $("div#calendar ul#months li a").live("click", function(event) {
    $("div#calendar ul#months li a").removeClass("selected");
    $(this).addClass("selected");
    InitGift.friendsPreloader();
    event.preventDefault();
  });

  $("div#profile form ul.shoes li").live("click", function() {
    $("div#profile form ul.shoes li").removeClass("selected");
    if($(this).find("label").find("input[type='radio']").is(":checked")) {
      $(this).addClass("selected");
    }
  });

  $("div#profile a.select_profile").live("click", function(event) {
    $("div#profile div.profiles").slideDown('normal', function() {
      container_position = $(this).position().top;
      position = container_position - 40;
      $('html, body').animate({
        scrollTop: position
      }, 'slow');
    });
    event.preventDefault();
  });

  $("form.edit_profile input").change(function() {
    $("form.edit_profile").submit();
  });
});

InitGift = {
  friendsPreloader : function() {
    $("div#birthdays_list ul.friends_list").remove();
    $("div#birthdays_list").html("<div class='preloader'></div>");
  }
}
