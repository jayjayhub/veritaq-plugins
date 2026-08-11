# Packaging and Installing This Plugin

How to test, package, distribute and install `tax-accountant-in-a-box`, and a straight answer on connectors.

---

## Part 1 · Can the Gmail and Calendar connectors be bundled?

**No, and you should not try.**

Gmail and Google Calendar are **claude.ai connectors**: a per-user OAuth grant between the accountant's own Google account and Claude. Three consequences:

1. **The authorisation is a credential.** It belongs to the accountant, not to your plugin. There is nothing you could legitimately put in a file that would carry it.
2. **They are already available to every user.** Connectors added at `claude.ai/customize/connectors`, or through Settings then Connectors in the desktop app, are automatically available in Claude Code and Cowork when signed in with that claude.ai account. Bundling would duplicate something the user already has.
3. **Even a manual MCP entry would not help.** You *can* put a remote server in `.mcp.json`:

   ```json
   { "mcpServers": { "gmail": { "type": "http", "url": "https://..." } } }
   ```

   but the user still has to complete the OAuth flow themselves, and for Google's managed endpoints this risks colliding with the connector they already have. Not worth it.

### What to do instead

**Treat connectors as documented prerequisites, and verify them at runtime.** That is what the `practice-setup` skill does: it checks what is live, reports what is missing, and gives the click path to fix it. That is the closest thing to bundling that actually works, and it is arguably better, because the accountant sees and controls each grant.

The plugin also states the important limitation up front rather than letting it be discovered: **email connectors can see that an attachment arrived and what it is called, but cannot open it.** Attachments get saved to the client folder by hand.

### When `.mcp.json` *is* the right answer

Bundle an MCP server when you wrote it, or when it needs no per-user OAuth. For this plugin, a realistic future candidate would be a server you build against a tax authority or a commercial tax package. That belongs in `.mcp.json` with `${CLAUDE_PLUGIN_ROOT}` paths. Third-party OAuth connectors do not.

---

## Part 2 · Structure

Already in place:

```
tax-accountant-in-a-box/
├── .claude-plugin/
│   └── plugin.json          ← manifest. ONLY this goes in .claude-plugin/
├── skills/                  ← one folder per skill, each with SKILL.md
│   ├── practice-setup/
│   ├── client-intake/
│   ├── client-engagement-plan/
│   ├── client-document-chase/
│   ├── source-to-workpaper/
│   └── client-deadline-calendar/
├── reference/
│   └── malaysia-tax.md      ← shipped as a template; copied into the practice folder
├── templates/
├── docs/
└── README.md
```

**The one mistake to avoid:** only `plugin.json` goes inside `.claude-plugin/`. Everything else, `skills/`, `.mcp.json`, `agents/`, `hooks/`, sits at the plugin root. Putting `skills/` inside `.claude-plugin/` is the most common packaging error and the plugin will simply appear empty.

### Why the jurisdiction pack gets copied, not referenced

`practice-setup` copies `reference/malaysia-tax.md` into the accountant's own practice folder. Deliberate, for two reasons: they are expected to correct the checklists as they use them, and a file inside the plugin would be overwritten on the next update. Their copy is the one the skills read.

Trade-off to be aware of: improvements you make to the shipped pack will not reach existing users automatically. If you fix something important, tell them, or add a skill that diffs their copy against the current one.

---

## Part 3 · Test locally

Test before packaging anything. From the parent directory:

```bash
claude --plugin-dir ./tax-accountant-in-a-box
```

The local copy takes precedence over an installed plugin of the same name for that session, so you can test changes without uninstalling.

After editing a skill, pick up changes without restarting:

```
/reload-plugins
```

**What to actually test**, in this order, since each depends on the last:

