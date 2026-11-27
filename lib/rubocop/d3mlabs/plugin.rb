# typed: true
# frozen_string_literal: true

require "lint_roller"
require "pathname"

module RuboCop
  module D3mlabs
    # The gem as RuboCop's plugin system sees it: where the cops' default
    # configuration is. RuboCop finds this class two ways — the gemspec's
    # `default_lint_roller_plugin` metadata when the gem is installed, and
    # the `plugin_class_name` rubocop.yml names, which also serves a
    # checkout of this repo, where no gem is installed.
    class Plugin < LintRoller::Plugin
      ROOT = Pathname.new(__dir__).join("../../..").expand_path.freeze

      def about
        LintRoller::About.new(
          name: "rubocop-d3mlabs",
          version: ROOT.join("VERSION").read.strip,
          homepage: "https://github.com/d3mlabs/rubocop-d3mlabs",
          description: "d3mlabs' RuboCop configuration and cops.",
        )
      end

      def supported?(context)
        context.engine == :rubocop
      end

      def rules(_context)
        LintRoller::Rules.new(type: :path, config_format: :rubocop, value: ROOT.join("config", "default.yml"))
      end
    end
  end
end
