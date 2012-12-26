# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = "enumerate_it"
  s.version = "0.7.14"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["C\u{e1}ssio Marques"]
  s.date = "2012-05-02"
  s.description = "Have a legacy database and need some enumerations in your models to match those stupid '4 rows/2 columns' tables with foreign keys and stop doing joins just to fetch a simple description? Or maybe use some integers instead of strings as the code for each value of your enumerations? Here's EnumerateIt."
  s.email = ["cassiommc@gmail.com"]
  s.homepage = "http://github.com/cassiomarques/enumerate_it"
  s.require_paths = ["lib"]
  s.rubygems_version = "1.8.24"
  s.summary = "Ruby Enumerations"

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<activesupport>, [">= 2.3.2"])
      s.add_development_dependency(%q<rake>, [">= 0"])
      s.add_development_dependency(%q<rspec>, [">= 2.5.0"])
      s.add_development_dependency(%q<activerecord>, [">= 3.0.5"])
    else
      s.add_dependency(%q<activesupport>, [">= 2.3.2"])
      s.add_dependency(%q<rake>, [">= 0"])
      s.add_dependency(%q<rspec>, [">= 2.5.0"])
      s.add_dependency(%q<activerecord>, [">= 3.0.5"])
    end
  else
    s.add_dependency(%q<activesupport>, [">= 2.3.2"])
    s.add_dependency(%q<rake>, [">= 0"])
    s.add_dependency(%q<rspec>, [">= 2.5.0"])
    s.add_dependency(%q<activerecord>, [">= 3.0.5"])
  end
end
