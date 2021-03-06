//= require application_core/olook_app

quiz = {} || null;
previous_button = { } || null;

previous_button = {
  back: function() {
    $(this).prev().parent().parent().parent().animate({ "margin-left": "850px" }, "slow" );
  }
}
quiz = {
  respond_question: function(el, mark_current_question, next_question) {
    var context = $(el).parents('ol');
    if(mark_current_question){
        $(el).parents('.step').addClass("current_question");
    }
    context.find("li.selected").removeClass("selected");
    $(el).addClass("selected");
    $(el).find("input").attr("checked", "checked");
    if(next_question){
      quiz.next_question();
    }
  },


  display_or_hide_back_button: function(el) {
    (($(".current_question:last").prev(".step").length > 0) ? $("#back").show() : $("#back").hide()) ;
  },

  next_question: function() {
    $(".current_question").animate({ "margin-left": "-850px" }, {
        duration: "slow",
        complete: function(){
            $(this).removeClass("current_question").next('.step, .last_step').addClass("current_question");
            quiz.display_or_hide_back_button();

            if($(".last_step").hasClass("current_question")) {
              $(".end_quiz_button").show();
            }
        }
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
  },
  enable_button: function(){
    if($('ol.options').length == $('ol.options input:checked').length){
      $('.end_quiz_button').removeClass('disable').addClass('enable').removeAttr("disabled");
    }
  }
}


$(function(){
  $('li.next-step-on-click').
    click(function(){
      quiz.respond_question(this, true, true);
      quiz.enable_button;
    });
  $('li.check-input').click(function(){
    quiz.respond_question(this, false);
    quiz.enable_button;
  });
  quiz.calculate_bar("li");
  $("#back").on("click", function(){
    var current_question = $(".current_question:last");
    var previous_question = current_question.prev();
    $(".current_question").removeClass("current_question");
    previous_question.animate({ "margin-left": "0px" }, "slow" ).addClass("current_question");
    quiz.display_or_hide_back_button();
    quiz.calculate_bar("#back");
    if (!$(".last_step").hasClass("current_question")) {
      $(".end_quiz_button").hide();
    };
  });

  $('ol li').on("click", function(){
    quiz.enable_button();
  });

});
