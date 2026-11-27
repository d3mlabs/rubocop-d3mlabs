# rubocop-d3mlabs

d3mlabs' RuboCop configuration: [Shopify's style guide](https://github.com/Shopify/ruby-style-guide) plus the org's rules and cops, shipped as a gem the way `rubocop-shopify` is. The configuration is one file, [`rubocop.yml`](rubocop.yml); the cops live under `lib/rubocop/cop/d3mlabs/` with their defaults in [`config/default.yml`](config/default.yml), and `rubocop.yml` loads them as a RuboCop plugin.

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

`rubocop-shopify` and `rubocop-sorbet` arrive as its dependencies, and the org's cops load with the config; a consumer declares none of them. Keep only repo-local facts in your own `.rubocop.yml` — excluded paths, `Sorbet/StrictSigil`'s include set and holdouts. A rule every d3mlabs Ruby repo should follow belongs in this gem.

## What it adds over rubocop-shopify

| Cop | Setting | Why |
| --- | --- | --- |
| `Style/EndlessMethod` | `disallow` | A method is `def` / body / `end`; the endless form reads as an assignment and splits the code into two spellings. |
| `Sorbet/ValidSigil` | `RequireSigilOnAllFiles: true` | Every Ruby file declares a `typed:` sigil; how strict is each repo's call. |
| `AllCops` | `SuggestExtensions: false` | — |
| `Lint/Void`, `Lint/BinaryOperatorWithIdenticalOperands` | `Exclude: test/**/*` | Tests are in the [RSpock](https://github.com/rspockframework/rspock) dialect: bare comparisons and block-name constants are rewritten into assertions, not evaluated. |

## The org's cops

| Cop | Flags | Why |
| --- | --- | --- |
| `D3mlabs/RawMocha` | In `test/**/*`: mocha's `stubs`, `expects`, `any_instance`, `stub_everything`, and a double built with answers (`stub(body: …)`, `mock(run: …)`). Not a bare `mock` or `typed_mock(Type)`, nor RSpock's matchers. | A test states what the class sent its collaborators as RSpock interactions (`n * recv.msg(args) >> value`) and hands the class those collaborators; it does not reach into it. A site that must — an order of calls RSpock does not express — says why: `# rubocop:disable D3mlabs/RawMocha -- <why>`. |

## Development

A [dev](https://github.com/d3mlabs/dev) project: `dev up` installs the toolchain and gems from `dependencies.rb`, `dev test` runs the suite (the config is loaded through RuboCop's own loader and asserted; each cop is run over sources it must and must not flag), `dev style` lints the repo with the config and cops it ships (the cops from `lib/`, which `dev style` puts on the load path — the checkout is not a gem in its own bundle).

Releasing is `dev release [<version>]` — bumps `VERSION`, tags, pushes, and attaches `rubocop-d3mlabs-<version>.gem` to the GitHub release — after which [`dev-publish-rubygems.yml`](.github/workflows/dev-publish-rubygems.yml), the publish workflow dev ships, publishes that exact asset to rubygems.org as a [trusted publisher](https://guides.rubygems.org/trusted-publishing/) via `dev deploy rubygems --release <version>`.

## License

MIT.
