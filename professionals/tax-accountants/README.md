# Veritaq Plugins

A Claude Code plugin marketplace. Currently carries one plugin.

## Plugins

### `tax-accountant-in-a-box`

Runs a small tax practice end to end: onboards clients, plans engagements, chases missing documents, extracts figures from source documents into workpapers, and keeps filing deadlines in a calendar.

Ships configured for **Malaysia**. The jurisdiction pack is a single file, so supporting another country means writing one reference pack rather than touching any skill.

Six skills: `practice-setup`, `client-intake`, `client-engagement-plan`, `client-document-chase`, `source-to-workpaper`, `client-deadline-calendar`.

→ [`plugins/tax-accountant-in-a-box/`](plugins/tax-accountant-in-a-box/)

## Install

```
/plugin marketplace add <org>/veritaq-plugins
/plugin install tax-accountant-in-a-box@veritaq
```

Then, in the desktop app, say **"set up my practice"**.

## Documentation

| For | Read |
|---|---|
| The accountant installing it | [`docs/setup-guide.md`](plugins/tax-accountant-in-a-box/docs/setup-guide.md) |
| The accountant using it | [`docs/user-guide.md`](plugins/tax-accountant-in-a-box/docs/user-guide.md) |
| Their desk, first fortnight | [`docs/quick-reference.md`](plugins/tax-accountant-in-a-box/docs/quick-reference.md) |
| Whoever maintains or ports it | [`DESIGN.md`](plugins/tax-accountant-in-a-box/DESIGN.md) |
| Whoever distributes it | [`docs/packaging-and-install.md`](plugins/tax-accountant-in-a-box/docs/packaging-and-install.md) |
| Working on this repo | [`DEVELOPMENT.md`](DEVELOPMENT.md) |

## Repo layout

```
plugins/    the shippable plugin. Nothing else ships
testbed/    a simulated practice with three clients and real fixture documents
tools/      a mock calendar MCP server, so the deadline skill can be tested without OAuth
marketing/  deck and workflow diagrams
```

Run the testbed with `claude --plugin-dir ./plugins/tax-accountant-in-a-box`, then `cd testbed`. See [`DEVELOPMENT.md`](DEVELOPMENT.md).

## Status

`0.1.0`. Not yet tested against real client documents. Known weaknesses are listed honestly in [`DESIGN.md`](plugins/tax-accountant-in-a-box/DESIGN.md#known-weaknesses).
