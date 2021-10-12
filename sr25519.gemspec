# frozen_string_literal: true

require_relative "lib/sr25519/version"

Gem::Specification.new do |spec|
  spec.name          = "sr25519"
  spec.version       = Sr25519::VERSION
  spec.authors       = ["xuxh"]
  spec.email         = ["xxh2611@gmail.com"]

  spec.summary       = "Ruby Sr25519"
  spec.description   = "Sign and verify message with sr25519"
  spec.homepage      = "https://github.com/uni-arts-chain/sr25519"
  spec.license       = "MIT"
  spec.required_ruby_version = Gem::Requirement.new(">= 2.7.0")

  spec.metadata["allowed_push_host"] = "https://rubygems.org"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/uni-arts-chain/sr25519"
  spec.metadata["changelog_uri"] = "https://github.com/uni-arts-chain/sr25519"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{\A(?:test|spec|features)/}) }
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "rake", "~> 13.0"
  spec.add_development_dependency "rspec", "~> 3.2"
  spec.add_dependency "blake2b"
  spec.add_dependency "base58"
  spec.add_development_dependency "ffi", "~> 1.15.0"
  spec.add_dependency "ed25519", '~> 1.2', '>= 1.2.4'
end
