describe("TwitterShare", function() {
  beforeEach(function () {
    loadFixtures("social_share.html");
  });

  describe("#config", function() {
    beforeEach(function(){
      olookApp = jasmine.createSpyObj('olookApp', ['subscribe']);
    });
    it("should call subscribe in channel product:twitter_share", function(){
      var ts = new TwitterShare(jQuery);
      ts.config();
      expect(olookApp.subscribe).toHaveBeenCalledWith("product:twitter_share", ts.facade, {}, ts);
    });
  });

  describe("#facade", function() {
    var ts;
    beforeEach(function(){
      ts = new TwitterShare(jQuery);
      ts.config();
      olookApp = jasmine.createSpyObj('olookApp', ['publish']);
    });
    describe("when the class is clicked", function() {
      it("must publish to twitter_share channel",function(){
        $('.js-twitter_share').click();
        expect(olookApp.publish).toHaveBeenCalledWith("product:twitter_share", 575,400);
      });
    });
  });
});
