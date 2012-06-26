$(function() {
  initFirstVisit.inviteLightbox();
});

initFirstVisit = {
  inviteLightbox : function() {
    clone = $("div.box_invite").clone().addClass("clone");
    $(clone).find("li.facebook a").attr("id", "facebook_post_wall");
    $(clone).find("li.orkut #orkut_share").remove();
    content = clone[0].outerHTML;
    initBase.modal(content);
    initFirstVisit.copyInviteLink();
    initFirstVisit.createOrkutShareButton();
  },

  copyInviteLink : function() {
    $("div.box_invite.clone div.link_mail ul li a").zclip({
      path: "/assets/ZeroClipboard.swf",
      copy: function() { return $("div.box_invite.clone div.link_mail ul li input").val(); },
      afterCopy: function(){
        $("div.box_invite.clone div.link_mail div.box_copy").fadeIn().delay(2000).fadeOut();
      }
    });
  },

  createOrkutShareButton : function() {
    orkutButton = $("#orkut_share").find("img").first();
    $("div.box_invite.clone div.social ul li.orkut").append(orkutButton);
  }
}
