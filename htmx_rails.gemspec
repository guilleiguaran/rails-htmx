Gem::Specification.new do |s|
  s.name = "htmx_rails"
  s.version = "0.1.0"
  s.author = "Guillermo Iguaran"
  s.email = "guilleiguaran@gmail.com"
  s.summary = "HTMX integration for Rails"
  s.homepage = "https://github.com/guilleiguaran/htmx_rails"
  s.license = "MIT"

  s.files = Dir["lib/**/*.rb"]

  s.add_dependency "railties", ">= 3.0"

  s.add_development_dependency "rake", "~> 13.0"
  s.add_development_dependency "minitest", "~> 5.0"
  s.add_development_dependency "rack-test", "~> 2.1"
  s.add_development_dependency "standard", "~> 1.3"
end
