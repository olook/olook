$(function () {
  $("div#calendar ul#months li a").live("click", function(event) {
    $("div#calendar ul#months li a").removeClass("selected");
    $(this).addClass("selected");
    InitGift.friendsPreloader();
    event.preventDefault();
  });
});

InitGift = {
  friendsPreloader : function() {
    $("div#birthdays_list ul.friends_list").remove();
    $("div#birthdays_list").html("<div class='preloader'></div>");
  }
}
