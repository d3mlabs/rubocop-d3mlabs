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

  # The two declarations are in different grammars — the gemspec is
  # rubygems' (`~> 3.0`), dependencies.rb is semver's, which dev renders
  # into the Gemfile as comparators (`>= 3.0.0, < 4.0.0`) — so they are
  # compared as the bounds they mean: `~> v` is `>= v, < v.bump`.
  def bounds(requirement)
    requirement.requirements.flat_map do |op, version|
      op == "~>" ? [[">=", version], ["<", version.bump]] : [[op, version]]
    end.sort_by { |op, version| [op, version] }
  end

  test "runtime dependencies match the manifest's ungrouped gems" do
    Given "the gemspec's runtime dependencies"
    runtime = SPEC.runtime_dependencies.map { |dep| [dep.name, bounds(dep.requirement)] }.sort

    When "the generated Gemfile — dev's rendering of dependencies.rb — is read for its ungrouped gems"
    gemfile = Bundler::Dsl.evaluate(RUBOCOP_D3MLABS_ROOT.join("Gemfile"), nil, {})
    exported = gemfile.dependencies
      .select { |dep| dep.groups == [:default] }
      .map { |dep| [dep.name, bounds(dep.requirement)] }
      .sort

    Then "the same gems, bounded the same"
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
