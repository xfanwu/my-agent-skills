#!/usr/bin/env bash
set -euo pipefail

# xAI Search Script (Tools API)
# Calls https://api.x.ai/v1/responses with tools (web_search / x_search)
# Usage: ./search.sh <web|x> <query> [model]

usage() {
    echo "Usage: $0 <web|x> <query> [model]"
    echo ""
    echo "  web     Web search (tool: web_search)"
    echo "  x       X/Twitter search (tool: x_search)"
    echo "  query   Search query (wrap in quotes)"
    echo "  model   Optional model (default: grok-4-1-fast-non-reasoning)"
    exit 1
}

if [ $# -lt 2 ]; then
    usage
fi

SEARCH_TYPE="$1"
QUERY="$2"
MODEL="${3:-grok-4-1-fast-non-reasoning}"

if [ "${SEARCH_TYPE}" != "web" ] && [ "${SEARCH_TYPE}" != "x" ]; then
    echo "Error: search type must be 'web' or 'x'"
    usage
fi

# Check API key
if [ -z "${XAI_API_KEY:-}" ]; then
    echo "Error: XAI_API_KEY is not set"
    echo "Run: export XAI_API_KEY=\"your-key-here\""
    exit 1
fi

# Map search type to tool name
if [ "${SEARCH_TYPE}" = "web" ]; then
    TOOL_TYPE="web_search"
else
    TOOL_TYPE="x_search"
fi

# Build JSON payload using the Tools API
PAYLOAD=$(jq -n \
    --arg model "$MODEL" \
    --arg query "$QUERY" \
    --arg tool_type "$TOOL_TYPE" \
    '{
        model: $model,
        input: [{ role: "user", content: $query }],
        tools: [{ type: $tool_type }]
    }')

# Call xAI API (30s timeout)
RESPONSE=$(curl -s --max-time 30 \
    -H "Content-Type: application/json" \
    -H "Authorization: Bearer ${XAI_API_KEY}" \
    -d "$PAYLOAD" \
    "https://api.x.ai/v1/responses" 2>&1) || {
    echo "Error: API request failed (timeout or network error)"
    exit 1
}

# Check for API error
ERROR_MSG=$(echo "$RESPONSE" | jq -r '.error // empty' 2>/dev/null)
if [ -n "$ERROR_MSG" ]; then
    echo "API Error: $ERROR_MSG"
    exit 1
fi

# Extract final message text (last output item of type "message")
TEXT=$(echo "$RESPONSE" | jq -r '
    .output | map(select(.type == "message")) | last |
    .content | map(select(.type == "output_text")) | last |
    .text // empty
' 2>/dev/null)

if [ -n "$TEXT" ]; then
    echo "$TEXT"
fi

# Extract citations from annotations on the final message
CITATIONS=$(echo "$RESPONSE" | jq -r '
    .output | map(select(.type == "message")) | last |
    .content | map(select(.type == "output_text")) | last |
    .annotations // [] |
    map(select(.type == "url_citation")) |
    map("[\(.title // "?")] \(.url)") | join("\n")
' 2>/dev/null)

if [ -n "$CITATIONS" ]; then
    echo ""
    echo "$CITATIONS"
fi
