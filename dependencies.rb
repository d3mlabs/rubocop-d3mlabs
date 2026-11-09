# typed: false
# frozen_string_literal: true

# Dependency manifest for dev: the exact Ruby toolchain plus the gem set.
# dev generates Gemfile/Gemfile.lock from these declarations — edit here,
# then run `dev deps update` (re-lock) and `dev up` (install). CI installs
# with `dev deps install`.
require "dev/deps"

Dev::Deps.define do
  ruby "4.0.6"

  # Runtime — the gem's own dependencies, mirrored in rubocop-d3mlabs.gemspec
  # until dev renders the gemspec (d3mlabs/dev#71). Declaring them here is
  # also what contributes the `deploy rubygems` channel: the lock reaches the
  # bundler integration, whose write side is rubygems.org.
  gem "rubocop-shopify", "~> 3.0"
  gem "rubocop-sorbet", "~> 0.10"

  group(:test) do
    gem "minitest"
    gem "minitest-reporters"
    gem "rake"
    gem "rspock", "~> 3.0"
  end
end