1. `practice-setup` in an empty folder. Does it produce a config and copy the pack?
2. `client-intake` in a new client folder. Does it branch correctly for an individual versus a company, and does the deadline echo look right?
3. `client-engagement-plan`. Does it propose a sensible checklist and refuse an impossible schedule?
4. `client-document-chase`. Does it read the plan rather than rebuilding the list?
5. `client-deadline-calendar`. Run it twice. **The second run must produce no changes.** If it duplicates events, the reconciliation is broken.
6. `source-to-workpaper` with a real document. This is the one most likely to disappoint; test it with the worst source material you have, not the best.

Validate before distributing:

```bash
claude plugin validate ./tax-accountant-in-a-box
```

Add `--strict` to treat warnings as errors.

---

## Part 4 · Distribute

### Option A · Zip, for a single client

Simplest for handing to one accountant.

```bash
cd tax-accountant-in-a-box && zip -r ../tax-accountant-in-a-box.zip .
```

They load it with:

```bash
claude --plugin-dir ./tax-accountant-in-a-box.zip
```

Requires Claude Code v2.1.128 or later. Good for a pilot. No update path, so every change means resending the file.

### Option B · Marketplace, for more than one client

A marketplace is a git repository with a `.claude-plugin/marketplace.json` at its root listing the plugins it carries. This is the route that gives versioning and updates.

```
veritaq-marketplace/
├── .claude-plugin/
│   └── marketplace.json
└── plugins/
    └── tax-accountant-in-a-box/
```

`marketplace.json`:

```json
{
  "name": "veritaq",
  "owner": { "name": "Veritaq" },
  "plugins": [
    {
      "name": "tax-accountant-in-a-box",
      "source": "./plugins/tax-accountant-in-a-box",
      "description": "Runs a small tax practice end to end. Ships configured for Malaysia.",
      "version": "0.1.0"
    }
  ]
}
```

**Keep it a private repository** while these are paying client deliverables. Private marketplaces are supported; the accountant needs git access.

Installation, once they have access:

```
/plugin marketplace add your-org/veritaq-marketplace
/plugin install tax-accountant-in-a-box@veritaq
```

If the install summary says `Run /reload-plugins to activate`, run it.

### Option C · Public community marketplace

Only if you want this freely available. Submit via `claude.ai/admin-settings/directory/submissions/plugins/new` or `platform.claude.com/plugins/submit`. Run `claude plugin validate` first, the review pipeline runs the same check. Given this is client work, Option B is almost certainly what you want.

---

## Part 5 · Versioning

The `version` field in `plugin.json` controls updates. Users only receive changes when you bump it. If you omit it and distribute via git, every commit counts as a new version.

Suggested discipline for this plugin:

| Change | Bump |
|---|---|
| Wording, clarifications | patch, `0.1.1` |
| New skill, new jurisdiction pack, new config field | minor, `0.2.0` |
| Anything requiring the accountant to change their practice folder | major, `1.0.0` |

That last row matters most. Skills read the practice config and the client `CLAUDE.md` files, so a change to what those must contain is a breaking change for every existing user. Treat it as one.

---

## Part 6 · What the accountant does

Their side, in full:

1. Install Claude Desktop, sign in with the account they already use.
2. Install the plugin, whichever route above.
3. Connect the connectors themselves: Settings, Connectors, then Gmail and Google Calendar. Create a separate calendar called `Tax Deadlines` first.
4. Say **"set up my practice"**. `practice-setup` runs the interview, writes the config, copies the jurisdiction pack, and reports what is missing.
5. Make a folder for one client, say **"run client intake"**.
6. Then **"plan this engagement"**.

About twenty minutes to a working practice with one client. Point them at `docs/setup-guide.md`, which covers the same ground written for them rather than for you.

---

## Namespacing note

Plugin skills are namespaced, so `client-intake` is formally `/tax-accountant-in-a-box:client-intake`. That is a long prefix, but it matters little here because every skill in this plugin is model-invoked: the accountant says "run client intake" or "who is due next month" and Claude triggers on the description. They should rarely need to type a namespaced name at all.

If you ever add skills meant to be typed as slash commands, consider a shorter plugin name.
