# encoding: utf-8

$:.unshift File.expand_path('../lib', __FILE__)
require 'wpns/version'

Gem::Specification.new do |s|
  s.name         = "wpns"
  s.version      = Wpns::VERSION
  s.authors      = ["Tim Felgentreff"]
  s.email        = "timfelgentreff@gmail.com"
  s.homepage     = "https://github.com/timfel/wpns"
  s.summary      = "[summary]"
  s.description  = "[description]"

  s.files        = `git ls-files app lib`.split("\n")
  s.platform     = Gem::Platform::RUBY
  s.require_path = 'lib'
  s.rubyforge_project = '[none]'
end
