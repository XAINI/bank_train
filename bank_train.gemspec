# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'bank_train/version'

Gem::Specification.new do |spec|
  spec.name          = "bank_train"
  spec.version       = BankTrain::VERSION
  spec.authors       = ["ben7th"]
  spec.email         = ["ben7th@sina.com"]
  spec.summary       = ""
  spec.description   = ""
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.7"
  spec.add_development_dependency "rake", "~> 10.0"

  # 以下为 rails engine 依赖
  spec.add_development_dependency 'actionpack', '~> 4.2.0'
  spec.add_development_dependency 'activesupport', '~> 4.2.0'

  spec.add_development_dependency 'jquery-rails', '>= 3.1.0'
  spec.add_development_dependency 'uglifier'

  spec.add_dependency 'mongoid-tree', '~> 2.0.0'
  spec.add_dependency 'react-rails', '~> 1.0'
  spec.add_dependency 'sprockets-coffee-react'
end
