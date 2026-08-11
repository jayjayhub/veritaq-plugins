# Veritaq Plugins

A Claude Code plugin marketplace. Each plugin packages a profession's or a company's working practice into skills someone can install and use the same day.

## Plugins

| Plugin | Vertical | Version | What it does |
|---|---|---|---|
| [`tax-accountant-in-a-box`](professionals/tax-accountants/plugins/tax-accountant-in-a-box/) | Tax accountants | 1.0.0 | Runs a small tax practice end to end: onboarding, engagement planning, document chasing, figure extraction, deadline tracking. Ships configured for Malaysia |

## Install

**Internal**, with repo access:

```
/plugin marketplace add <org>/veritaq-plugins
/plugin install tax-accountant-in-a-box@veritaq
```

**Clients** get a built bundle instead. See [`docs/distribution.md`](docs/distribution.md).

## Layout

```
.claude-plugin/marketplace.json   the ONE marketplace for this repo
professionals/<profession>/       a vertical
  └── plugins/<plugin-name>/      the shippable unit, and the only thing that ships
  └── testbed/                    a simulated practice for testing
  └── marketing/                  deck and diagrams
companies/<company>/              same shape, for company-specific work
tools/                            shared across verticals
docs/                             authoring, testing, distribution
```

A vertical holds a plugin plus everything that supports it. Only the plugin directory ships.

## Tools

| Tool | Does |
|---|---|
| `tools/check-plugin.sh` | Structure and marketplace consistency for every plugin, plus each plugin's own invariants |
| `tools/build-client-bundle.ps1` / `.sh` | Builds a client zip with a generated marketplace, so versions cannot drift |
| `tools/mock-calendar-mcp/` | A local calendar MCP server, so calendar skills can be tested without OAuth |

```bash
tools/check-plugin.sh          # check everything
```

## Docs

| For | Read |
|---|---|
| Adding a plugin or vertical | [`docs/authoring-a-plugin.md`](docs/authoring-a-plugin.md) |
| Shipping internally or to a client | [`docs/distribution.md`](docs/distribution.md) |
| Testbeds and mock servers | [`docs/testing.md`](docs/testing.md) |
| A specific plugin's architecture | that plugin's `DESIGN.md` |

## Status

Private. These are paying client deliverables. `tax-accountant-in-a-box` has not yet been tested against real client documents; its known weaknesses are listed honestly in its [`DESIGN.md`](professionals/tax-accountants/plugins/tax-accountant-in-a-box/DESIGN.md#known-weaknesses).
