# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'backline/version'

Gem::Specification.new do |spec|
  spec.name          = 'backline'
  spec.version       = Backline::VERSION
  spec.authors       = ['Benedikt Deicke']
  spec.email         = ['benedikt@benediktdeicke.com']
  spec.summary       = 'Backline is versioned data storage based on Git.'
  spec.homepage      = 'https://github.com/benedikt/backline'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.add_dependency 'rugged', '~> 0.21'

  spec.add_development_dependency 'bundler', '~> 1.7'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rspec', '~> 3.0'
end
