describe("MinicartBoxDisplayUpdater", function() {

  describe("#config", function() {
    beforeEach(function(){
      olookApp = jasmine.createSpyObj('olookApp', ['subscribe']);
    });
    it("should call subscribe in channel minicart:update:box_display", function(){
      var obj = new MinicartBoxDisplayUpdater();
      obj.config();
      expect(olookApp.subscribe).toHaveBeenCalledWith("minicart:update:box_display", obj.facade, {}, obj);
    });
  });

  describe("#facade", function() {
    describe("when the cart is empty", function() {
      it("must show the empty cart box",function(){
        setFixtures("<div class='empty_minicart' style='display:none;'></div>");
        new MinicartBoxDisplayUpdater().facade();
        JasmineAjaxHelper.expectCartDisplayProperty($('.empty_minicart'),"display","block", "the empty minicart didn't fade in");
      });

      it("must not indicate that there are products inside the cart",function(){
        setFixtures("<div class='cart_related look_product_added'></div>");
        new MinicartBoxDisplayUpdater().facade();
        expect($('.look_product_added').length).toEqual(0);
      });

      it("erases the minicart price",function(){
        setFixtures("<div class='minicart_price'>fsaddfsaafdsdfsa</div>");
        new MinicartBoxDisplayUpdater().facade();
        expect($('.minicart_price').html()).toEqual("");
      });

      it("must disable the submit button",function(){
        setFixtures("<div class='js-minicartItem'></div><div class='js-addToCartButton disabled' disabled='disabled'></div>");
        new MinicartBoxDisplayUpdater().facade();
        expect($('.js-addToCartButton').attr("disabled")).toEqual(undefined);
        expect($('.disabled').length).toEqual(0);
      });
    });

    describe("when the cart isn't empty", function() {
      it("enables the submit button",function(){
        setFixtures("<div class='js-minicartItem'></div><div class='js-addToCartButton disabled' disabled='disabled'></div>");
        new MinicartBoxDisplayUpdater().facade();
        expect($('.js-addToCartButton').attr("disabled")).toEqual(undefined);
        expect($('.disabled').length).toEqual(0);
      });
    });

  });
});
