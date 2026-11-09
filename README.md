# rubocop-d3mlabs

d3mlabs' RuboCop configuration: [Shopify's style guide](https://github.com/Shopify/ruby-style-guide) plus the org's rules, shipped as a gem the way `rubocop-shopify` is. The payload is one file, [`rubocop.yml`](rubocop.yml); there are no cops of its own.

## Use

```ruby
# Gemfile (or dependencies.rb, for a dev-managed repo)
gem "rubocop-d3mlabs", require: false
```

```yaml
# .rubocop.yml
inherit_gem:
  rubocop-d3mlabs: rubocop.yml
```

`rubocop-shopify` and `rubocop-sorbet` arrive as its dependencies; a consumer declares neither. Keep only repo-local facts in your own `.rubocop.yml` — excluded paths, `Sorbet/StrictSigil`'s include set and holdouts. A rule every d3mlabs Ruby repo should follow belongs in this gem.

## What it adds over rubocop-shopify

| Cop | Setting | Why |
| --- | --- | --- |
| `Style/EndlessMethod` | `disallow` | A method is `def` / body / `end`; the endless form reads as an assignment and splits the code into two spellings. |
| `Sorbet/ValidSigil` | `RequireSigilOnAllFiles: true` | Every Ruby file declares a `typed:` sigil; how strict is each repo's call. |
| `AllCops` | `SuggestExtensions: false` | — |
| `Lint/Void`, `Lint/BinaryOperatorWithIdenticalOperands` | `Exclude: test/**/*` | Tests are in the [RSpock](https://github.com/rspockframework/rspock) dialect: bare comparisons and block-name constants are rewritten into assertions, not evaluated. |

## Development

A [dev](https://github.com/d3mlabs/dev) project: `dev up` installs the toolchain and gems from `dependencies.rb`, `dev test` runs the suite (the config is loaded through RuboCop's own loader and asserted), `dev style` lints the repo with the config it ships.

Releasing is `dev release [<version>]` — bumps `VERSION`, tags, pushes, and attaches `rubocop-d3mlabs-<version>.gem` to the GitHub release — after which [`release.yml`](.github/workflows/release.yml) publishes that exact asset to rubygems.org as a [trusted publisher](https://guides.rubygems.org/trusted-publishing/) via `dev deploy rubygems --release <version>`.

## License

MIT.
