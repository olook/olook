describe("ModalRequest", function() {
  describe("#facade", function(){
    var selector;
    beforeEach(function(){
      selector = {
        get:function(){},
        done:function(){},
        fail:function(){},
      };
      spyOn(selector, 'get').andReturn(selector);
      spyOn(selector, 'done').andReturn(selector);
      spyOn(selector, 'fail').andReturn(selector);
    });

    it("should call get on /modal", function(){
      var obj = new ModalRequest(selector);
      obj.facade('pathfromcaller');
      expect(selector.get).toHaveBeenCalledWith('/modal', {path: 'pathfromcaller'});
    });

  });
});
