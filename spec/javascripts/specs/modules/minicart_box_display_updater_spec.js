describe("MinicartBoxDisplayUpdater", function() {

  describe("#name", function() {
    it("should be called UPDATE_MINICART_BOX_DISPLAY", function(){
      expect(MinicartBoxDisplayUpdater.name).toEqual("UPDATE_MINICART_BOX_DISPLAY");
    });
  });

  describe("#facade", function() {
    // it("fades out when it has to fade out", function(){
    //   setFixtures("<input id='total_price' name='total_price' /><div class='cart_related' style='display:block;'><ul><li></li></ul></div>");
    //   MinicartFadeOutManager.facade(123);
    //    // Wait for fadeOut event finished
    //   waitsFor(function() {
    //   return ($('.cart_related').css("display") == "none");
    //   }, "The element won't ever be hidden", 3000);
    //   runs(function(){
    //     expect($('.cart_related').css("display")).toEqual("none");
    //   });
    // });

    // it("doesn't fade out when there's an element in the list", function(){
    //   setFixtures("<input id='total_price' name='total_price' /><div class='cart_related'><ul><li></li><li></li></ul></div>");
    //   MinicartFadeInManager.facade();
    //   waitsFor(function() {
    //   return ($('.cart_related').css("display") == "none");
    //   }, "The element won't ever be shown", 3000);
    //   runs(function(){
    //     expect($('.cart_related').css("display")).toEqual("block");
    //   });
    // });

  });
});