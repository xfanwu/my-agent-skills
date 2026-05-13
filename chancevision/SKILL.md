---
name: chancevision
description: Use when the user asks you to analyze, inspect, or describe images/screenshots using visual AI. Runs @chancevision/cli via npx (no install needed). Supports local files and remote URLs.
version: 1.0.0
author: Hermes Agent
license: MIT
metadata:
  hermes:
    tags: [vision, image-analysis, cli, screenshot, ui-inspection]
    related_skills: []
---

# ChanceVision CLI — Visual Intelligence for Agents

## Overview

ChanceVision CLI (`@chancevision/cli`) is a command-line tool that analyzes images using the Chance Vision API (`chance/chance-vision-1.5` model). It accepts local image files or remote URLs and returns markdown descriptions or structured UI component data.

This skill wraps it for agent use — **no local install required**; always runs via `npx` to get the latest version.

## When to Use

- User sends an image and asks "what does this show?" or "describe this"
- User asks you to inspect a screenshot, UI mockup, design, or diagram
- User wants structured data extracted from a UI screenshot (buttons, fields, layout)
- User provides a remote image URL for analysis

Don't use for:
- OCR of pure-text documents — use `ocr-and-documents` skill instead
- Image generation — use `image_generate` tool

## Prerequisites

- **Node.js ≥ 20** required for `npx` to work
- **API Key:** `CHANCEVISION_API_KEY` environment variable must be set. Sign up at https://platform.chance.vision/

Check if the env var is set before running:

```bash
echo ${CHANCEVISION_API_KEY:+"set"}${CHANCEVISION_API_KEY:-"NOT SET"}
```

If not set, tell the user to get a key from https://platform.chance.vision/ and set it.

## Usage

### Basic Analysis

Always use `npx` — never install globally:

```bash
npx -y @chancevision/cli see <image-path-or-url>
```

The `-y` flag auto-accepts the install prompt so npx doesn't hang waiting for confirmation.

### Output Formats

| Format | Flag | Use Case |
|--------|------|----------|
| **markdown** (default) | `--output-format markdown` | General image description |
| **ui_component** | `--output-format ui_component` | Structured UI element extraction |
| **raw JSON** | `--json` | Debugging / programmatic consumption |

### Examples

```bash
# Analyze a local screenshot
npx -y @chancevision/cli see ./screenshot.png

# Analyze a remote image, markdown output
npx -y @chancevision/cli see --output-format markdown https://example.com/design.png

# Extract UI components from a mockup
npx -y @chancevision/cli see --output-format ui_component ./app-mockup.png

# Stream the response (live output)
npx -y @chancevision/cli see --stream ./photo.jpg

# Get raw JSON for debugging
npx -y @chancevision/cli see --json ./image.png
```

## Agent Workflow

1. **Identify the image** — user may attach an image (saved to local path) or provide a URL
2. **Check prerequisites** — verify Node.js ≥ 20 and `CHANCEVISION_API_KEY` is set
3. **Run analysis** — call via terminal with `npx -y @chancevision/cli see <path-or-url>`
4. **Interpret results** — read the markdown output and answer the user's question

If the user attached an image in a messaging platform, the image is already downloaded to a local path. Use that path directly.

## Common Pitfalls

1. **Forgetting `-y` flag** — npx will prompt for confirmation and hang indefinitely in non-interactive mode. Always use `npx -y`.

2. **API key not set** — the CLI will fail with an auth error. Check `CHANCEVISION_API_KEY` before running.

3. **Node.js too old** — requires ≥ 20. Check with `node --version`. If too old, tell the user to upgrade.

4. **Large images may be slow** — the API call can take 10-30 seconds. Use `--stream` for progressive output if the user wants to see results as they arrive.

5. **npx cold-start delay** — first run downloads the package (~30KB), subsequent runs are instant (cached in npx cache).

## Verification Checklist

- [ ] `node --version` is ≥ 20
- [ ] `CHANCEVISION_API_KEY` environment variable is set
- [ ] Image file exists at the specified path (or URL is accessible)
- [ ] `npx -y` flag is used (not just `npx`)
- [ ] Output is read and interpreted for the user
