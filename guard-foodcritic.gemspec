# -*- encoding: utf-8 -*-
require File.expand_path('../lib/guard/foodcritic/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Chris Griego"]
  gem.email         = ["cgriego@gmail.com"]
  gem.description   = %q{Guard::Foodcritic automatically runs foodcritic.}
  gem.summary       = %q{Guard::Foodcritic automatically runs foodcritic.}
  gem.homepage      = "https://github.com/cgriego/guard-foodcritic"

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map { |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "guard-foodcritic"
  gem.require_paths = ["lib"]
  gem.version       = Guard::FOODCRITIC_VERSION

  gem.add_runtime_dependency "guard", ">= 1.0", "< 3.0"
  gem.add_runtime_dependency "foodcritic", ">= 1.3", "< 5.0"

  gem.add_development_dependency "bundler", "~> 1.0"
  gem.add_development_dependency "rake", "~> 10.0"
  gem.add_development_dependency "rspec", "~> 2.10"
end
