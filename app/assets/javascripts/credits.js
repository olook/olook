$(function() {
  $("section#friends_credits div.link_mail ul li a").zclip({
    path: "/assets/ZeroClipboard.swf",
    copy: function() { return $("section#friends_credits div.link_mail ul li input").val(); },
    afterCopy: function(){
      $("section#friends_credits div.link_mail div.box_copy").fadeIn().delay(2000).fadeOut();
    }
  });
})
