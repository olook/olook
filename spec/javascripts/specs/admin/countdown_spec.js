describe("Countdown", function() {
  describe(".placer", function() {
    it("check if there is a placer", function() {
      loadFixtures("countdown_field");
      new Countdown(".test",40).placer();
      var field = $(".countdown");
      expect(field.length).toEqual(1);
    });
  });
});
