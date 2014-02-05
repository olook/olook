describe("Countdown", function() {
  var countdown;
  beforeEach(function () {
    loadFixtures("countdown_field.html");
    countdown = new Countdown(".test",40);
  });
  describe(".placer", function() {
    beforeEach(function(){
      countdown.placer();
    });
    it("check if there is a placer", function() {
      expect($(".countdown").length).toEqual(1);
    });
    it("check if countdown have specific countdown number", function() {
      expect($(".countdown").text()).toEqual('40');
    });
    it("returns self", function() {
      expect(countdown.placer()).toEqual(countdown);
    });
    it("should save placer on _placer", function() {
      expect(countdown._placer).toEqual($('.countdown'));
    });
  });
  describe(".attach", function() {
    beforeEach(function(){
      $('.test').val("123456");
      countdown.placer().attach();
    });
    it("reduce count when there is some text", function(){
      expect($(".countdown").text()).toEqual('34');
    });

    it("should subtract count when there is keyup", function(){
      $('.test').val('arroz com feijão a mineira').keyup();
      expect($(".countdown").text()).toEqual('14');
    });

    it("should subtract count when there is a change", function(){
      $('.test').val('arroz com feijão a mineira').change();
      expect($(".countdown").text()).toEqual('14');
    });
  });
});
