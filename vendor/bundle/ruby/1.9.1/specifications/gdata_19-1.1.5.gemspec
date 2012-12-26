# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = "gdata_19"
  s.version = "1.1.5"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Jeff Fisher"]
  s.date = "2012-04-05"
  s.description = "Ruby 1.9.x compatible Google GData gem makes it easy to work with the Google Data APIs"
  s.email = "jfisher@youtube.com"
  s.executables = ["test_captcha.rb"]
  s.extra_rdoc_files = ["LICENSE", "README.mdown"]
  s.files = ["bin/test_captcha.rb", "LICENSE", "README.mdown"]
  s.homepage = "http://github.com/tokumine/GData"
  s.require_paths = ["lib"]
  s.rubygems_version = "1.8.24"
  s.summary = "Google Data APIs Ruby Utility Library"

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
    else
    end
  else
  end
end
