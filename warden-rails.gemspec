$:.push File.expand_path("../lib", __FILE__)
require "warden/rails/version"

Gem::Specification.new do |s|
  s.name        = "warden-rails"
  s.version     = Warden::Rails::VERSION
  s.authors     = ["Adrià Planas"]
  s.email       = ["adriaplanas@liquidcodeworks.com"]
  s.summary     = "Thin wrapper around Warden for Rails 3"

  s.files = Dir["lib/**/*"] + ["LICENSE", "Rakefile", "README.md"]
  s.test_files = Dir["test/**/*"]

  s.add_dependency "rails", "~> 3.2.12"
  s.add_dependency "warden", "~> 1.2.1"

  s.add_development_dependency "mocha"
end
