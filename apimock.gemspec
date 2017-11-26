# coding: utf-8
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "apimock/version"

Gem::Specification.new do |spec|
  spec.name          = "apimock"
  spec.version       = Apimock::VERSION
  spec.authors       = ["Dave Nicolette"]
  spec.email         = ["davenicolette@gmail.com"]

  spec.summary       = %q{Simple mocking facility for API testing}
  spec.description   = %q{Provides specified output for RESTful API invocations}
  spec.homepage      = "http://github.com/neopragma/apimock"
  spec.license       = "MIT"

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  if spec.respond_to?(:metadata)
    spec.metadata["allowed_push_host"] = "http://rubygems.org"
  else
    raise "RubyGems 2.0 or newer is required to protect against " \
      "public gem pushes."
  end

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "json", ">=2.1.0"
  spec.add_dependency "sinatra", ">=2.0.0"
  spec.add_dependency "xml-simple", ">=1.1.5"
  
  spec.add_development_dependency "bundler", "~> 1.15"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_development_dependency "cucumber", "~> 3.0"
  spec.add_development_dependency "rest-client", "~> 2.0"
end
