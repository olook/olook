describe('FloatTotalScrollManager', function() {
  var ftsm;
  beforeEach(function () {
    loadFixtures("float_total_scroll_manager.html");
    ftsm = new FloatTotalScrollManager();
  });

  describe(".updateProperties", function() {
    beforeEach(function(){
      ftsm.updateProperties();
    });
    it('should update elementHeight', function(){
      expect(ftsm.elementHeight).toBeDefined();
    });
    it('should update elementBounding', function(){
      expect(ftsm.elementHeight).toBeDefined();
    });
  });

  describe(".isInsane", function(){
    it('should check if floated is undefined', function() {
      ftsm.floated = undefined;
      expect(ftsm.isInsane()).toBeTruthy();
    });

    it('should check if element is undefined', function() {
      ftsm.element = undefined;
      expect(ftsm.isInsane()).toBeTruthy();
    });
    it('should be falsy otherwise', function() {
      expect(ftsm.isInsane()).toBeFalsy();
    });
  });

  describe('.fade', function() {
    it('expect false when is insane', function(){
      spyOn(ftsm, 'isInsane').andReturn(true);
      expect(ftsm.fade()).toBeFalsy();
    });

    it("expect to set floated display to 'none' when percentage is > 1", function() {
      ftsm.fade(1.1);
      expect(ftsm.floated.style.display).toEqual('none');
    });

    it("expect to set floated display to 'block' when percentage is <= 1", function() {
      ftsm.fade(0.1);
      expect(ftsm.floated.style.display).toEqual('block');
    });

    it("expect to set floated opacity to '1 - percentage' when percentage is <= 1", function() {
      ftsm.fade(0.1);
      expect(ftsm.floated.style.opacity).toEqual('0.9');
    });

    it('expect to be truthy when there is some processing', function() {
      expect(ftsm.fade(1)).toBeTruthy();
    });
  });

  describe(".apply", function() {
    it('expect not processing when is insane', function(){
      spyOn(ftsm, 'isInsane').andReturn(true);
      spyOn(ftsm, 'fade');
      ftsm.apply();
      expect(ftsm.fade).not.toHaveBeenCalled();
    });
  });

});
