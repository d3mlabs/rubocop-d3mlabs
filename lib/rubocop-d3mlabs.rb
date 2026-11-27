# typed: true
# frozen_string_literal: true

# The gem's entry point, as RuboCop requires it (`plugins: rubocop-d3mlabs`):
# the plugin that hands RuboCop config/default.yml, then the cops.
require "rubocop"

require_relative "rubocop/d3mlabs/plugin"
require_relative "rubocop/cop/d3mlabs/raw_mocha"
