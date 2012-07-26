describe SAC::Notification do 
  
  subject do 
    sac_notification = SAC::Notification.new(:fraud_analysis, 'Hail to the King', 'order')
  end

  its(:type) {should == :fraud_analysis}
  its(:subject){should == 'Hail to the King'}
  its(:active) {should be_true}
  its(:settings) {should == SAC::Notification::SETTINGS}
  its(:triggers) {should == SAC::Notification::CONFIG['fraud_analysis']['triggers']}
  its(:subscribers) {should == SAC::Notification::CONFIG['fraud_analysis']['subscribers']}
  its(:order) {should == 'order'}

  context "given a valid configuration file and a set of rules" do    
    it "should process or not a rule depending on its state" do
      subject.triggers.each do |trigger, state|
        until subject.active == true
          if state == true
            subject.should_receive("validate_#{trigger}")
          elsif state == false
            subject.should_not_receive("validate_#{trigger}")
          end
        end
      end
    end
  end

  context "when validating a business day" do
    it "should return true if a weekday" do
      Date.stub(:today).and_return(Date.parse('2012-07-23'))
      subject.validate_business_days.should == true
    end

    it "should return false if a weekend" do
      Date.stub(:today).and_return(Date.parse('2012-07-22'))
      subject.validate_business_days.should == false
    end
  end
  
  context "when validating business hours" do
    it "should return true if current time between business working hours" do
      start_time = Time.parse(subject.settings['beginning_working_hour'])
      Time.stub(:now).and_return(start_time + (60*60))
      subject.validate_business_hours.should == true
    end

    it "should return false if current time is not between business working hours" do
      start_time = Time.parse(subject.settings['beginning_working_hour'])
      Time.stub(:now).and_return(start_time - (60*60))
      subject.validate_business_hours.should == false
    end
  end

  context "when validating the total of an order" do
    it "should return true if total is equal or higher than threshold" do
      subject.order.stub_chain(:total_with_freight, :to_f).and_return(subject.settings['purchase_amount_threshold'])
      subject.validate_purchase_amount.should == true
    end

    it "should return false if total is below the threshold" do
      subject.order.stub_chain(:total_with_freight, :to_f).and_return(subject.settings['purchase_amount_threshold'] - 1)
      subject.validate_purchase_amount.should == false
    end
  end

  context "when validating discount" do
    it "should return true if total discount is equal or higher than threshold percentage" do
      subject.order.stub_chain(:line_items, :collect, :inject).and_return(100)
      subject.order.should_receive(:total).and_return(subject.settings['total_discount_threshold_percent'])
      subject.validate_discount.should == true
    end

    it "should return false if total discount is below the threshold percentage" do
      subject.order.stub_chain(:line_items, :collect, :inject).and_return(100)
      subject.order.should_receive(:total).and_return(subject.settings['total_discount_threshold_percent'] - 1)
      subject.validate_discount.should == false
    end
  end

end