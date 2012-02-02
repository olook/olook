$(document).ready(function() {
  $("a.all_friends").live("click", function() {
    $("div#invite_friends div.list_mask").toggleClass("full", "");
  });

  $("form.form_post_wall").bind("ajax:success", function(evt, xhr, settings){
    $(this).fadeOut("slow", function() {
      $("div#share_showroom").append("<h2>Sua vitrine foi postada com sucesso</h2>");
      $(this).remove();
    });
  });

  $("form.form_post_wall").bind("ajax:error", function(evt, xhr, settings){
  });

  $("div#invite_friends a.invite_friend").bind("click", function(event){
    $(this).parent("li").addClass("invited");
    event.preventDefault();
    $.post('/postar-convite', { friend_uid: $(this).attr("rel")})
    .success(function() {
      $("div#invite_friends ul li.invited").fadeOut("slow", function() {
        $(this).remove();
      });
    })
    .error(function() { return false; })
  });

  $("div#quiz_container div.question ul li").live("click", function() {
    lists = $(this).parent("ul").find("li");
    lists.find("input[type='radio']").attr("checked", false);
    lists.removeClass("selected");
    $(this).find("input[type='radio']").attr('checked', true);
    $(this).addClass('selected');
    $(this).parents("form").find("input[type='submit']").removeAttr("disabled");
    return false;
  });

  $("form.post_survey_answer").bind("ajax:success", function(evt, xhr, settings) {
    $("div#quiz_container a.next_friend").click();
  });
});
