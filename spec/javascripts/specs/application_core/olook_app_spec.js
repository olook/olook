describe("Olook APP", function() {

  var app;
  var mockMediator;

  beforeEach(function() {
    mockMediator = jasmine.createSpyObj('Mediator', ['publish', 'subscribe']);
    app = new OlookApp(mockMediator);
  });


  describe("#publish", function() {

    it("fails if there is no arguments", function() {
      expect(app.publish).toThrow("channel name is required");
    });

    it("accept one argument", function() {
      app.publish('topic name');
      expect(mockMediator.publish).toHaveBeenCalledWith('topic name');
    });

    it("accept two or more arguments", function() {
      app.publish('topic name', 'param1', 'param2');
      expect(mockMediator.publish).toHaveBeenCalledWith('topic name', 'param1', 'param2');
    });

  });

  describe("#subscribe", function() {
    it("returns an exception when channel is null", function() {
      expect(function(){ app.subscribe() }).toThrow("channel name is required");
    });

    it("returns an exception when channel name is null", function() {
      expect(function(){ app.subscribe("a") }).toThrow("channel facade method is required");
    });

    it("calls the mediator subscribe method when the channel name and callback method are being passed properly", function() {
      var a = function(){};
      app.subscribe("a", a);
      expect(mockMediator.subscribe).toHaveBeenCalledWith("a", a, null, null);
    });

    it("calls the mediator subscribe method when the channel, callback method and options are being passed properly", function() {
      var a = function(){};
      var hash = { name: 'acasafd' };
      app.subscribe("a", a, hash);
      expect(mockMediator.subscribe).toHaveBeenCalledWith("a", a, hash, null);
    });
  });

});
