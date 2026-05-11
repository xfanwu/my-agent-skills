---
name: xai-search
description: Use this skill when the user asks to search the web, look up current information, find latest news, search X/Twitter for posts or trends, get real-time data, or retrieve any information that requires up-to-date web results. Also use when the user says "search for", "look up", "what's the latest on", "find tweets about", "trending on X", or similar web/X search phrases. Uses xAI's Grok fast model for low-latency retrieval.
license: MIT
compatibility: opencode
metadata:
  provider: xAI
  model: grok-4-1-fast-non-reasoning
---

## What I Do

Fast web search and X (Twitter) search using xAI's Grok fast model, optimized for low-latency retrieval.

## When to Use Me

- User asks for real-time or recent information from the web
- User wants to search X/Twitter for posts, news, or updates
- Built-in tools (Context7, WebFetch) don't cover the needed search scope
- Speed matters — skip reasoning-heavy models for search tasks

---

## Requirements

Set `XAI_API_KEY` in your environment before using this skill.

```bash
export XAI_API_KEY="your-key-here"
```

---

## Workflow

### Step 1: Choose Search Type

| Type | Command | Use When |
|------|---------|----------|
| Web | `scripts/search.sh web "<query>"` | General web search |
| X | `scripts/search.sh x "<query>"` | X/Twitter posts and updates |

### Step 2: Run the Script

Use the **Bash** tool to execute `scripts/search.sh` from the skill directory. Always quote the query.

**Examples:**

```bash
# Web search
scripts/search.sh web "latest news on silicon photonics 2026"

# X/Twitter search
scripts/search.sh x "OpenAI announcements"

# With custom model (optional)
scripts/search.sh web "DeepSeek R2 release date" grok-4-1-fast
```

### Step 3: Parse and Present Results

The script outputs raw text or JSON from the API. Synthesize it for the user:

- Cite sources with numbered links: `[[1]](url)` when URLs are present
- Group results by topic if multiple areas are covered
- Highlight recent dates and authoritative sources
- If the output is too long, summarize key findings first, then offer details

### Step 4: Refine if Needed

If results are insufficient:
- Rephrase the query with different keywords
- Broaden or narrow the scope
- Switch between `web` and `x` search types

---

## Edge Cases

- **No results returned** — Rephrase the query with different keywords. If still empty, report to the user.
- **API key not set** — Instruct the user: `export XAI_API_KEY="your-key-here"` and retry.
- **Rate limit or API error** — The script exits with an error message. Wait 5 seconds and retry once. If it fails again, report to the user and suggest trying later.
- **Script not found** — Ensure the working directory is set to the skill directory (e.g., `workdir=/home/ubuntu/.opencode/skills/xai-search`).
- **Ambiguous user request** — Ask whether the user wants web results, X/Twitter posts, or both before searching.
- **Very long query** — The script handles quoting. Always wrap the query in double quotes.
