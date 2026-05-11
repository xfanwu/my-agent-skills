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

## Workflow

### Step 1: Choose the Right Tool

Select based on the user's request:

| Tool | Use When |
|------|----------|
| `xai-search` | User wants both web and X/Twitter results combined |
| `xai-search_web_search` | User only needs general web search results |
| `xai-search_x_search` | User only needs X/Twitter posts and updates |

### Step 2: Set the Model (Optional)

Pass `model` to override the default:

```
model: "grok-4-1-fast-non-reasoning"  (default)
model: "grok-4-1-fast"               (if reasoning is desired)
```

### Step 3: Call the Tool

Every search requires a `query` parameter. Provide a clear, specific search query.

**Web Search Example:**
```
xai-search_web_search query="latest news on silicon photonics 2026"
```

**X Search Example:**
```
xai-search_x_search query="OpenAI announcements"
```

**Combined Search Example:**
```
xai-search query="DeepSeek R2 release date"
```

### Step 4: Present Results

- Cite sources with numbered links: `[[1]](url)`
- Group results by topic if the search covers multiple areas
- Highlight recent dates and authoritative sources
- Summarize concisely; offer to refine if the user wants more detail

---

## Requirements

Set `XAI_API_KEY` in your environment before using the search tools.

```bash
export XAI_API_KEY="your-key-here"
```

---

## Edge Cases

- **No results returned** — Try rephrasing the query with different keywords or broaden the scope. Report back that no results were found.
- **API key not set** — Instruct the user to export `XAI_API_KEY` and try again. Do not proceed without it.
- **Rate limit or API error** — Wait 5 seconds and retry once. If it fails again, report the error to the user and suggest trying later.
- **Ambiguous user request** — Ask the user whether they want web results, X/Twitter posts, or both before searching.
- **User asks for opinion/analysis** — Use web search results as evidence; do not present model training knowledge as current facts.
