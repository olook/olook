describe("MinicartFadeInManager", function() {

  describe("#config", function() {
    beforeEach(function(){
      olookApp = jasmine.createSpyObj('olookApp', ['subscribe']);
    });
    it("should call subscribe in channel minicart:update:fadein", function(){
      var obj = new MinicartFadeInManager();
      obj.config();
      expect(olookApp.subscribe).toHaveBeenCalledWith("minicart:update:fadein", obj.facade, {}, obj);
    });
  });


  describe("#facade", function() {
    it("fades in when it has to fade in", function(){
      setFixtures("<div class='cart_related' style='display:none;'></div>");
      new MinicartFadeInManager().facade();
      expect($('.cart_related').css("display")).toEqual("block");
    });

    it("doesn't fade in when it's already visible", function(){
      setFixtures("<div class='cart_related' style='display:block;'></div>");
      new MinicartFadeInManager().facade();
      expect($('.cart_related').css("display")).toEqual("block");
    });

  });
});
