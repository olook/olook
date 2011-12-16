# -*- encoding : utf-8 -*-

require 'spec_helper'

describe EmailMarketing::SendgridClient do
  subject { EmailMarketing::SendgridClient.new(:invalid_emails) }

  describe  "#initialize" do
    let(:request){ double :request }

    it "creates new HTTPI request" do
      request = mock.as_null_object
      HTTPI.stub(:get)

      HTTPI::Request.should_receive(:new).and_return(request)
      EmailMarketing::SendgridClient.new(:invalid_emails)
    end

    it "sets request url using sendgrid domain, user_key, api_key and service name" do
      HTTPI::Request.stub(:new).and_return(request)
      HTTPI.stub(:get)

      request.should_receive(:url=).with("https://sendgrid.com/api/invalidemails.get.json?api_user=olook&api_key=olook123abc")
      EmailMarketing::SendgridClient.new(:invalid_emails)
    end

    it "makes a get with the created request" do
      HTTPI::Request.stub(:new).and_return(request)
      request.stub(:url=)

      HTTPI.should_receive(:get).with(request)
      EmailMarketing::SendgridClient.new(:invalid_emails)
    end
  end

  describe "suported services" do
    before { HTTPI.stub(:get) }

    it "raises invalid error message if service is not supported" do
      expect {
        EmailMarketing::SendgridClient.new(:unsupported_service)
        }.to raise_error(ArgumentError, "Service unsupported_service is not supported")
    end

    it "supports invalid_emails as a service" do
      expect { EmailMarketing::SendgridClient.new(:invalid_emails) }.to_not raise_error
    end

    it "supports blocks service" do
      expect { EmailMarketing::SendgridClient.new(:blocks) }.to_not raise_error
    end

    it "supports spam reports service" do
      expect { EmailMarketing::SendgridClient.new(:spam_reports) }.to_not raise_error
    end

    it "supports unsubscribes service" do
      expect { EmailMarketing::SendgridClient.new(:unsubscribes) }.to_not raise_error
    end
  end

  describe "#parsed_response" do
    it "returns JSON response body as a ruby hash" do
      json_response_body = "[{\"reason\": \"Known bad domain\", \"email\": \"niceivanice@homail.com\"},{\"reason\":" +
                      "\"Known bad domain\", \"email\": \"william_fi_ude@hotmai.com\"}]"
      parsed_response = [ {"reason"=>"Known bad domain", "email"=>"niceivanice@homail.com"},
                               {"reason"=>"Known bad domain", "email"=>"william_fi_ude@hotmai.com"} ]
      response = double(:response, :body => json_response_body)
      HTTPI.stub(:get).and_return(response)

      subject.parsed_response.should == parsed_response
    end
  end
end