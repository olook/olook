app.views.Steps = Backbone.View.extend({
  tagName: 'nav',
  id: 'steps',
  template: _.template($('#tpl-steps').html() || ""),
  steps: ["login", "address", "payment", "confirmation"],
  initialize: function() {
    this.model.on('change', this.setStep, this);
  },
  checkNextStep: function() {
    return this.steps[this.currentStepIndex() + 1];
  },
  currentStepIndex: function() {
    var curStep = this.steps.indexOf(this.model.get('step'));
    if(!curStep) curStep = 0;
    return curStep;
  },
  setStep: function() {
    var index = this.currentStepIndex() + 1;
    this.$el.find('li').removeClass('selected');
    this.$el.find('li:nth-child(' + index + ')').addClass('selected');
  },
  render: function() {
    this.$el.html(this.template({}));
  }
});
