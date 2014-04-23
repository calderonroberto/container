# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = "faye-websocket"
  s.version = "0.7.2"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["James Coglan"]
  s.date = "2013-12-29"
  s.email = "jcoglan@gmail.com"
  s.extra_rdoc_files = ["README.md"]
  s.files = ["README.md"]
  s.homepage = "http://github.com/faye/faye-websocket-ruby"
  s.licenses = ["MIT"]
  s.rdoc_options = ["--main", "README.md", "--markup", "markdown"]
  s.require_paths = ["lib"]
  s.rubygems_version = "1.8.24"
  s.summary = "Standards-compliant WebSocket server and client"

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<eventmachine>, [">= 0.12.0"])
      s.add_runtime_dependency(%q<websocket-driver>, [">= 0.3.1"])
      s.add_development_dependency(%q<progressbar>, [">= 0"])
      s.add_development_dependency(%q<puma>, ["< 2.7.0", ">= 2.0.0"])
      s.add_development_dependency(%q<rack>, [">= 0"])
      s.add_development_dependency(%q<rspec>, [">= 0"])
      s.add_development_dependency(%q<rspec-eventmachine>, [">= 0"])
      s.add_development_dependency(%q<rainbows>, ["~> 4.4.0"])
      s.add_development_dependency(%q<thin>, [">= 1.2.0"])
      s.add_development_dependency(%q<goliath>, [">= 0"])
      s.add_development_dependency(%q<passenger>, [">= 4.0.0"])
    else
      s.add_dependency(%q<eventmachine>, [">= 0.12.0"])
      s.add_dependency(%q<websocket-driver>, [">= 0.3.1"])
      s.add_dependency(%q<progressbar>, [">= 0"])
      s.add_dependency(%q<puma>, ["< 2.7.0", ">= 2.0.0"])
      s.add_dependency(%q<rack>, [">= 0"])
      s.add_dependency(%q<rspec>, [">= 0"])
      s.add_dependency(%q<rspec-eventmachine>, [">= 0"])
      s.add_dependency(%q<rainbows>, ["~> 4.4.0"])
      s.add_dependency(%q<thin>, [">= 1.2.0"])
      s.add_dependency(%q<goliath>, [">= 0"])
      s.add_dependency(%q<passenger>, [">= 4.0.0"])
    end
  else
    s.add_dependency(%q<eventmachine>, [">= 0.12.0"])
    s.add_dependency(%q<websocket-driver>, [">= 0.3.1"])
    s.add_dependency(%q<progressbar>, [">= 0"])
    s.add_dependency(%q<puma>, ["< 2.7.0", ">= 2.0.0"])
    s.add_dependency(%q<rack>, [">= 0"])
    s.add_dependency(%q<rspec>, [">= 0"])
    s.add_dependency(%q<rspec-eventmachine>, [">= 0"])
    s.add_dependency(%q<rainbows>, ["~> 4.4.0"])
    s.add_dependency(%q<thin>, [">= 1.2.0"])
    s.add_dependency(%q<goliath>, [">= 0"])
    s.add_dependency(%q<passenger>, [">= 4.0.0"])
  end
end
