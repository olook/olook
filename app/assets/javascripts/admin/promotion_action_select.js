$(function(){
  function showRel(el, classHide) {
    el = $(el);
    var inputs = '[name]';
    $(classHide).hide().find(inputs).attr('disabled', 'disabled');
    var selected = el.find(':selected');
    $(selected.attr('rel')).show().find(inputs).removeAttr('disabled');
  }

  showRel($('.show_on_select'), '.action_params_desc');

  function checkUseRuleParameters(el) {
    el = $(el).filter(':checked');
    updateRuleParameterCount();
    if(el.val() == '0') {
      $('#use_rule_parameters_div').slideUp();
    } else {
      $('#use_rule_parameters_div').slideDown();
    }
  }
  checkUseRuleParameters('.use_rule_parameters')
  $('.promotion_rule_selection').unbind('change').change(function(){
    var el = $(this);
    if(promotionRuleNeedParam && !promotionRuleNeedParam['prule_' + el.val()]) {
      el.siblings('.rules_params').attr('disabled', 'disabled');
    } else {
      el.siblings('.rules_params').removeAttr('disabled').focus();
    }
  });

  function cleanOnCheck(el) {
    el = $(el);
    var target = $(el.attr('rel'));
    if (el.is(':checked')) {
      target.focus();
    } else {
      target.val('');
    }
  }

  function removePromotionRule(){
    var par = $(this).parents('.promotion_rule');
    par.siblings('.destroy_rule_parameter').val('1');
    par.remove();
    updateRuleParameterCount();
  }

  function updateRuleParameterCount() {
    var remainingRules = $('.promotion_rule h3');
    for (var i = 0, l = remainingRules.length; i < l; i ++) {
      var v = $(remainingRules[i]);
      v.text("Passo " + (i + 1));
    }
  }

  function checkOnChange(el) {
    el = $(el);
    if(el.val().length > 0) {
      var target = $(el.attr('rel'));
      target.attr('checked', 'checked');
    }
  }

  function setHidden(el) {
    el = $(el);
    var target = el.siblings('[type=hidden]');
    target.val(el.val());
  }
  function binds() {
    $('.set_hidden').unbind('click').click(function(){
      setHidden(this);
    })
    $('.check_on_change').unbind('change').change(function(){
      checkOnChange(this);
    });
    $('.remove_rule').unbind('click').click(removePromotionRule);
    $('.clean_on_check').click(function(){
      cleanOnCheck(this);
    });
    $('.use_rule_parameters').unbind('change').change(function(){
      checkUseRuleParameters(this);
    });
    $('.show_on_select').unbind('change').change(function(){
      showRel($(this), '.action_params_desc');
    });
  }
  binds();

  $('.add_rule').unbind('click').click(function(e){
    e.preventDefault();
    var shape = $('.ruleParameterShape').html();
    shape = shape.replace(/__ID__/g, new Date().getTime());
    $('.promotion_rules').append(shape);
    updateRuleParameterCount();
    binds();
  });
});
