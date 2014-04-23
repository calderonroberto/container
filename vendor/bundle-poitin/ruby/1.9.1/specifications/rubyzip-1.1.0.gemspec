# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = "rubyzip"
  s.version = "1.1.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Alexander Simonov"]
  s.date = "2013-11-01"
  s.email = ["alex@simonov.me"]
  s.homepage = "http://github.com/rubyzip/rubyzip"
  s.require_paths = ["lib"]
  s.required_ruby_version = Gem::Requirement.new(">= 1.9.2")
  s.rubygems_version = "1.8.24"
  s.summary = "rubyzip is a ruby module for reading and writing zip files"

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
    else
    end
  else
  end
end
