# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :campaign_email do
	  factory :new_campaign_email, :parent => :campaign_email
    email "eu@teste.com"
    after(:build) do |user|
      Resque.stub(:enqueue)
      # Resque.stub(:enqueue_in)
    end    
  end
end
