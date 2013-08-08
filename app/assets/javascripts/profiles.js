quiz = {} || null;
previous_button = { } || null;
var ready_to_click = true;

previous_button = {
  back: function() {
    $(this).prev().parent().parent().parent().animate({ "margin-left": "850px" }, "slow" );
  }
}
quiz = {
  respond_question: function(el) {
    var el = $(el);
    el.on("click", function(){
      if (!ready_to_click) { return false }
      var context = $(this).parents('ol');
      $(this).parent().parent().addClass("current_question");
      context.find("li.selected").removeClass("selected");
      $(this).addClass("selected");
      $(this).find("input").attr("checked", "checked");
      ready_to_click = true
    });
  },

    next_question: function() {
    if (!ready_to_click) { return false }
      $("li.next-step-on-click").on("click", function(){
        ready_to_click = false
        $(".current_question").animate({ "margin-left": "-850px" }, "slow" );
        $(".current_question:last").removeClass("current_question").next().addClass("current_question");

        if ($(".last_step").hasClass("current_question")) {
            $(".end_quiz_button").show()
        };

        ready_to_click = true
      });
    },

    calculate_bar: function(el) {
     var el = $(el), questions = $(".step"), questions_count = questions.length;

     el.on("click", function(){
        for (i=0; i <= questions_count; i++) {
          if ($(questions[i]).hasClass("current_question")) {
            var percentage =  (i/questions_count) * 100
            $(".quiz_pink_bar").width(percentage.toString() + "%");
            switch(percentage){
              case(25):
                $(".start_quiz").show();
                $(".end_quiz").hide();
                $(".half_quiz").hide();
              break;
              case(50):
                $(".start_quiz").hide();
                $(".end_quiz").hide();
                $(".half_quiz").show();
              break;
             case(75):
                $(".start_quiz").hide();
               $(".half_quiz").hide();
               $(".end_quiz").show();
             break;
            }
          };
        }
      });
    }
}


$(function(){
  quiz.respond_question("li.check-input");
  quiz.next_question();
  quiz.calculate_bar("li.check-input");
  $("#back").on("click", function(){
    var current_question = $(".current_question:last");
    var previous_question = $(".current_question:last").prev();
    $(".current_question").removeClass("current_question");
    previous_question.animate({ "margin-left": "0px" }, "slow" ).addClass("current_question");
    quiz.calculate_bar("#back");
    if (!$(".last_step").hasClass("current_question")) {
      $(".end_quiz_button").hide()
    };
  });
});
