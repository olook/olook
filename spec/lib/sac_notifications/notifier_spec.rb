describe SAC::Notifier do
  
  let(:notification) {double(SAC::Notification)}

  context "given that an event exists" do
    it "should only send notification if it is active" do
      notification.should_receive(:initialize_triggers)
      notification.stub(:active?).and_return(true)
      Resque.should_receive(:enqueue).with(SAC::AlertWorker, notification)
      described_class.notify(notification)
    end

    it "should not send a notification if is not active" do
      notification.should_receive(:initialize_triggers)
      notification.stub(:active?).and_return(false)
      Resque.should_not_receive(:enqueue).with(SAC::AlertWorker, notification)
      described_class.notify(notification)
    end
  end
end