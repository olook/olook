describe("FacebookShare", function() {
  beforeEach(function () {
    loadFixtures("social_share.html");
  });

  describe("#config", function() {
    beforeEach(function(){
      olookApp = jasmine.createSpyObj('olookApp', ['subscribe']);
    });
    it("should call subscribe in channel product:twitter_share", function(){
      var ts = new FacebookShare();
      ts.config();
      expect(olookApp.subscribe).toHaveBeenCalledWith("product:facebook_share", ts.facade, {}, ts);
    });
  });

  describe("#facade", function() {
  });
});

