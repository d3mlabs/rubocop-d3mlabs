# Changelog
All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.0.0] - 2026-11-09
### Added
- `rubocop.yml`: inherits `rubocop-shopify`, loads `rubocop-sorbet`, and layers the org's rules — `Style/EndlessMethod: disallow`, `Sorbet/ValidSigil: RequireSigilOnAllFiles`, `AllCops: SuggestExtensions: false`, and the RSpock-dialect exclusions of `test/**/*` from `Lint/Void` and `Lint/BinaryOperatorWithIdenticalOperands`.
