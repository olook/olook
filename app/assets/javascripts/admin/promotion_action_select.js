$(function(){
  function showRel(el, classHide) {
    var inputs = '[name]';
    $(classHide).hide().find(inputs).attr('disabled', 'disabled');
    var selected = el.find(':selected');
    $(selected.attr('rel')).show().find(inputs).removeAttr('disabled');
  }

  $('.show_on_select').change(function(){
    showRel($(this), '.action_params_desc');
  });
  showRel($('.show_on_select'), '.action_params_desc');

  function toggleRel(el) {
    var it = $(el);
    if (it.is(':checked')) {
      $(it.attr('rel')).show();
    } else {
      $(it.attr('rel')).hide();
    }
  }
  $('.use_rule_parameters').change(function(){
    toggleRel(this);
  });
  toggleRel('.use_rule_parameters');
});
