describe("MinicartFadeInManager", function() {

  describe("#name", function() {
    expect(MinicartFadeInManager.name).toEqual("FADE_IN_MINICART");
  });

  describe("#facade", function() {
    it("fades in when it has to fade in", function(){
      setFixtures("<div class='cart_related' style='display:none;'></div>");
      MinicartFadeInManager.facade();
      expect($('.cart_related').css("display")).toEqual("block");
    });

    it("doesn't fade in when it's already visible", function(){
      setFixtures("<div class='cart_related' style='display:block;'></div>");
      MinicartFadeInManager.facade();
      expect($('.cart_related').css("display")).toEqual("block");
    });

  });
});