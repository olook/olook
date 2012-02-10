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
    uid = $(this).attr("rel");
    $(this).parent("li").addClass("selected_"+uid);
    event.preventDefault();
    $.post('/postar-convite', { friend_uid: $(this).attr("rel")})
    .success(function() {
      $("div#invite_friends ul li.selected_"+uid+" div").hide();
      $("div#invite_friends ul li.selected_"+uid+" div.success").show();
    })
    .error(function() {
      $("div#invite_friends ul li.selected_"+uid+" div").hide();
      $("div#invite_friends ul li.selected_"+uid+" div.error").show().delay(2000).fadeOut();
    })
  });

  $("div#quiz_container div.question ul li").live("click", function() {
    lists = $(this).parent("ul").find("li");
    lists.find("input[type='radio']").attr("checked", false);
    lists.removeClass("selected");
    $(this).find("input[type='radio']").attr('checked', true);
    $(this).addClass('selected');
    $(this).parents("form").find("input[type='submit']").removeAttr("disabled").removeClass("disabled");
    return false;
  });

  $("form.form_post_wall textarea").live("keyup", function() {
    if($(this).val() != '') {
      $("form.form_post_wall input[type='submit']").removeAttr("disabled").removeClass("disabled");
    } else {
      $("form.form_post_wall input[type='submit']").addClass("disabled");
      $("form.form_post_wall input[type='submit']").attr("disabled", "disabled");
    }
  });

  $("form.post_survey_answer").bind("ajax:success", function(evt, xhr, settings) {
    $("div#quiz_container a.next_friend").click();
  });
});
