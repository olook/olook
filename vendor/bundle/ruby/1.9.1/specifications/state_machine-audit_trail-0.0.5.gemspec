# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = "state_machine-audit_trail"
  s.version = "0.0.5"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Willem van Bergen", "Jesse Storimer"]
  s.date = "2011-07-27"
  s.description = "Log transitions on a state machine to support auditing and business process analytics."
  s.email = ["willem@shopify.com", "jesse@shopify.com"]
  s.homepage = "https://github.com/wvanbergen/state_machine-audit_trail"
  s.require_paths = ["lib"]
  s.rubyforge_project = "state_machine"
  s.rubygems_version = "1.8.24"
  s.summary = "Log transitions on a state machine to support auditing and business process analytics."

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<state_machine>, [">= 0"])
      s.add_development_dependency(%q<rake>, [">= 0"])
      s.add_development_dependency(%q<rspec>, ["~> 2"])
      s.add_development_dependency(%q<activerecord>, ["~> 3"])
      s.add_development_dependency(%q<sqlite3>, [">= 0"])
    else
      s.add_dependency(%q<state_machine>, [">= 0"])
      s.add_dependency(%q<rake>, [">= 0"])
      s.add_dependency(%q<rspec>, ["~> 2"])
      s.add_dependency(%q<activerecord>, ["~> 3"])
      s.add_dependency(%q<sqlite3>, [">= 0"])
    end
  else
    s.add_dependency(%q<state_machine>, [">= 0"])
    s.add_dependency(%q<rake>, [">= 0"])
    s.add_dependency(%q<rspec>, ["~> 2"])
    s.add_dependency(%q<activerecord>, ["~> 3"])
    s.add_dependency(%q<sqlite3>, [">= 0"])
  end
end
