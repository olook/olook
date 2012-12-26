# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = "resque-scheduler"
  s.version = "2.0.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 1.3.6") if s.respond_to? :required_rubygems_version=
  s.authors = ["Ben VandenBos"]
  s.date = "2012-05-04"
  s.description = "Light weight job scheduling on top of Resque.\n    Adds methods enqueue_at/enqueue_in to schedule jobs in the future.\n    Also supports queueing jobs on a fixed, cron-like schedule."
  s.email = ["bvandenbos@gmail.com"]
  s.homepage = "http://github.com/bvandenbos/resque-scheduler"
  s.require_paths = ["lib"]
  s.rubygems_version = "1.8.24"
  s.summary = "Light weight job scheduling on top of Resque"

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_development_dependency(%q<bundler>, [">= 1.0.0"])
      s.add_runtime_dependency(%q<redis>, [">= 2.0.1"])
      s.add_runtime_dependency(%q<resque>, [">= 1.20.0"])
      s.add_runtime_dependency(%q<rufus-scheduler>, [">= 0"])
    else
      s.add_dependency(%q<bundler>, [">= 1.0.0"])
      s.add_dependency(%q<redis>, [">= 2.0.1"])
      s.add_dependency(%q<resque>, [">= 1.20.0"])
      s.add_dependency(%q<rufus-scheduler>, [">= 0"])
    end
  else
    s.add_dependency(%q<bundler>, [">= 1.0.0"])
    s.add_dependency(%q<redis>, [">= 2.0.1"])
    s.add_dependency(%q<resque>, [">= 1.20.0"])
    s.add_dependency(%q<rufus-scheduler>, [">= 0"])
  end
end
