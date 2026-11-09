# typed: true
# frozen_string_literal: true

require "test_helper"
require "rubocop"

# rubocop.yml is the gem. A consumer resolves it through `inherit_gem`, so
# the assertions go through RuboCop's own loader — the same resolution path
# — rather than reading the YAML: a typo that YAML accepts but RuboCop
# ignores would otherwise silently drop the layer in every repo.
transform!(RSpock::AST::Transformation)
class RubocopD3mlabsConfigTest < Minitest::Test
  CONFIG = RuboCop::ConfigLoader.load_file(RUBOCOP_D3MLABS_ROOT.join("rubocop.yml").to_s)

  test "forbids endless method definitions" do
    Expect "the org rule the gem exists for"
    CONFIG.for_cop("Style/EndlessMethod")["EnforcedStyle"] == "disallow"
    CONFIG.for_cop("Style/EndlessMethod")["Enabled"] == true
  end

  test "requires a typed sigil on every file" do
    Expect "rubocop-sorbet's ValidSigil, tightened"
    CONFIG.for_cop("Sorbet/ValidSigil")["RequireSigilOnAllFiles"] == true
    CONFIG.for_cop("Sorbet/ValidSigil")["Enabled"] == true
  end

  test "keeps RSpock's rewritten test statements out of Lint/Void and identical-operand checks" do
    Expect "both cops exclude the test tree"
    CONFIG.for_cop("Lint/Void")["Exclude"].any? { |path| path.end_with?("test/**/*") }
    CONFIG.for_cop("Lint/BinaryOperatorWithIdenticalOperands")["Exclude"].any? { |path| path.end_with?("test/**/*") }
  end

  test "layers on rubocop-shopify" do
    Expect "a value only Shopify's config sets is reachable through the chain"
    CONFIG.for_cop("Style/MethodCallWithArgsParentheses")["AllowedMethods"].include?("require")
    CONFIG.for_all_cops["StyleGuideBaseURL"] == "https://shopify.github.io/ruby-style-guide/"
  end

  test "does not suggest extensions" do
    Expect "SuggestExtensions is off"
    CONFIG.for_all_cops["SuggestExtensions"] == false
  end
end
