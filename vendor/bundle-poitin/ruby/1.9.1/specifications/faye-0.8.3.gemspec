# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = "faye"
  s.version = "0.8.3"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["James Coglan"]
  s.date = "2012-07-15"
  s.email = "jcoglan@gmail.com"
  s.extra_rdoc_files = ["README.rdoc"]
  s.files = ["README.rdoc"]
  s.homepage = "http://faye.jcoglan.com"
  s.rdoc_options = ["--main", "README.rdoc"]
  s.require_paths = ["lib"]
  s.rubygems_version = "1.8.24"
  s.summary = "Simple pub/sub messaging for the web"

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<cookiejar>, [">= 0.3.0"])
      s.add_runtime_dependency(%q<em-http-request>, [">= 0.3.0"])
      s.add_runtime_dependency(%q<eventmachine>, [">= 0.12.0"])
      s.add_runtime_dependency(%q<faye-websocket>, [">= 0.4.0"])
      s.add_runtime_dependency(%q<rack>, [">= 1.0.0"])
      s.add_runtime_dependency(%q<yajl-ruby>, [">= 1.0.0"])
      s.add_development_dependency(%q<compass>, ["~> 0.10.0"])
      s.add_development_dependency(%q<jake>, [">= 1.1.1"])
      s.add_development_dependency(%q<rake>, [">= 0"])
      s.add_development_dependency(%q<rspec>, ["~> 2.8.0"])
      s.add_development_dependency(%q<rack-proxy>, [">= 0"])
      s.add_development_dependency(%q<rack-test>, [">= 0"])
      s.add_development_dependency(%q<rainbows>, [">= 1.0.0"])
      s.add_development_dependency(%q<RedCloth>, ["~> 3.0.0"])
      s.add_development_dependency(%q<sinatra>, [">= 0"])
      s.add_development_dependency(%q<staticmatic>, [">= 0"])
      s.add_development_dependency(%q<thin>, [">= 1.2.0"])
    else
      s.add_dependency(%q<cookiejar>, [">= 0.3.0"])
      s.add_dependency(%q<em-http-request>, [">= 0.3.0"])
      s.add_dependency(%q<eventmachine>, [">= 0.12.0"])
      s.add_dependency(%q<faye-websocket>, [">= 0.4.0"])
      s.add_dependency(%q<rack>, [">= 1.0.0"])
      s.add_dependency(%q<yajl-ruby>, [">= 1.0.0"])
      s.add_dependency(%q<compass>, ["~> 0.10.0"])
      s.add_dependency(%q<jake>, [">= 1.1.1"])
      s.add_dependency(%q<rake>, [">= 0"])
      s.add_dependency(%q<rspec>, ["~> 2.8.0"])
      s.add_dependency(%q<rack-proxy>, [">= 0"])
      s.add_dependency(%q<rack-test>, [">= 0"])
      s.add_dependency(%q<rainbows>, [">= 1.0.0"])
      s.add_dependency(%q<RedCloth>, ["~> 3.0.0"])
      s.add_dependency(%q<sinatra>, [">= 0"])
      s.add_dependency(%q<staticmatic>, [">= 0"])
      s.add_dependency(%q<thin>, [">= 1.2.0"])
    end
  else
    s.add_dependency(%q<cookiejar>, [">= 0.3.0"])
    s.add_dependency(%q<em-http-request>, [">= 0.3.0"])
    s.add_dependency(%q<eventmachine>, [">= 0.12.0"])
    s.add_dependency(%q<faye-websocket>, [">= 0.4.0"])
    s.add_dependency(%q<rack>, [">= 1.0.0"])
    s.add_dependency(%q<yajl-ruby>, [">= 1.0.0"])
    s.add_dependency(%q<compass>, ["~> 0.10.0"])
    s.add_dependency(%q<jake>, [">= 1.1.1"])
    s.add_dependency(%q<rake>, [">= 0"])
    s.add_dependency(%q<rspec>, ["~> 2.8.0"])
    s.add_dependency(%q<rack-proxy>, [">= 0"])
    s.add_dependency(%q<rack-test>, [">= 0"])
    s.add_dependency(%q<rainbows>, [">= 1.0.0"])
    s.add_dependency(%q<RedCloth>, ["~> 3.0.0"])
    s.add_dependency(%q<sinatra>, [">= 0"])
    s.add_dependency(%q<staticmatic>, [">= 0"])
    s.add_dependency(%q<thin>, [">= 1.2.0"])
  end
end
