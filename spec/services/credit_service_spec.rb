# -*- encoding : utf-8 -*-
describe CreditService do

  let(:admin) {Factory :admin_superadministrator}
  let(:user)  {Factory :user}
  let(:service) {mock 'service'}
  
  subject{described_class.new(service)}


  it "should load credit.yml file" do
    File.exists?("#{Rails.root.to_s}/config/credit.yml").should be_true
  end

  it "should be initialized with a service specialization" do
    subject.service.should_not be_nil
  end

  context "when creating a transaction" do
      before(:each) do
        subject.service = AdminCreditService.new(admin)
      end
    context "if service responds to an operation" do
      it "should return true if transaction completes" do
        subject.create_transaction("10", :add_credit, "Presente", user).should be_true
      end

      it "should return false if transaction aborts" do
        subject.create_transaction("1000", :remove_credit, "Presente", user).should be_false
      end

    end
    context "if service does not respond to an operation" do
      it "should return false" do
        subject.create_transaction("1000", :foo, "Presente", user).should be_false
      end
    end
  end

end