# frozen_string_literal: true

Gem::Specification.new do |spec|
  spec.name          = "rubocop-d3mlabs"
  # `dev release` bumps VERSION; nothing else in the repo carries the version.
  spec.version       = File.read(File.expand_path("VERSION", __dir__)).strip
  spec.authors       = ["Jean-Philippe Duchesne"]
  spec.email         = ["jpduchesne89@gmail.com"]

  spec.summary       = "d3mlabs' RuboCop configuration: rubocop-shopify plus the org's rules and cops."
  spec.description   = "One rubocop.yml every d3mlabs Ruby repo inherits (`inherit_gem: rubocop-d3mlabs: rubocop.yml`): " \
    "Shopify's style guide, rubocop-sorbet, the org's own rules on top, and the org's cops (D3mlabs/RawMocha)."
  spec.homepage      = "https://github.com/d3mlabs/rubocop-d3mlabs"
  spec.license       = "MIT"
  spec.required_ruby_version = ">= 3.3"

  spec.metadata = {
    "source_code_uri" => spec.homepage,
    "changelog_uri" => "#{spec.homepage}/blob/main/CHANGELOG.md",
    "rubygems_mfa_required" => "true",
    # How RuboCop finds the plugin from `plugins: rubocop-d3mlabs`.
    "default_lint_roller_plugin" => "RuboCop::D3mlabs::Plugin",
  }

  # The config, and the cops with their defaults.
  spec.files = ["rubocop.yml", "VERSION", "README.md", "LICENSE.txt", "CHANGELOG.md"] +
    Dir.glob("{lib,config}/**/*", base: __dir__).select { |file| File.file?(File.join(__dir__, file)) }
  spec.require_paths = ["lib"]

  # Development and test dependencies live in dependencies.rb (the generated
  # Gemfile), per Gemspec/DevelopmentDependencies.

  # Runtime dependencies — mirrored by the ungrouped `gem` lines of
  # dependencies.rb until dev renders this file (d3mlabs/dev#71);
  # test/rubocop_d3mlabs/gemspec_test.rb asserts the two agree.
  spec.add_dependency("rubocop", ">= 1.72")
  spec.add_dependency("rubocop-shopify", "~> 3.0")
  spec.add_dependency("rubocop-sorbet", "~> 0.10")
end
