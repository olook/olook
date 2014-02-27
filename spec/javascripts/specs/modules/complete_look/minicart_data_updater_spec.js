describe("MinicartDataUpdater", function() {

  describe("#config", function() {
    beforeEach(function(){
      olookApp = jasmine.createSpyObj('olookApp', ['subscribe']);
    });
    it("should call subscribe in channel minicart:update:box_display", function(){
      var obj = new MinicartDataUpdater();
      obj.config();
      expect(olookApp.subscribe).toHaveBeenCalledWith("minicart:update:data", obj.facade, {}, obj);
    });
  });


  describe("#facade", function() {
    describe("when an item is added",function(){
      describe("and a product doesn't exist in the minicart",function(){
        var html;
        beforeEach(function() {
          html = setFixtures("<li class='js-look-product' data-name='Nobuck Alto Olook' data-id='1' class='product' /><input id='total_price' name='total_price' value='' /><div class='cart_related' style='display:block;'><ul class='js-look-products'></ul></div>");
        });

        it("displays the product name in the minicart once",function(){
          new MinicartDataUpdater().facade({productId: "1", productPrice: "2", variantNumber: "3"});
          expect($('.js-minicartItem').length).toEqual(1);
        });

        it("updates the total price",function(){
          expect($('#total_price').val()).toEqual("");
          new MinicartDataUpdater().facade({productId: "1", productPrice: "2", variantNumber: "3"});
          expect($('#total_price').val()).toEqual("2");
        });
      });

      describe("and the same product already exists in the minicart",function(){
        var html;

        it("displays the product name in the minicart once",function(){
          html = setFixtures("<li class='js-look-product' data-name='Nobuck Alto Olook' data-id='1' class='product' /><input id='total_price' name='total_price' value='' /><div class='cart_related' style='display:block;'><ul class='js-look-products'><li class='js-minicartItem' data-name='Nobuck Alto Olook' data-id='1'>Nobuck Alto Olook</li></ul></div>");

          expect($('.js-minicartItem').length).toEqual(1);
          new MinicartDataUpdater().facade({productId: "1", productPrice: "2", variantNumber: "3"});
          expect($('.js-minicartItem').length).toEqual(1);
        });

        it("doesn't update the total price",function(){
          html = setFixtures("<li class='js-look-product' data-name='Nobuck Alto Olook' data-id='1' class='product' /><input id='total_price' name='total_price' value='2' /><div class='cart_related' style='display:block;'><ul class='js-look-products'><li class='js-minicartItem' data-name='Nobuck Alto Olook' data-id='1'>Nobuck Alto Olook</li></ul></div>");
          expect($('#total_price').val()).toEqual("2");
          new MinicartDataUpdater().facade({productId: "1", productPrice: "2", variantNumber: "3"});
          expect($('#total_price').val()).toEqual("2");

        });

      });
    });
    describe("when an item is removed",function(){
      describe("and a product doesn't exist in the minicart",function(){
        var html;
        beforeEach(function() {
          html = setFixtures("<li class='js-look-product' data-name='Nobuck Alto Olook' data-id='1' class='product' /><li data-name='Nobuck Alto Olook 2' data-id='2' class='product' /><input id='total_price' name='total_price' value='2' /><div class='cart_related' style='display:block;'><ul class='js-look-products'><li class='js-minicartItem' data-id='1' data-name='Nobuck Alto Olook'>Nobuck Alto Olook</li></ul></div>");
        });

        it("Doesn't change the minicart item length",function(){
          expect($('.js-minicartItem').length).toEqual(1);
          new MinicartDataUpdater().facade({productId: "2", productPrice: "2", variantNumber: ""});
          expect($('.js-minicartItem').length).toEqual(1);
        });

        it("updates the total price",function(){
          expect($('#total_price').val()).toEqual("2");
          new MinicartDataUpdater().facade({productId: "2", productPrice: "2", variantNumber: ""});
          expect($('#total_price').val()).toEqual("2");
        });
      });

      describe("and a product exists in the minicart",function(){
        var html;
        beforeEach(function() {
          html = setFixtures("<li class='js-look-product' data-name='Nobuck Alto Olook' data-id='1' class='product' /><li data-name='Nobuck Alto Olook 2' data-id='2' class='product' /><input id='total_price' name='total_price' value='2' /><div class='cart_related' style='display:block;'><ul class='js-look-products'><li class='js-minicartItem' data-id='1' data-name='Nobuck Alto Olook'>Nobuck Alto Olook</li></ul></div>");
        });

        it("Doesn't change the minicart item length",function(){
          expect($('.js-minicartItem').length).toEqual(1);
          new MinicartDataUpdater().facade({productId: "1", productPrice: "2", variantNumber: ""});
          expect($('.js-minicartItem').length).toEqual(0);
        });

        it("updates the total price",function(){
          expect($('#total_price').val()).toEqual("2");
          new MinicartDataUpdater().facade({productId: "1", productPrice: "2", variantNumber: ""});
          expect($('#total_price').val()).toEqual("");
        });
      });

    });
  });

});
