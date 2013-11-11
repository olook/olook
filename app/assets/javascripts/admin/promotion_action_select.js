$(function(){
  function showRel(el, classHide) {
    el = $(el);
    var inputs = '[name]';
    $(classHide).hide().find(inputs).attr('disabled', 'disabled');
    var selected = el.find(':selected');
    $(selected.attr('rel')).show().find(inputs).removeAttr('disabled');
  }

  $('.show_on_select').change(function(){
    showRel($(this), '.action_params_desc');
  });
  showRel($('.show_on_select'), '.action_params_desc');

  function checkUseRuleParameters(el) {
    if($(el).val() == '0') {
      $('.promotion_rules').slideUp();
    } else {
      $('.promotion_rules').slideDown();
    }
  }
  $('.use_rule_parameters').change(function(){
    checkUseRuleParameters(this);
  });
  checkUseRuleParameters('.use_rule_parameters')
  $('.promotion_rule_selection').change(function(){
    var el = $(this);
    var parent = el.parents('.promotion_rule');
    parent.find('.promotion_rule_eg, .promotion_rule_params').hide();
    var className = el.find(':selected').attr('rel');
    el.siblings("." + className + '_eg').show();
    parent.find("." + className + '_params').show();
  });
  function removePromotionRule(){
    var par = $(this).parents('.promotion_rule');
    par.siblings('.destroy_rule_parameter').val('1');
    par.remove();
    updateRuleParameterCount();
  }
  $('.remove_rule').unbind('click').click(removePromotionRule);

  function updateRuleParameterCount() {
    var remainingRules = $('.promotion_rule h3');
    for (var i = 0, l = remainingRules.length; i < l; i ++) {
      var v = $(remainingRules[i]);
      v.text("Passo " + (i + 1));
    }
  }

  $('.add_rule').unbind('click').click(function(e){
    e.preventDefault();
    var shape = $('.ruleParameterShape').html();
    shape = shape.replace(/__ID__/g, new Date().getTime());
    $('.promotion_rules').append(shape);
    updateRuleParameterCount();
    $('.remove_rule').unbind('click').click(removePromotionRule);
  });
});
