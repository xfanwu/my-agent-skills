---
name: brand-guidelines
description: Use this skill when the user asks to apply Anycompany's brand colors, typography, or visual style to any artifact — documents, presentations, web pages, diagrams, or marketing materials. Also use when the user mentions "brand guidelines", "brand colors", "brand styling", "corporate identity", "visual formatting", "on-brand", "Anycompany style", or requests output that should reflect the company's look-and-feel.
license: MIT
compatibility: opencode
metadata:
  brand: Anycompany
  audience: developers
---

## What I Do

I provide Anycompany's official brand identity — colors, typography, and visual style rules — so the agent can apply them consistently to any artifact.

## When to Use Me

- User asks for output in Anycompany brand style
- User mentions brand colors, brand guidelines, or corporate identity
- User is creating presentations, documents, diagrams, or web pages for the company
- User says "on-brand", "our colors", "Anycompany style", "match our branding"

---

## Brand Guidelines

### Colors

**Main Colors:**

| Role | Hex | Usage |
|------|-----|-------|
| Dark | `#1a1e1c` | Primary text, dark backgrounds |
| Light | `#f3f7f5` | Light backgrounds, text on dark |
| Mid Gray | `#8e9692` | Secondary elements, borders |
| Light Gray | `#dde5e0` | Subtle backgrounds, dividers |

**Brand Accent Colors (Teal — between cyan and green):**

| Role | Hex | Usage |
|------|-----|-------|
| Primary Teal | `#2d8a7a` | Primary brand accent, buttons, links, highlights |
| Light Teal | `#4a9e8e` | Secondary accent, hover states, progress bars |
| Deep Teal | `#1f6b5d` | Emphasis, headings, strong accents |

### Typography

| Role | Font | Fallback |
|------|------|----------|
| Headings | Plus Jakarta Sans | system sans-serif |
| Body Text | Plus Jakarta Sans | system sans-serif |
| Code / Monospace | JetBrains Mono | monospace |

**Font notes:**
- Plus Jakarta Sans is available on Google Fonts
- For CLI/code output, use default terminal fonts — brand fonts are for visual artifacts only

---

## Application Rules

### Documents & Presentations
- **Headings**: Plus Jakarta Sans, Deep Teal (`#1f6b5d`) or Dark (`#1a1e1c`)
- **Body text**: Plus Jakarta Sans, Dark (`#1a1e1c`) on Light (`#f3f7f5`) background
- **Accent elements**: Use Primary Teal (`#2d8a7a`) for buttons, icons, highlights
- **Secondary elements**: Use Light Teal (`#4a9e8e`) for hover states, secondary info
- **Charts/diagrams**: Cycle through teal variants; avoid pure cyan or pure green

### Web & UI
- **Background**: Light (`#f3f7f5`) or Dark (`#1a1e1c`) depending on theme
- **Primary CTA**: Primary Teal (`#2d8a7a`) with white text
- **Links**: Primary Teal (`#2d8a7a`), underline on hover
- **Borders/Dividers**: Light Gray (`#dde5e0`)
- **Cards/Surfaces**: White (#ffffff) on light theme, with Light Gray borders

### Terminal / CLI Output
- No special colors — use default terminal output
- Only apply brand guidelines to visual artifacts (HTML, SVG, PPTX, etc.)

---

## Available Scripts

*No scripts needed — this skill is reference-only. The agent applies these guidelines directly when generating artifacts.*

---

## Edge Cases

- **Artifact type unknown** — Ask the user what format they're creating before applying guidelines.
- **Dark backgrounds** — Switch text to Light (`#f3f7f5`) and adjust Mid Gray to a lighter tint for contrast.
- **Color blindness / accessibility** — Ensure 4.5:1 contrast ratio minimum. Teal on white passes; Teal on Dark (`#1a1e1c`) also passes.
- **Font not installed** — For web, link to Google Fonts. For documents, instruct user to install Plus Jakarta Sans. For CLI output, skip brand fonts entirely.
- **User overrides a color** — Defer to the user's explicit instruction; these guidelines are defaults, not constraints.
