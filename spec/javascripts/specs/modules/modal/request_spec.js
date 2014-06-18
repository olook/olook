describe("ModalRequest", function() {
  describe("#facade", function(){
    beforeEach(function(){
      $ = {
        get:function(){},
        done:function(){},
        fail:function(){},
      };
      spyOn($, 'get').andReturn($);
      spyOn($, 'done').andReturn($);
      spyOn($, 'fail').andReturn($);
    });

    afterEach(function(){
      $ = jQuery;
    });    

    it("should call get on /modal", function(){
      var obj = new ModalRequest();
      obj.facade('pathfromcaller');
      expect($.get).toHaveBeenCalledWith('/modal', {path: 'pathfromcaller'});
    });

  });
});
