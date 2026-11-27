# typed: true
# frozen_string_literal: true

require "test_helper"
require "rubocop"
require "rubocop-d3mlabs"

# The cop's own rule, source by source: mocha's stubbing and expecting
# API, and a double built with answers, are offenses; RSpock's interaction
# grammar, matchers and a bare double are not.
transform!(RSpock::AST::Transformation)
class RubocopD3mlabsRawMochaTest < Minitest::Test
  COP_NAME = "D3mlabs/RawMocha"

  def offenses(source)
    config = RuboCop::Config.new({ COP_NAME => { "Enabled" => true } }, "/.rubocop.yml")
    cop = RuboCop::Cop::D3mlabs::RawMocha.new(config)
    processed = RuboCop::ProcessedSource.new(source, RUBY_VERSION.to_f, "test/example_test.rb")
    RuboCop::Cop::Commissioner.new([cop], [], raise_error: true).investigate(processed).offenses
  end

  test "flags #{what}" do
    Expect "one offense, named for the cop, on the mocha call"
    found = offenses(source)
    found.size == 1
    found.first.cop_name == COP_NAME
    found.first.location.source == call

    Where
    what                                       | source                                                       | call
    "stubs on an object"                       | %(engine.stubs(:run).returns(true))                          | "stubs"
    "stubs on a constant"                      | %(Open3.stubs(:capture3).returns(["", "", status]))          | "stubs"
    "stubs with a hash of answers"             | %(ui.stubs(print_header: nil, print_footer: nil))            | "stubs"
    "expects on an object"                     | %(client.expects(:ensure_service!).with(TAG).once)           | "expects"
    "expects on a constant"                    | %(Kernel.expects(:exit).with(0).once)                        | "expects"
    "any_instance"                             | %(resolver = Dev::Deps::Resolver.any_instance)               | "any_instance"
    "a double built with answers"              | %(response = stub(body: "{}", code: "200"))                  | "stub"
    "a mock built with answers"                | %(client = mock(ensure_service!: TAG))                       | "mock"
    "stub_everything"                          | %(ui = stub_everything)                                      | "stub_everything"
  end

  test "flags each mocha send in a chain, once each" do
    Given "any_instance followed by expects"
    found = offenses(%(Dev::Credentials.any_instance.expects(:load).returns(creds)))

    Expect "two offenses, each on its own selector; the chained `returns` is not a third"
    found.map { |offense| offense.location.source }.sort == ["any_instance", "expects"]
  end

  test "leaves #{what} alone" do
    Expect "no offense"
    offenses(source).empty?

    Where
    what                                              | source
    "an RSpock interaction with cardinality"          | %(1 * engine.run(["start", name]) >> true)
    "an RSpock interaction with wildcard cardinality" | %(_ * ui.print_header)
    "an RSpock interaction with a matcher"            | %(1 * Kernel.exec(has_entries("RUBYLIB" => anything), "sh", "-c", includes("./bin/build.sh")))
    "a bare double"                                   | %(engine = mock)
    "a typed double"                                  | %(engine = typed_mock(Dev::ContainerEngine))
    "a stub with a receiver (not mocha's)"            | %(Dev::Platform.stub(:os, "linux") { run })
    "a method named stubs on a user object"           | %(registry.stubs_for(:bundler))
    "the word in a string"                            | %(hint = "Dev::ShadowenvRuby.stubs(:converge!)")
  end
end
