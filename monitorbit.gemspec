# frozen_string_literal: true

lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'monitorbit/version'

Gem::Specification.new do |spec|
  spec.name          = 'monitorbit'
  spec.version       = Monitorbit::VERSION
  spec.authors       = ['dyachenko-yaroslav']
  spec.email         = ['mrthefoton@gmail.com']

  spec.summary       = 'Performance monitoring tool'
  spec.description   = "Tool for monitoring application's processess state"
  # spec.homepage      = "git@git.git"
  spec.license       = 'MIT'

  # spec.metadata["allowed_push_host"] = "TODO: Set to 'http://mygemserver.com'"

  # spec.metadata["homepage_uri"] = spec.homepage
  # spec.metadata["source_code_uri"] = "TODO: Put your gem's public repo URL here."
  # spec.metadata["changelog_uri"] = "TODO: Put your gem's CHANGELOG.md URL here."

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files         = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features|example_app|docker_compose_config)/}) }
  end
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_dependency 'prometheus-client'
  spec.add_dependency 'yabeda-prometheus'
  spec.add_dependency 'yabeda-puma-plugin'
  spec.add_dependency 'yabeda-rails'
  spec.add_dependency 'yabeda-sidekiq'

  spec.add_development_dependency 'bundler', '~> 2.0.0'
  spec.add_development_dependency 'bundler-audit'
  spec.add_development_dependency 'overcommit'
  spec.add_development_dependency 'reek'
  spec.add_development_dependency 'rspec'
  spec.add_development_dependency 'rubocop'
  spec.add_development_dependency 'rubocop-rspec'
  spec.add_development_dependency 'simplecov'
end
