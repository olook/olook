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
      expect(mockMediator.publish).toHaveBeenCalledWith('topic name', []);
    });

    it("accept two or more arguments", function() {
      app.publish('topic name', 'param1', 'param2');
      expect(mockMediator.publish).toHaveBeenCalledWith('topic name', ['param1', 'param2']);
    });
        
  });

  describe("#subscribe", function() {
    var nullChannel = null;
    var nullNameChannel = {name: null};
    var nullFacadeMethodChannel = {name: "a", facade: null};
    var channel = {name: "channelName", facade: "channelFacade"};

    it("returns an exception when channel is null", function() {
      expect(app.subscribe.bind(null, nullChannel)).toThrow("channel is required");
    });

    it("returns an exception when channel name is null", function() {
      expect(app.subscribe.bind(null, nullNameChannel)).toThrow("channel name is required");
    });

    it("returns an exception when channel facade method is null", function() {
      expect(app.subscribe.bind(null, nullFacadeMethodChannel)).toThrow("channel facade method is required");
    });

    it("calls the mediator subscribe method when the channel is being passed properly", function() {
      app.subscribe(channel);
      expect(mockMediator.subscribe).toHaveBeenCalledWith(channel.name, channel.facade);
    });      
  });

});