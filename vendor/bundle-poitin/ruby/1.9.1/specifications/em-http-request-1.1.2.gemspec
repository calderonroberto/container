# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = "em-http-request"
  s.version = "1.1.2"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Ilya Grigorik"]
  s.date = "2013-12-20"
  s.description = "EventMachine based, async HTTP Request client"
  s.email = ["ilya@igvita.com"]
  s.homepage = "http://github.com/igrigorik/em-http-request"
  s.licenses = ["MIT"]
  s.require_paths = ["lib"]
  s.rubyforge_project = "em-http-request"
  s.rubygems_version = "1.8.24"
  s.summary = "EventMachine based, async HTTP Request client"

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<addressable>, [">= 2.3.4"])
      s.add_runtime_dependency(%q<cookiejar>, [">= 0"])
      s.add_runtime_dependency(%q<em-socksify>, [">= 0.3"])
      s.add_runtime_dependency(%q<eventmachine>, [">= 1.0.3"])
      s.add_runtime_dependency(%q<http_parser.rb>, [">= 0.6.0"])
      s.add_development_dependency(%q<mongrel>, ["~> 1.2.0.pre2"])
      s.add_development_dependency(%q<multi_json>, [">= 0"])
      s.add_development_dependency(%q<rack>, [">= 0"])
      s.add_development_dependency(%q<rake>, [">= 0"])
      s.add_development_dependency(%q<rspec>, [">= 0"])
    else
      s.add_dependency(%q<addressable>, [">= 2.3.4"])
      s.add_dependency(%q<cookiejar>, [">= 0"])
      s.add_dependency(%q<em-socksify>, [">= 0.3"])
      s.add_dependency(%q<eventmachine>, [">= 1.0.3"])
      s.add_dependency(%q<http_parser.rb>, [">= 0.6.0"])
      s.add_dependency(%q<mongrel>, ["~> 1.2.0.pre2"])
      s.add_dependency(%q<multi_json>, [">= 0"])
      s.add_dependency(%q<rack>, [">= 0"])
      s.add_dependency(%q<rake>, [">= 0"])
      s.add_dependency(%q<rspec>, [">= 0"])
    end
  else
    s.add_dependency(%q<addressable>, [">= 2.3.4"])
    s.add_dependency(%q<cookiejar>, [">= 0"])
    s.add_dependency(%q<em-socksify>, [">= 0.3"])
    s.add_dependency(%q<eventmachine>, [">= 1.0.3"])
    s.add_dependency(%q<http_parser.rb>, [">= 0.6.0"])
    s.add_dependency(%q<mongrel>, ["~> 1.2.0.pre2"])
    s.add_dependency(%q<multi_json>, [">= 0"])
    s.add_dependency(%q<rack>, [">= 0"])
    s.add_dependency(%q<rake>, [">= 0"])
    s.add_dependency(%q<rspec>, [">= 0"])
  end
end
