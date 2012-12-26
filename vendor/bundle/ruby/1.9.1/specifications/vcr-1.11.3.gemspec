# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = "vcr"
  s.version = "1.11.3"

  s.required_rubygems_version = Gem::Requirement.new(">= 1.3.5") if s.respond_to? :required_rubygems_version=
  s.authors = ["Myron Marston"]
  s.date = "2011-09-01"
  s.description = "VCR provides a simple API to record and replay your test suite's HTTP interactions.  It works with a variety of HTTP client libraries, HTTP stubbing libraries and testing frameworks."
  s.email = "myron.marston@gmail.com"
  s.homepage = "http://github.com/myronmarston/vcr"
  s.require_paths = ["lib"]
  s.required_ruby_version = Gem::Requirement.new(">= 1.8.6")
  s.rubygems_version = "1.8.24"
  s.summary = "Record your test suite's HTTP interactions and replay them during future test runs for fast, deterministic, accurate tests."

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_development_dependency(%q<faraday>, ["~> 0.7.2"])
      s.add_development_dependency(%q<fakeweb>, ["~> 1.3.0"])
      s.add_development_dependency(%q<httpclient>, ["~> 2.1.5.2"])
      s.add_development_dependency(%q<rake>, ["~> 0.9.2"])
      s.add_development_dependency(%q<timecop>, ["~> 0.3.5"])
      s.add_development_dependency(%q<addressable>, ["~> 2.2.6"])
      s.add_development_dependency(%q<shoulda>, ["~> 2.9.2"])
      s.add_development_dependency(%q<rspec>, ["~> 2.6"])
      s.add_development_dependency(%q<rack>, ["= 1.1.0"])
      s.add_development_dependency(%q<sinatra>, ["~> 1.1.0"])
      s.add_development_dependency(%q<bundler>, ["~> 1.0.7"])
      s.add_development_dependency(%q<excon>, ["~> 0.6.5"])
      s.add_development_dependency(%q<webmock>, ["~> 1.7.4"])
      s.add_development_dependency(%q<aruba>, ["~> 0.4.6"])
      s.add_development_dependency(%q<cucumber>, ["~> 1.0.2"])
      s.add_development_dependency(%q<curb>, ["~> 0.7.15"])
      s.add_development_dependency(%q<patron>, ["~> 0.4.15"])
      s.add_development_dependency(%q<em-http-request>, ["~> 0.3.0"])
      s.add_development_dependency(%q<typhoeus>, ["~> 0.2.1"])
    else
      s.add_dependency(%q<faraday>, ["~> 0.7.2"])
      s.add_dependency(%q<fakeweb>, ["~> 1.3.0"])
      s.add_dependency(%q<httpclient>, ["~> 2.1.5.2"])
      s.add_dependency(%q<rake>, ["~> 0.9.2"])
      s.add_dependency(%q<timecop>, ["~> 0.3.5"])
      s.add_dependency(%q<addressable>, ["~> 2.2.6"])
      s.add_dependency(%q<shoulda>, ["~> 2.9.2"])
      s.add_dependency(%q<rspec>, ["~> 2.6"])
      s.add_dependency(%q<rack>, ["= 1.1.0"])
      s.add_dependency(%q<sinatra>, ["~> 1.1.0"])
      s.add_dependency(%q<bundler>, ["~> 1.0.7"])
      s.add_dependency(%q<excon>, ["~> 0.6.5"])
      s.add_dependency(%q<webmock>, ["~> 1.7.4"])
      s.add_dependency(%q<aruba>, ["~> 0.4.6"])
      s.add_dependency(%q<cucumber>, ["~> 1.0.2"])
      s.add_dependency(%q<curb>, ["~> 0.7.15"])
      s.add_dependency(%q<patron>, ["~> 0.4.15"])
      s.add_dependency(%q<em-http-request>, ["~> 0.3.0"])
      s.add_dependency(%q<typhoeus>, ["~> 0.2.1"])
    end
  else
    s.add_dependency(%q<faraday>, ["~> 0.7.2"])
    s.add_dependency(%q<fakeweb>, ["~> 1.3.0"])
    s.add_dependency(%q<httpclient>, ["~> 2.1.5.2"])
    s.add_dependency(%q<rake>, ["~> 0.9.2"])
    s.add_dependency(%q<timecop>, ["~> 0.3.5"])
    s.add_dependency(%q<addressable>, ["~> 2.2.6"])
    s.add_dependency(%q<shoulda>, ["~> 2.9.2"])
    s.add_dependency(%q<rspec>, ["~> 2.6"])
    s.add_dependency(%q<rack>, ["= 1.1.0"])
    s.add_dependency(%q<sinatra>, ["~> 1.1.0"])
    s.add_dependency(%q<bundler>, ["~> 1.0.7"])
    s.add_dependency(%q<excon>, ["~> 0.6.5"])
    s.add_dependency(%q<webmock>, ["~> 1.7.4"])
    s.add_dependency(%q<aruba>, ["~> 0.4.6"])
    s.add_dependency(%q<cucumber>, ["~> 1.0.2"])
    s.add_dependency(%q<curb>, ["~> 0.7.15"])
    s.add_dependency(%q<patron>, ["~> 0.4.15"])
    s.add_dependency(%q<em-http-request>, ["~> 0.3.0"])
    s.add_dependency(%q<typhoeus>, ["~> 0.2.1"])
  end
end
