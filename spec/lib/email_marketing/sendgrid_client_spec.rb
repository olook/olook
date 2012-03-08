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

      request.should_receive(:url=).with("https://sendgrid.com/api/invalidemails.get.xml?api_user=olook&api_key=olook123abc")
      EmailMarketing::SendgridClient.new(:invalid_emails)
    end

    it "accepts username as optional parameter" do
      HTTPI::Request.stub(:new).and_return(request)
      HTTPI.stub(:get)

      request.should_receive(:url=).with("https://sendgrid.com/api/invalidemails.get.xml?api_user=anon&api_key=olook123abc")
      EmailMarketing::SendgridClient.new(:invalid_emails, :username => "anon")
    end

    it "accepts password as optional parameter" do
      HTTPI::Request.stub(:new).and_return(request)
      HTTPI.stub(:get)

      request.should_receive(:url=).with("https://sendgrid.com/api/invalidemails.get.xml?api_user=olook&api_key=qwerty")
      EmailMarketing::SendgridClient.new(:invalid_emails, :password => "qwerty")
    end

    it "accepts optional params" do
      HTTPI::Request.stub(:new).and_return(request)
      HTTPI.stub(:get)

      request.should_receive(:url=).with("https://sendgrid.com/api/invalidemails.get.xml?api_user=olook&api_key=qwerty&param_1='value_1'&param_2='value_2'")
      EmailMarketing::SendgridClient.new(:invalid_emails, :password => "qwerty", :param_1 => "value_1", :param_2 => "value_2")
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

    it "supports bounces service" do
      expect { EmailMarketing::SendgridClient.new(:bounces) }.to_not raise_error
    end
  end

  describe "#parsed_response" do
    it "returns XML response body as hash" do
      json_response_body = "<?xml version=\"1.0\" encoding=\"utf-8\"?><invalidemails>" +
                            "<invalidemail><email>rh@planetamalhas.com.br</email><status>500</status><reason>spam</reason></invalidemail>" +
                            "<invalidemail><email>naosalvo@gmail.com</email><test>hello</test></invalidemail></invalidemails>"

      parsed_response = [{"email"=>"rh@planetamalhas.com.br", "status"=>"500", "reason"=>"spam"},
                         {"email"=>"naosalvo@gmail.com", "test" => "hello"}]
      response = double(:response, :body => json_response_body)
      HTTPI.stub(:get).and_return(response)

      subject.parsed_response.should == parsed_response
    end
  end
end