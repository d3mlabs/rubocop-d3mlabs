# typed: true
# frozen_string_literal: true

require "test_helper"
require "bundler"

# The gemspec is hand-written while dev generates only the Gemfile
# (d3mlabs/dev#71), so the gem's runtime dependencies are declared twice:
# `add_dependency` in the gemspec and the ungrouped `gem` lines of
# dependencies.rb. These tests hold the two together until one of them goes.
transform!(RSpock::AST::Transformation)
class RubocopD3mlabsGemspecTest < Minitest::Test
  SPEC = Gem::Specification.load(RUBOCOP_D3MLABS_ROOT.join("rubocop-d3mlabs.gemspec").to_s)

  test "runtime dependencies match the manifest's ungrouped gems" do
    Given "the gemspec's runtime dependencies"
    runtime = SPEC.runtime_dependencies.map { |dep| [dep.name, dep.requirement.to_s] }.sort

    When "the generated Gemfile — dev's rendering of dependencies.rb — is read for its ungrouped gems"
    gemfile = Bundler::Dsl.evaluate(RUBOCOP_D3MLABS_ROOT.join("Gemfile"), nil, {})
    exported = gemfile.dependencies
      .select { |dep| dep.groups == [:default] }
      .map { |dep| [dep.name, dep.requirement.to_s] }
      .sort

    Then "the same gems at the same requirements"
    runtime == exported
  end

  test "ships exactly the files it names, and they exist" do
    Expect "every listed file is in the checkout"
    SPEC.files.all? { |file| RUBOCOP_D3MLABS_ROOT.join(file).file? }
    SPEC.files.include?("rubocop.yml")
    SPEC.files.include?("VERSION")
  end

  test "reads its version from VERSION" do
    Expect "the one place `dev release` bumps"
    SPEC.version.to_s == RUBOCOP_D3MLABS_ROOT.join("VERSION").read.strip
  end
end
