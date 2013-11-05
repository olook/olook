$(function(){
  function showRel(el, classHide) {
    var inputs = '[name]';
    $(classHide).hide().find(inputs).attr('disabled', 'disabled');
    $(el.find(':selected').attr('rel')).show().find(inputs).removeAttr('disabled');
  }

  $('.show_on_select').change(function(){
    showRel($(this), '.action_params_desc');
  });
  showRel($(this), '.action_params_desc');
});
