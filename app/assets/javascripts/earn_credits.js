$(function() {
  initEarnCredits.toggleEmailBox();
  initEarnCredits.addTriggerToFacebook();

  $("section#left div.link_mail ul li a").zclip({
    path: "/assets/ZeroClipboard.swf",
    copy: function() { return $("section#left div.link_mail ul li input").val(); },
    afterCopy: function(){
      $("section#left div.link_mail div.box_copy").fadeIn().delay(2000).fadeOut();
    }
  });
});

initEarnCredits = {
  toggleEmailBox : function() {
    $("section#left div.social ul li a").live("click", function() {
      type = $(this).parent().attr("class");
      if(type != "email") {
        $("section#left div.social ul li a").removeClass("selected");
        $("section#left div.social form").slideUp();
      } else {
        $(this).addClass("selected");
        $("section#left div.social form").slideDown();
        $("html, body").animate({
          scrollTop: "200px"
        }, 'slow');
        return false;
      }
    });
  },

  addTriggerToFacebook : function() {
    $("section#left div.social ul li.facebook a").attr("id", "facebook_post_wall");
  }
}
