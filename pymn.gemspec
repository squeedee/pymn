# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'pymn/version'

Gem::Specification.new do |gem|
  gem.name          = "pymn"
  gem.version       = Pymn::VERSION
  gem.authors       = ["Rasheed Abdul-Aziz"]
  gem.email         = ["squeedee@gmail.com"]
  gem.description   = %q{Sometimes, there are Patterns You May Need.}
  gem.summary       = %q{Sometimes, there are Patterns You May Need.}
  gem.homepage      = "https://github.com/pymn"

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]

  gem.add_dependency "activesupport"

  gem.add_development_dependency "bundler"
  gem.add_development_dependency "pry"
  gem.add_development_dependency "rspec"

end
