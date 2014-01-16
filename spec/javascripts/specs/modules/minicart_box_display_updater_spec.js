describe("MinicartBoxDisplayUpdater", function() {

  describe("#name", function() {
    it("should be called UPDATE_MINICART_BOX_DISPLAY", function(){
      expect(MinicartBoxDisplayUpdater.name).toEqual("UPDATE_MINICART_BOX_DISPLAY");
    });
  });

  describe("#facade", function() {
    describe("when the cart is empty", function() {
      it("must show the empty cart box",function(){});
      it("must disable the submit button",function(){});
    });

    describe("when the cart isn't empty", function() {
      it("must enable the submit button",function(){});
    });    

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

  });
});