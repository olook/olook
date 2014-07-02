describe("FacebookShare", function() {
  beforeEach(function () {
    loadFixtures("social_share.html");
  });

  describe("#config", function() {
    beforeEach(function(){
      olookApp = jasmine.createSpyObj('olookApp', ['subscribe']);
    });
    it("should call subscribe in channel product:twitter_share", function(){
      var ts = new FacebookShare(jQuery);
      ts.config();
      expect(olookApp.subscribe).toHaveBeenCalledWith("product:facebook_share", ts.facade, {}, ts, "FacebookShare");
    });
  });


  describe("#facade", function() {
    var ts;
    beforeEach(function(){
      ts = new FacebookShare(jQuery);
      ts.config();
      olookApp = jasmine.createSpyObj('olookApp', ['publish']);
    });
    describe("when the class is clicked", function() {
      it("must publish to facebook_share channel",function(){
        $('.js-facebook_share').click();
        expect(olookApp.publish).toHaveBeenCalledWith("product:facebook_share");
      });
    });
  });
});

