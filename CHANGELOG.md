# Changelog
All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]
### Added
- `D3mlabs/RawMocha`, the gem's first cop, on by default over `test/**/*`: mocha's `stubs`, `expects`, `any_instance`, `stub_everything` and doubles built with answers are offenses; a test states interactions in RSpock and injects collaborators ([plans#86](https://github.com/d3mlabs/plans/issues/86)). The cops load through RuboCop's plugin system (`RuboCop::D3mlabs::Plugin`, defaults in `config/default.yml`), which `rubocop.yml` declares — a consumer changes nothing.

### Changed
- `rubocop >= 1.72` is a declared dependency (the plugin system).

## [1.0.0] - 2026-11-09
### Added
- `rubocop.yml`: inherits `rubocop-shopify`, loads `rubocop-sorbet`, and layers the org's rules — `Style/EndlessMethod: disallow`, `Sorbet/ValidSigil: RequireSigilOnAllFiles`, `AllCops: SuggestExtensions: false`, and the RSpock-dialect exclusions of `test/**/*` from `Lint/Void` and `Lint/BinaryOperatorWithIdenticalOperands`.
