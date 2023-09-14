Gem::Specification.new do |s|
  s.name = "rails-htmx"
  s.version = "0.1.3"
  s.author = "Guillermo Iguaran"
  s.email = "guilleiguaran@gmail.com"
  s.summary = "htmx integration for Rails"
  s.homepage = "https://github.com/guilleiguaran/rails-htmx"
  s.license = "MIT"

  s.files = Dir["lib/**/*.rb"]

  s.add_dependency "railties", ">= 5.2"

  s.add_development_dependency "rake", "~> 13.0"
  s.add_development_dependency "minitest", "~> 5.0"
  s.add_development_dependency "rack-test", "~> 2.1"
  s.add_development_dependency "standard", "~> 1.3"
end
