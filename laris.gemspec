# coding: utf-8
$: << File.expand_path("../lib", __FILE__)
require 'laris'

Gem::Specification.new do |spec|
  spec.name          = "laris"
  spec.version       = Laris::VERSION
  spec.authors       = ["Daniel Colson"]
  spec.email         = ["danieljamescolson@gmail.com"]

  spec.summary       = %q{Lightweight MVC framework}
  spec.description   = %q{Laris is a rails-inspired web application framework.}
  spec.homepage      = "https://github.com/composerinteralia/laris"
  spec.license       = "MIT"

  spec.files         = Dir["README.md", "lib/**/*"]
  spec.require_path = "lib"

  spec.add_development_dependency "bundler", "~> 1.13"
  spec.add_development_dependency "rake", "~> 10.0"

  spec.add_dependency 'activesupport'
  spec.add_dependency 'pg'
  spec.add_dependency 'rack'
end
