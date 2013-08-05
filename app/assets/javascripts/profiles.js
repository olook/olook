quiz = {} || null;
previous_button = { } || null;

previous_button = {
  back: function() {
    $(this).prev().parent().parent().parent().animate({ "margin-left": "850px" }, "slow" );
  }
}
quiz = {
    respond_question: function(el) {
        el = $(el);
          el.on("click", function(){
                $("img.selected").removeClass("selected").prev().find("input").removeAttr("checked");
                $(this).addClass("selected").prev().find("input").attr("checked", "checked");
                $(this).prev().parent().parent().parent().animate({ "margin-left": "-850px" }, "slow" );
            })
    }
}
$(function(){
    quiz.respond_question("img");
    $("#back").on("click", function(){
        $("img.selected").prev().parent().parent().parent().animate({ "margin-left": "0px" }, "slow" );
    });
});
