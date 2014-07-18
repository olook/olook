app.views.Steps = Backbone.View.extend({
  tagName: 'nav',
  id: 'steps',
  template: _.template($('#tpl-steps').html() || ""),
  initialize: function() {
    this.model.on('change', this.setStep, this);
  },
  setStep: function() {
    switch(this.model.get('step')) {
      case "payment":
        this.stepPayment();
        break;
      case "confirmation":
        this.stepConfirmation();
        break;
      default:
        this.stepAddress();
    }
  },
  stepAddress: function () {
    this.$el.find('li').removeClass('selected');
    this.$el.find('li:nth-child(2)').addClass('selected');
  },
  stepPayment: function () {
    this.$el.find('li').removeClass('selected');
    this.$el.find('li:nth-child(3)').addClass('selected');
  },
  stepConfirmation: function () {
    this.$el.find('li').removeClass('selected');
    this.$el.find('li:nth-child(4)').addClass('selected');
  },
  render: function() {
    this.$el.html(this.template({}));
  }
});
