# Testing

How to test a plugin the way its user will actually use it, without touching a real account.

---

## Two layers

**Structural**, cheap, run every time:

```bash
tools/check-plugin.sh
```

Manifest validity, name agreement across three places, `.claude-plugin` contents, skill frontmatter, marketplace resolution, nothing unshippable inside the plugin. Then it runs each plugin's own `.checks.sh`, so vertical-specific invariants stay with their plugin instead of accumulating in shared tooling.

**Behavioural**, run before shipping: a testbed.

---

## Testbeds

A testbed is a simulated user, with their folder structure, their config and their data, so you can run the plugin exactly as they would.

```
professionals/<profession>/testbed/
├── CLAUDE.md          ← the user's config, as if setup had run
└── <subject folders>  ← their clients, matters, projects
```

### Rules

**Put the testbed in the vertical, not in the plugin.** It must never ship. `check-plugin.sh` fails if it finds one inside a plugin directory.

**Run Claude from the vertical folder**, so `testbed/CLAUDE.md` and `.mcp.json` resolve:

```bash
cd professionals/<profession>
claude --plugin-dir ./plugins/<plugin-name>
cd testbed
```

**The repo-root `CLAUDE.md` will also load**, because they cascade upward. It opens by telling Claude to defer to a practice config when one is present. Keep that block intact when editing it, or simulations start behaving like maintenance sessions.

**Subjects in different states.** One mid-work with problems, one clean, one not yet onboarded. A testbed with one happy subject exercises one path.

### Fixtures should be adversarial

A testbed where everything succeeds proves nothing. Include, deliberately:

- something that **fails a validation check** the plugin claims to perform
- something **missing** that should have been there
- something **unreadable**, to confirm it is refused rather than guessed
- something the plugin **must not touch**, to confirm it does not

The tax testbed does all four: a bank statement month seeded out of balance with nothing else hinting at it, an absent month, a deliberately unreadable photograph, and a calendar event with no reconciliation marker.

Write down what each fixture proves. A fixture nobody understands gets deleted during a tidy-up.

### Runs must be repeatable

Commit fixtures. Gitignore anything a run produces. After a reset, `git status` should be clean.

---

## Mock MCP servers

Skills that touch calendars, email or other accounts cannot be tested against a real account repeatably, and should not be tested against a client's.

`tools/mock-calendar-mcp/` is a stdio MCP server in Python standard library only. It mirrors the Google Calendar tool surface closely enough that a calendar skill runs unchanged, backed by a local JSON file. No OAuth, no network.

Wire it from the vertical's `.mcp.json`:

```json
{
  "mcpServers": {
    "mock-calendar": {
      "command": "python3",
      "args": ["../../tools/mock-calendar-mcp/server.py"]
    }
  }
}
```

The path is relative to where Claude is started, which is the vertical folder.

Confirm with `/mcp`. The store regenerates from `calendar-seed.json` whenever it is deleted, which is how you reset.

### Writing another mock

Mirror the real connector's tool **names and shapes**, not an idealised version, or the skill will pass against the mock and fail against reality. Check the real tool's schema first and copy its parameter names.

Put mocks in root `tools/`. A second vertical will want them.

---

## What to test behaviourally

Generic, and worth running for any plugin:

| Test | Why |
|---|---|
| Run any write operation **twice** | The second run must change nothing. Duplicates destroy trust faster than any other failure |
| Point it at **missing data** | It must say what is missing and what that blocks, not invent a value |
| Give it something **unreadable** | It must report it. Silent omission is the worst failure mode, because nobody goes looking for a thing they do not know is missing |
| Give it something it **must not touch** | Confirm it leaves it alone |
| Check every **generated file** for placeholder text | A bracketed placeholder in a generated file is read as content |
| Ask **"where did that come from?"** | Every fact should be traceable to a file |

Write the plugin's specific walkthrough in its `DEVELOPMENT.md`, as a table of what to say and what should happen, plus a second table of what failure looks like. The second table is the more useful one.
