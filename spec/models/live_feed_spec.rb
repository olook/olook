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
  end


end
