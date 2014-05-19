# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'vundle_cli/version'

Gem::Specification.new do |spec|
  spec.name          = "vundle-cli"
  spec.version       = VundleCli::VERSION
  spec.authors       = ["Bao Pham"]
  spec.email         = ["gbaopham@gmail.com"]
  spec.summary       = %q{A tiny CLI for Vim plugin manager Vundle}
  spec.description   = %q{Available commands: rm, list, find, clean to remove, list, find installed plugins and clean up unused plugins}
  spec.homepage      = "https://github.com/baopham/vundle-cli"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.5"
  spec.add_development_dependency "rake", "~> 0.8"
  spec.add_dependency "commander", "~> 4.2"
end
