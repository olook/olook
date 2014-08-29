var PeriodSubmitter  = (function(){
  function PeriodSubmitter() {};

  PeriodSubmitter.prototype.config = function(){
    olookApp.subscribe('period_submitter:change', this.facade, {}, this);

    $(".js-period_form").change(function(){
      olookApp.publish('period_submitter:change');
    });
  };

  PeriodSubmitter.prototype.facade = function(){
 	$(".js-period_form").submit();
  };

  return PeriodSubmitter;
})();
