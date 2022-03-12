# frozen_string_literal: true

require_relative "lib/mogu/version"

Gem::Specification.new do |spec|
  spec.name          = "mogu"
  spec.version       = Mogu::VERSION
  spec.authors       = %w(MoguraStore)
  spec.email         = %w(368034+lisp719@users.noreply.github.com)

  spec.summary       = "CLI to create rails projects interactively."
  spec.description   = spec.summary
  spec.homepage      = "https://github.com/mogurastore/mogu"
  spec.license       = "MIT"
  spec.required_ruby_version = ">= 2.7.0"

  # spec.metadata["allowed_push_host"] = "TODO: Set to 'https://mygemserver.com'"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = spec.homepage
  # spec.metadata["changelog_uri"] = "TODO: Put your gem's CHANGELOG.md URL here."

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{\A(?:test|spec|features)/}) }
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  # Uncomment to register a new dependency of your gem
  spec.add_dependency "railties", "~> 7.0"
  spec.add_dependency "tty-prompt", "~> 0.23"

  # For more information and examples about making a new gem, checkout our
  # guide at: https://bundler.io/guides/creating_gem.html
end
