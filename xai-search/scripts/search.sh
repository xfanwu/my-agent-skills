#!/usr/bin/env bash
set -euo pipefail

# xAI Search Script
# Calls https://api.x.ai/v1/responses with search_parameters
# Usage: ./search.sh <web|x> <query> [model]

usage() {
    echo "Usage: $0 <web|x> <query> [model]"
    echo ""
    echo "  web     Web search (sources: [\"web\"])"
    echo "  x       X/Twitter search (sources: [\"x\"])"
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

# Map search type to sources array value
if [ "${SEARCH_TYPE}" = "web" ]; then
    SOURCES='["web"]'
else
    SOURCES='["x"]'
fi

# Build JSON payload (API docs: POST /v1/responses)
PAYLOAD=$(jq -n \
    --arg model "$MODEL" \
    --arg query "$QUERY" \
    --argjson sources "$SOURCES" \
    '{
        model: $model,
        input: $query,
        search_parameters: {
            mode: "on",
            return_citations: true,
            sources: $sources
        }
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
ERROR_MSG=$(echo "$RESPONSE" | jq -r '.error.message // .error // empty' 2>/dev/null)
if [ -n "$ERROR_MSG" ]; then
    echo "API Error: $ERROR_MSG"
    exit 1
fi

# Extract content (model's text response)
echo "$RESPONSE" | jq -r '.content // empty' 2>/dev/null || true

# Extract citations if present
CITATIONS=$(echo "$RESPONSE" | jq -r '
    .reasoning.citations // .citations // empty |
    if type == "array" then
        map("[\(.id // .index)] \(.url // .link // empty)") | join("\n")
    else empty end
' 2>/dev/null)

if [ -n "$CITATIONS" ]; then
    echo ""
    echo "$CITATIONS"
fi
