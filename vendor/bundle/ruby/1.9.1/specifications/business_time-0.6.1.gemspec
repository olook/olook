# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = "business_time"
  s.version = "0.6.1"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["bokmann"]
  s.date = "2012-04-12"
  s.description = "Have you ever wanted to do things like \"6.business_days.from_now\" and have weekends and holidays taken into account?  Now you can."
  s.email = "dbock@codesherpas.com"
  s.homepage = "http://github.com/bokmann/business_time"
  s.require_paths = ["lib"]
  s.rubygems_version = "1.8.24"
  s.summary = "Support for doing time math in business hours and days"

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<activesupport>, [">= 3.1.0"])
      s.add_runtime_dependency(%q<tzinfo>, ["~> 0.3.31"])
      s.add_development_dependency(%q<rake>, [">= 0.9.2"])
      s.add_development_dependency(%q<shoulda>, [">= 0"])
      s.add_development_dependency(%q<rdoc>, [">= 0"])
    else
      s.add_dependency(%q<activesupport>, [">= 3.1.0"])
      s.add_dependency(%q<tzinfo>, ["~> 0.3.31"])
      s.add_dependency(%q<rake>, [">= 0.9.2"])
      s.add_dependency(%q<shoulda>, [">= 0"])
      s.add_dependency(%q<rdoc>, [">= 0"])
    end
  else
    s.add_dependency(%q<activesupport>, [">= 3.1.0"])
    s.add_dependency(%q<tzinfo>, ["~> 0.3.31"])
    s.add_dependency(%q<rake>, [">= 0.9.2"])
    s.add_dependency(%q<shoulda>, [">= 0"])
    s.add_dependency(%q<rdoc>, [">= 0"])
  end
end
