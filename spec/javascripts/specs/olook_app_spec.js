describe("Olook APP", function() {
  
  function DummyMediator() {
    var _topicName;
    var _parameters;
    return {
      publish: function(topicName, parameters) {
        _topicName = topicName
        _parameters = parameters
      },
      topicName: function() {return _topicName},
      parameters: function() {return _parameters}
    }
  }

  app = new OlookApp(new DummyMediator());


  describe("#publish", function() {

    it("fails if there is no arguments", function() {
      expect(app.publish).toThrow();
    });

    it("accept one argument", function() {
      app.publish('topic name');
      expect(app.mediator.topicName()).toEqual('topic name');
    });

    it("accept two or more arguments", function() {
      app.publish('topic name', 'param1', 'param2');

      expect(app.mediator.topicName()).toEqual('topic name');
      expect(app.mediator.parameters()).toEqual(['param1', 'param2']);
    });
        
  });

  describe("#subscribe", function() {
    it("Tarefa pro luis", function() {
      expect(false).toBeTruthy();
    });
  });



});