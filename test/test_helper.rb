# typed: true
# frozen_string_literal: true

require "minitest"
require "pathname"

# The repo root: where rubocop.yml, the gemspec, VERSION and the generated
# Gemfile live. Every test reads the real files — the gem is its files.
RUBOCOP_D3MLABS_ROOT = Pathname.new(File.expand_path("..", __dir__))

begin
  require "minitest/reporters"
  Minitest::Reporters.use!
rescue LoadError
  # minitest-reporters not installed
end

Minitest.autorun
