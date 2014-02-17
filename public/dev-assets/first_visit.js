$(function() {
  initFirstVisit.inviteLightbox();
  initFirstVisit.twitProduct();
  initFirstVisit.shareProductOnFacebook();
  initFirstVisit.shareByEmail();
  
});
window.setTimeout('initFirstVisit.copyInviteLink()', 2000);

initFirstVisit = {
  inviteLightbox: function() {console.log("aqui");
    clone = $("div.box_invite").addClass("clone");
    $(clone).find("li.facebook a").attr("id", "facebook_post_wall");
    $(clone).find("li.orkut #orkut_share").remove();
    //content = clone[0].outerHTML;

    o.newModal(clone, 400, 816);
    initFirstVisit.copyInviteLink();
  },

  copyInviteLink: function() {
    $("div.box_invite div.link_mail ul li a").zclip({
      path: "/assets/ZeroClipboard.swf",
      copy: function() { return $("div.box_invite.clone div.link_mail ul li input").val(); },
      afterCopy: function(){
        $("div.box_invite div.link_mail div.box_copy").fadeIn().delay(2000).fadeOut();
      }
    })
  },

  createOrkutShareButton: function() {
    orkutButton = $("#orkut_share").find("img").first();
    $("div.box_invite ul li.orkut").append(orkutButton);
  },
  
  twitProduct: function() {
    $("div.box_invite li.twitter a").click( function(e) {
      var width  = 575,
          height = 400,
          left   = ($(window).width()  - width)  / 2,
          top    = ($(window).height() - height) / 2,
          url    = this.href,
          opts   = 'status=1' +
                   ',width='  + width  +
                   ',height=' + height +
                   ',top='    + top    +
                   ',left='   + left;

      window.open(url, 'twitter', opts);
      e.preventDefault();
    });
  },

  shareProductOnFacebook: function() {
    $("div.box_invite li.facebook a").click(function() {
      postToFacebookFeed();

    })
  },
    
  shareByEmail: function(){
    $("div.box_invite div.social ul li a").click(function() {
      type = $(this).parent().attr("class");
      if(type != "email") {
        $("#modal").css("height", "400px");
        $("div.box_invite div.social ul li a").removeClass("selected");
        $("div.box_invite div.social form").slideUp();
      } else {
        $("#modal").css("height", "530px");
        $(this).addClass("selected");
        $("div.box_invite div.social form").slideDown();
        $("html, body").animate({
          scrollTop: "200px"
        }, 'slow');
        return false;
      }
    });
  }  
}

;
