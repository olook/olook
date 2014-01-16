describe("MinicartFadeOutManager", function() {

  describe("#name", function() {
    it("should be called FADE_OUT_MINICART", function(){
      expect(MinicartFadeOutManager.name).toEqual("FADE_OUT_MINICART");
    });
  });

  describe("#facade", function() {
    it("fades out when it has to fade out", function(){
      setFixtures("<input id='total_price' name='total_price' /><div class='cart_related' style='display:block;'><ul><li></li></ul></div>");
      MinicartFadeOutManager.facade(123);
       // Wait for fadeOut event finished
      waitsFor(function() {
      return ($('.cart_related').css("display") == "none");
      }, "The element won't ever be hidden", 3000);
      runs(function(){
        expect($('.cart_related').css("display")).toEqual("none");
      });
    });

    it("doesn't fade out when there's an element in the list", function(){
      setFixtures("<input id='total_price' name='total_price' /><div class='cart_related'><ul><li></li><li></li></ul></div>");
      MinicartFadeInManager.facade();
      waitsFor(function() {
      return ($('.cart_related').css("display") == "none");
      }, "The element won't ever be shown", 3000);
      runs(function(){
        expect($('.cart_related').css("display")).toEqual("block");
      });
    });

  });
});