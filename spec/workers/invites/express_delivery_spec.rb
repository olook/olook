# -*- encoding : utf-8 -*-
require 'spec_helper'

describe Invites::ExpressDelivery do
  it "should be set to send_invites queue" do
    described_class.instance_variable_get(:'@queue').should == :send_invites
  end
  
  before :all do
    FileUtils.rm_rf(described_class.base_directory)
  end

  let(:directory_name) { Rails.root.join('tmp', 'send_invites', 'test', 'invites_201110271002') }
  
  it 'should generate directory names based on the current hour' do
    Time.stub(:now).and_return(Time.parse('2011-10-27 10:02:03'))
    described_class.directory_name.should == directory_name
  end

  it 'should generate a base diretory' do
    described_class.base_directory.should == Rails.root.join('tmp', 'send_invites', 'test')
    Dir.should exist(described_class.base_directory)
  end

  context "when generating invites" do
    let(:jane) { FactoryGirl.create(:member, :first_name => 'Jane', :email => 'jane@mail.com') }
    let(:mary) { FactoryGirl.create(:member, :first_name => 'Mary', :email => 'mary@mail.com') }
    let(:invite_from_jane) { FactoryGirl.create(:invite, :user => jane, :email => 'katy@mail.com') }
    let(:invite_from_mary) { FactoryGirl.create(:invite, :user => mary, :email => 'paty@mail.com') }
  
    it "should generate 3 txt files and 1 zip" do
      described_class.stub(:directory_name).and_return(directory_name)

      File.should_not exist("#{directory_name}.zip")

      described_class.should_receive(:send_file_via_ftp)

      described_class.perform([invite_from_jane.id, invite_from_mary.id])

      File.should exist("#{directory_name}/campanha.txt")
      File.should exist("#{directory_name}/html.txt")
      File.should exist("#{directory_name}/email.txt")
      File.should exist("#{directory_name}.zip")
    end
  end
end
