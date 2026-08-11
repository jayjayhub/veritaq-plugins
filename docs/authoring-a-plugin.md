# Authoring a Plugin

How to add a vertical and a plugin to this repo without repeating mistakes already made once.

---

## Layout

A **vertical** is a market segment: a profession, or a company. A **plugin** is the shippable unit inside it.

```
professionals/<profession>/          or  companies/<company>/
├── plugins/
│   └── <plugin-name>/               ← ships. Nothing else does
│       ├── .claude-plugin/plugin.json
│       ├── .checks.sh               ← optional, this plugin's own invariants
│       ├── DESIGN.md
│       ├── README.md
│       ├── docs/
│       ├── reference/               ← swappable domain packs
│       ├── skills/<name>/SKILL.md
│       └── templates/
├── testbed/                         ← simulated user. Never ships
├── tools/                           ← only if genuinely vertical-specific
├── marketing/                       ← never ships
├── .mcp.json                        ← mock servers for this vertical's testbed
└── DEVELOPMENT.md
```

`plugins/` is a **container**, even when it holds one thing. Flattening it means a second plugin for that vertical forces a restructure, and this repo has already paid that cost once.

**Shared tooling goes to root `tools/`.** If a second vertical would want it, it is shared. Only keep something local when it genuinely cannot serve anyone else.

---

## Naming

Three names must be identical:

1. the plugin directory name
2. `name` in `.claude-plugin/plugin.json`
3. `name` in the marketplace entry

`plugin.json`'s name also namespaces the skills, so a mismatch means installing one name and getting skills under another. `tools/check-plugin.sh` enforces this.

Plugin names are singular and describe the user, not the vertical: `tax-accountant-in-a-box`, not `tax-accountants-in-a-box`. The directory above may be plural.

---

## The three-layer rule

The single most important design constraint here, and the reason these plugins port.

| Layer | Holds | Lives |
|---|---|---|
| **Skills** | Workflow logic only. Interview structure, output formats, reconciliation | The plugin |
| **Domain pack** | Every fact that changes by country, industry or regime | `reference/`, copied into the user's folder at setup |
| **User config** | Every preference. Names, defaults, tone, connected systems | A `CLAUDE.md` the user owns |

**A skill that names a country, a tool or a preference is a bug.** It means porting requires editing skills instead of swapping one file.

Enforce it with a `.checks.sh` in the plugin root. Both greps in the tax plugin's version caught real leaks the first time they ran.

---

## Building a plugin

### 1. Scaffold

```
professionals/<profession>/plugins/<plugin-name>/.claude-plugin/plugin.json
```

```json
{
  "name": "<plugin-name>",
  "description": "One sentence a buyer would recognise as their own problem.",
  "version": "0.1.0",
  "author": { "name": "Veritaq" },
  "license": "UNLICENSED"
}
```

Add the entry to the repo-root `.claude-plugin/marketplace.json`. Nowhere else. A `marketplace.json` inside a vertical registers a second marketplace and collides on name.

### 2. Write skills

One skill, one job, one owned artifact. If a new skill would write something another skill already owns, extend that one instead. Two writers means two versions that drift.

Every skill:

- **Triggers on natural phrasing.** The description carries what the user would actually say, not the skill's name. Err towards over-eager; a skill that never fires is worse than one that fires slightly too often.
- **States its precondition** and names the skill to run when it is unmet, rather than improvising.
- **Reads config and domain pack**, hardcodes neither.
- **Shows a plan before writing anything**, and waits.
- **Never guesses.** An explicit unknown, and what it blocks, beats an invention.

### 3. Interview, do not interrogate

Where a skill needs information, propose a filtered draft and have the user correct it. Checking is faster and more accurate than generating, and it surfaces what they would have forgotten.

Then echo the consequences back before writing: *"that gives a filing deadline of X and a cut-off of Y, does that look right?"* This converts data entry into verification and catches errors while they are cheap.

### 4. Never write a placeholder into a generated file

`[Sdn Bhd / sole proprietor]` in a generated file is read as content. Every field is either a real answer or an explicit `TBC` that says what it blocks.

### 5. Write `DESIGN.md`

Record decisions **with the alternative that was rejected and why**. Without it, a maintainer sees an arbitrary choice and undoes it. This is the highest-value document in a plugin and the easiest to skip.

Include a known-weaknesses section. Honest limits are worth more than a confident overview.

### 6. Build a testbed

See [`testing.md`](testing.md). Fixtures should be adversarial: something that fails a validation check, something missing, something unreadable. A testbed where everything succeeds proves nothing.

### 7. Check

```bash
tools/check-plugin.sh professionals/<profession>/plugins/<plugin-name>
```

---

## Adding a domain pack

To support a second country, industry or regime:

1. Copy the existing pack, rename it.
2. Replace the contents, **keeping every section heading identical**, since skills refer to them by name.
3. Point the user's config at the new pack.

No skill changes. If you find yourself editing a skill, something leaked; fix the leak instead.

---

## Documentation each plugin needs

| File | For |
|---|---|
| `README.md` | What it is, at a glance |
| `DESIGN.md` | Architecture, decisions, invariants, known weaknesses |
| `docs/setup-guide.md` | The buyer, installing it |
| `docs/user-guide.md` | The user, with worked examples including imperfect runs |
| `docs/quick-reference.md` | One page of what to say |

Update these **in the same change as the code**. Docs in this repo have gone stale within two days before, and a stale setup guide is worse than none because someone will follow it.
