$(document).ready(function() {
  init.carousel();
  init.bindActions();
  init.dialog();
  index = parseInt($("#id_first_question").val());

  function popupCenter(url, width, height, name) {
    var left = (screen.width/2)-(width/2);
    var top = (screen.height/2)-(height/2);

    return window.open(url, name, "menubar=no,toolbar=no,status=no,width=" + width + ",height=" + height + ",toolbar=no,left=" + left + ",top=" + top);

  }

  $("a.fbpopup").click(function(e) {
    e.stopPropagation();
    e.preventDefault();

    popupCenter($(this).attr("href"), $(this).attr("data-width"), $(this).attr("data-height"), "authPopup");

    return false;
  });

  $('.about ul li').live('click', function() {
    $(this).parent('ul').find('li').removeClass('selected');
    $(this).addClass('selected');
  });

  $(".about").live("change", function(){
    var limitOfCheckedAnswers = 2;
    if ($('.about').find(":radio:checked").length == limitOfCheckedAnswers &&
      $(".about select[name='day']").val()  != 'Dia' &&
      $(".about select[name='month']").val()  != 'Mês' &&
      $(".about select[name='year']").val()  != 'Ano'){

      $(".about .buttons li").removeClass("grey-button");
      $(".about .buttons li input").removeAttr("disabled");
    }else{
      $(".about .buttons li").addClass("grey-button");
    }
  });

});

init = {
  carousel : function() {
               $('.questions').jcarousel({
                 initCallback: init.mycarousel_initCallback,
                 itemFirstInCallback : {
                    onBeforeAnimation : init.hideArrow,
                    onAfterAnimation : init.showArrow
                 },
                 buttonPrevHTML : null,
                 scroll: 1
               });
             },

  showArrow : function(instance, item, index, state) {
        if(index == '1') {
          $('.jcarousel-prev').css('display', 'none');
        }else{
          $('.jcarousel-prev').css('display', 'block');
        }
  },

  mycarousel_initCallback : function(carousel) {
    $('.jcarousel-prev').css('display', 'block');

    $('#next_link').bind('click', function() {
      elemtId = "#question_" + index;
      carouselItem = $("#question_" + index);
      if (carouselItem.hasClass('images')) {
        carousel.next();
        index++;
      };

      if (carouselItem.hasClass('words') && $(elemtId).find(":checkbox:checked").length == 3){
        carousel.next();
        index++;
      };
    return false;
    });

    $('.jcarousel-prev').bind('click', function() {
        carousel.prev();
        index--;
        el = $("#question_" + index);
        el.find('li.selected').removeClass('selected');
        el.find('input[type=radio], input[type=checkbox]').attr('checked', false);
        return false;
    });
  
    $('.content .loading').remove();
  },

  bindActions : function() {
    $('.jcarousel-item li').live('click', function(){
      $(this).find('input').attr('checked', true);
      $(this).addClass('selected');
      $("#next_link").click();
    });
  },

  dialog : function(){
            $('a.trigger').live('click', function(e){
              el = $(this).attr('href');

              $(this).parents('#session').find('#' + el).toggle('open');
              $(this).parents('body').addClass('dialog-opened')

              e.preventDefault();

              $('#sign-in-dropdown').live('click',function(e) {
                if($('body').hasClass('dialog-opened')) {
                  e.stopPropagation();
                }
              })

              $('body.dialog-opened').live('click', function(e){
                if($('#sign-in-dropdown').is(':visible')){
                  $('#sign-in-dropdown').toggle();
                  $(this).removeClass('dialog-opened');
                  e.stopPropagation();
                }
              });
            });
           }

};

