$(function() {
  initCredits.toggleEmailBox();
  initCredits.addTriggerToFacebook();
  initCredits.createOrkutShareButton();

  $("section#friends_credits div.link_mail ul li a").zclip({
    path: "/assets/ZeroClipboard.swf",
    copy: function() { return $("section#friends_credits div.link_mail ul li input").val(); },
    afterCopy: function(){
      $("section#friends_credits div.link_mail div.box_copy").fadeIn().delay(2000).fadeOut();
    }
  });

  orkutButton = $("#orkut_share").find("img").first();
  $("div.box_invite div.social ul li.orkut").append(orkutButton);
});

initCredits = {
  createOrkutShareButton : function() {
    orkutButton = $("#orkut_share").find("img").first();
    $("section#friends_credits div.link_mail ul li.orkut").append(orkutButton);
  },

  toggleEmailBox : function() {
    $("section#friends_credits div.social ul li a").live("click", function() {
      type = $(this).parent().attr("class");
      if(type != "email") {
        $("section#friends_credits div.social ul li a").removeClass("selected");
        $("section#friends_credits div.social form").slideUp();
      } else {
        $(this).addClass("selected");
        $("section#friends_credits div.social form").slideDown();
        $("html, body").animate({
          scrollTop: "200px"
        }, 'slow');
        return false;
      }
    });
  },

  addTriggerToFacebook : function() {
    $("section#friends_credits div.social ul li.facebook a").attr("id", "facebook_post_wall");
  }
}
;
