require 'spec_helper'

describe LiveFeed do

  subject {LiveFeed.new}

  context ".validations" do
    it {should validate_presence_of :firstname}
    it {should validate_presence_of :birthdate}
    
    it {should validate_presence_of(:email)}
    it {should validate_uniqueness_of :email}

    it {should validate_presence_of :ip}
    it {should validate_presence_of :question}

    it {should validate_presence_of :gender}
    it {should ensure_inclusion_of(:gender).in_array(['m', 'g'])}

    context "all valid fields" do
      subject {LiveFeed.new({
        firstname: 'teste', 
        birthdate: '10/10/1980', 
        email: 'teste@oloo.com.br', 
        ip: '100.100.100.100', 
        question: '3', 
        gender: 'm'})}

      describe "when the email is already registered in newsletter" do
        before(:each) do
          subject.stub(newsletter: CampaignEmail.new)
        end

        it {should_not be_valid}
      end

      describe "when the email is new" do
        it {should be_valid}
      end

      describe "when the email is already registered in user's tables" do
        before(:each) do
          subject.stub(user: User.new)
        end

        it {should_not be_valid}
      end
    end
  end


end
