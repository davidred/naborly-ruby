lib = File.expand_path("lib", __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "naborly/ruby/version"

Gem::Specification.new do |spec|
  spec.name          = "naborly-ruby"
  spec.version       = Naborly::Ruby::VERSION
  spec.authors       = ["David Rozenberg"]
  spec.email         = ["daveroze@gmail.com"]

  spec.summary       = %q{A library for communicating with the Naborly REST API}
  spec.homepage      = "https://github.com/davidred/naborly-ruby"
  spec.license       = "MIT"

  spec.metadata["allowed_push_host"] = "TODO: Set to 'http://mygemserver.com'"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/davidred/weimark"
  spec.metadata["changelog_uri"] = "https://github.com/davidred/weimark"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 2.0"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.2"
  spec.add_development_dependency "pry", "~> 0.12"
  spec.add_development_dependency "vcr", "~> 4.0"
  spec.add_development_dependency "webmock", "~> 3.5"

  spec.add_dependency "httparty", "~> 0.17"
  spec.add_dependency "oj", "~> 3.8"
  spec.add_dependency "activesupport", ">= 1.2", "<= 5.2"
end
