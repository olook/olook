describe("ModalShow", function() {
  describe("#config", function() {
    beforeEach(function(){
      olookApp = jasmine.createSpyObj('olookApp', ['subscribe']);
    });
    it("should call subscribe in channel modal:show", function(){
      var obj = new ModalShow();
      obj.config();
      expect(olookApp.subscribe).toHaveBeenCalledWith("modal:show", obj.facade, {}, obj);
    });
  });

  describe("#facade", function() {
    beforeEach(function(){
      olook = jasmine.createSpyObj('olook', ['newModal']);
    });
    it("should call newModal with data params", function(){
      var obj = new ModalShow();
      obj.facade({name: 'sucelson', html: 'yeah', width: 100, height: 200, color: '#fff'});
      expect(olook.newModal).toHaveBeenCalledWith('yeah', 100, 200, '#fff', jasmine.any(Function));
    });
  });


});
