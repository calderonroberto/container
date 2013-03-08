# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = "cookiejar"
  s.version = "0.3.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["David Waite"]
  s.date = "2010-06-13"
  s.description = "Allows for parsing and returning cookies in Ruby HTTP client code"
  s.email = "david@alkaline-solutions.com"
  s.homepage = "http://alkaline-solutions.com"
  s.rdoc_options = ["--title", "CookieJar -- Client-side HTTP Cookies"]
  s.require_paths = ["lib"]
  s.rubygems_version = "1.8.24"
  s.summary = "Client-side HTTP Cookie library"

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
    else
    end
  else
  end
end
