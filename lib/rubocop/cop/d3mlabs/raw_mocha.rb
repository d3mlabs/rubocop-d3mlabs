# typed: true
# frozen_string_literal: true

module RuboCop
  module Cop
    module D3mlabs
      # Tests state what a class sent its collaborators as RSpock
      # interactions — `n * recv.msg(args) >> value` — and hand the class
      # those collaborators; they do not reach into it with mocha. This cop
      # flags mocha's own API in a test: `stubs`, `expects`, `any_instance`,
      # `stub_everything`, and a double built with answers (`stub(body: …)`,
      # `mock(run: …)`), which fakes the value a collaborator returns rather
      # than stating the message it was sent.
      #
      # A bare `mock`, or `typed_mock(Type)`, is how an interaction's
      # receiver comes to exist and is not an offense; neither are RSpock's
      # argument matchers (`anything`, `has_entries`, `includes`, …).
      #
      # A site that has to stay — an order of calls RSpock does not express
      # — carries a disable directive for this cop with the reason after
      # `--`, as rubocop.yml spells it.
      #
      # @example
      #   # bad
      #   engine.expects(:run).with(["start", name]).once.returns(true)
      #   Open3.stubs(:capture3).returns(["", "", status])
      #   response = stub(body: "{}", code: "200")
      #
      #   # good
      #   1 * engine.run(["start", name]) >> true
      #   1 * shell.capture3("gh", "api", path) >> ["", "", status]
      #   response = http_response(status: 200, body: "{}")
      class RawMocha < Base
        MSG = "Mocha in a test. State the interaction — `n * recv.msg(args) >> value` — and give the class " \
          "its collaborator; what cannot be stays with `# rubocop:disable D3mlabs/RawMocha -- <why>`."

        # mocha's stubbing and expecting API, on any receiver.
        STUBBING = %i[stubs expects any_instance stub_everything].freeze
        # mocha's double constructors, an offense when given answers.
        DOUBLES = %i[stub mock].freeze

        RESTRICT_ON_SEND = (STUBBING + DOUBLES).freeze

        def on_send(node)
          return unless raw_mocha?(node)

          add_offense(node.loc.selector)
        end

        private

        def raw_mocha?(node)
          return true if STUBBING.include?(node.method_name)

          node.receiver.nil? && node.arguments?
        end
      end
    end
  end
end
