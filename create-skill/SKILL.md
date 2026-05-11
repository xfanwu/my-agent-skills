---
name: create-skill
description: Guide for creating new agent skills. Use this when the user wants to create a reusable skill, write a SKILL.md file, or build a new workflow for the agent. Covers structure, naming, frontmatter, and best practices per the Agent Skills standard.
license: MIT
compatibility: opencode
metadata:
  workflow: skill-creation
  audience: developers
---

## What I Do

I guide you through creating a new agent skill for OpenCode. I enforce the Agent Skills standard (progressive disclosure, YAML frontmatter, step-by-step instructions) and ensure the skill follows OpenCode conventions.

## When to Use Me

- User asks to create a skill, agent, or reusable workflow
- User wants to write a SKILL.md file
- User needs help structuring a skill's instructions for reliable agent behavior
- User asks about skill best practices, naming, or frontmatter

---

## Workflow

### Step 1: Gather Requirements

Ask the user these questions (skip any already answered in the request):

1. **Name** — What should the skill be called? (lowercase, hyphens only: e.g. `code-review`)
2. **Purpose** — What task should this skill automate or guide?
3. **Scope** — When should the agent invoke this skill? Be specific.
4. **Tools** — Which tools can the skill use? (Bash, Read, Write, Edit, Glob, Grep, etc.)
5. **Inputs** — Does the skill need arguments from the user?
6. **Outputs** — What format should results follow?

### Step 2: Validate the Name

Check the name against these rules:

- 1–64 characters
- Lowercase alphanumeric with single hyphen separators
- Must not start or end with `-`
- Must not contain consecutive `--`
- Must match the directory name that will contain `SKILL.md`

Regex: `^[a-z0-9]+(-[a-z0-9]+)*$`

### Step 3: Choose the Location

One of these paths (use the first appropriate one):

| Scope | Path |
|---|---|
| This project | `.opencode/skills/<name>/SKILL.md` |
| Your global config | `~/.config/opencode/skills/<name>/SKILL.md` |
| Claude-compatible (project) | `.claude/skills/<name>/SKILL.md` |
| Claude-compatible (global) | `~/.claude/skills/<name>/SKILL.md` |

### Step 4: Write the SKILL.md

Create the file with this structure:

```yaml
---
name: <skill-name>
description: <1-1024 chars describing what it does and when to invoke it>
license: MIT
compatibility: opencode
metadata:
  audience: <who benefits>
  workflow: <workflow tag>
---
```

Below the frontmatter, write the instructions body. Follow these rules:

**Use imperative, ordered language.** Give the agent a checklist, not suggestions.
- Do: "First, read the config file. Then validate each key. If a key is missing, report it."
- Don't: "You might want to read the config file and check the keys."

**Be explicit about tool usage.** Name the specific tools to use for each step.
- Do: "Use Grep to find all usages of the deprecated function."
- Don't: "Find all usages of the deprecated function."

**Include output format requirements.**
- Do: "Output a table with columns: File, Line, Issue, Severity."

**Handle edge cases.**
- Do: "If the file does not exist, create it from the template at `references/template.txt`."

**Keep under 500 lines.** Move reference material to `references/` or `assets/` subdirectories.

### Step 5: Write the Description

The `description` field is critical — it determines when the agent auto-invokes the skill. Make it:

- **Specific about triggers**: "Use this when..." followed by concrete scenarios
- **Keyword-rich**: Include terms the user might say in a request
- **Under 1024 characters**
- **Distinct** from other installed skills so the agent can disambiguate

### Step 6: Add Support Files (Optional)

Create these subdirectories as needed:

- `references/` — Deeper docs, loaded on demand
- `scripts/` — Executable helpers
- `assets/` — Templates, images, static files

Reference them in the instructions body with relative paths.

### Step 7: Verify

After writing the file, confirm:

- [ ] `SKILL.md` is spelled in ALL CAPS
- [ ] Frontmatter contains `name` and `description`
- [ ] `name` matches the directory name
- [ ] `description` is 1–1024 characters
- [ ] No duplicate skill names across all locations
- [ ] Permission is not `deny` for this skill in `opencode.json`

---

## Skill Body Template

Use this as a starting skeleton for the instructions body:

```markdown
## What I Do

[One sentence summary of the skill's purpose.]

## When to Use Me

- [Trigger condition 1]
- [Trigger condition 2]
- [Trigger condition 3]

## Workflow

### Step 1: [First Action]

[What the agent must do first. Name specific tools.]

### Step 2: [Second Action]

[Next step with explicit instructions.]

### Step N: Output

[Required output format with examples.]

## Edge Cases

- If [condition], then [action].
- If [condition], then [action].

## References

- [references/guide.md](references/guide.md) — Detailed documentation
```

---

## Quick Reference

| Field | Required | Max Length | Notes |
|---|---|---|---|
| `name` | Yes | 64 chars | `^[a-z0-9]+(-[a-z0-9]+)*$` |
| `description` | Yes | 1024 chars | Include trigger keywords |
| `license` | No | — | e.g. MIT, Apache-2.0 |
| `compatibility` | No | — | e.g. opencode, claude |
| `metadata` | No | — | String-to-string map only |
