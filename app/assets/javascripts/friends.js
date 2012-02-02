$(document).ready(function() {
  $("a.all_friends").live("click", function() {
    $("div#invite_friends div.list_mask").toggleClass("full", "");
  });

  $(".form_post_wall").bind("ajax:success", function(evt, xhr, settings){
    $(".form_post_wall textarea").val("");
  });

  $(".form_post_wall").bind("ajax:error", function(evt, xhr, settings){
  });

  $(".invite_friend").bind("click", function(event){
    event.preventDefault();
    $.post('/postar-convite', { friend_uid: $(this).attr("rel")})
    .success(function() { alert("success"); })
    .error(function() { alert("error"); })
  });

  $("div#quiz_container div.question ul li").live("click", function() {
    lists = $(this).parent("ul").find("li");
    lists.find("input[type='radio']").attr("checked", false);
    lists.removeClass("selected");
    $(this).find("input[type='radio']").attr('checked', true);
    $(this).addClass('selected');
    return false;
  });
});
