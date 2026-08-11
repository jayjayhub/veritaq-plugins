# Veritaq Plugins — repo context

A monorepo of Claude Code plugins sold to clients, and one marketplace that distributes them.

> ## If a practice or client `CLAUDE.md` is also loaded, follow that one
>
> Running a testbed means you are **simulating being that professional's assistant**. In that situation the practice config is in charge, and everything below about repo maintenance does not apply. Do not mention the repo, the plugin, or that this is a test unless asked.
>
> This file matters when the work is *building* plugins. It should be ignored when the work is *using* one.

---

## Layout

```
veritaq-plugins/
├── .claude-plugin/marketplace.json   ← the ONE marketplace. Verticals are not marketplaces
├── professionals/<profession>/       ← a vertical
│   └── plugins/<plugin-name>/        ← the shippable unit
├── companies/<company>/              ← same shape, for company-specific work
├── tools/                            ← shared across every vertical
└── docs/                             ← how to author, test and distribute
```

**A vertical is not a plugin.** It holds a plugin plus the things that support it and must never ship: `testbed/`, vertical-specific `tools/`, `marketing/`.

**Shared tooling lives at the repo root.** Anything a second vertical would also want goes in root `tools/`. Only genuinely vertical-specific tooling stays local.

## Rules that apply to every plugin here

1. **The directory named in marketplace `source` must be the one holding `.claude-plugin/plugin.json`.** Most breakage traces back to this.
2. **Plugin directory name = `plugin.json` name = marketplace entry name.** All three, identical.
3. **Only `plugin.json` goes inside `.claude-plugin/`.** `skills/` and everything else sit at the plugin root. Putting `skills/` inside `.claude-plugin/` makes the plugin load as empty.
4. **Every plugin has a `version`.** Without one, clients never receive updates.
5. **Nothing that cannot ship may live inside a plugin directory.** No testbed, tooling, marketing or `dist`.
6. **Skills hold logic, not content.** Domain facts belong in a swappable reference pack; user preferences belong in a config file the user owns. A skill that names a country or a preference is a portability bug.
7. **Anything that writes shows a plan first** and waits for approval.
8. **Never guess.** An explicit "unknown" is always better than a plausible invention.

Run `tools/check-plugin.sh` before shipping. It enforces 1 to 5 mechanically, and runs any `.checks.sh` a plugin defines for its own invariants.

## Working here

| Task | Read |
|---|---|
| Add a plugin or a vertical | `docs/authoring-a-plugin.md` |
| Ship to a client or internally | `docs/distribution.md` |
| Build or run a testbed | `docs/testing.md` |
| Understand a specific plugin | that plugin's `DESIGN.md` |

## Conventions

- **Do not run git commands.** The maintainer runs PowerShell and WSL git against the same working tree, and mixing them causes lock conflicts. Edit files; leave version control to him.
- Prose in docs and skills: plain sentences, no em dashes, no filler.
- Document decisions with the alternative that was rejected and why. A decision without its rationale gets quietly undone.
- When adding a skill, update the plugin README, its setup guide, and its quick reference in the same change. Docs here have gone stale within days before.
