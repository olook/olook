$(function() {
  initCredits.createOrkutShareButton();

  $("section#friends_credits div.link_mail ul li a").zclip({
    path: "/assets/ZeroClipboard.swf",
    copy: function() { return $("section#friends_credits div.link_mail ul li input").val(); },
    afterCopy: function(){
      $("section#friends_credits div.link_mail div.box_copy").fadeIn().delay(2000).fadeOut();
    }
  });

  orkutButton = $("#orkut_share").find("img").first();
  $("div.box_invite.clone div.social ul li.orkut").append(orkutButton);
});

initCredits = {
  createOrkutShareButton : function() {
    orkutButton = $("#orkut_share").find("img").first();
    $("section#friends_credits div.link_mail ul li.orkut").append(orkutButton);
  }
}
