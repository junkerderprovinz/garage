#!/usr/bin/env bash
# print-banner.sh <container-name> <subtitle>
# Prints the shared Junker der Provinz init-log banner.

CONTAINER="${1:-Container}"
SUBTITLE="${2:-}"
BANNER_FILE="/usr/local/share/banner.txt"

echo ""

if [ -f "${BANNER_FILE}" ]; then
    cat "${BANNER_FILE}"
    # The shared banner file has no trailing newline; add blank lines so the
    # banner gets breathing room before the title block.
    echo ""
    echo ""
else
    echo ""
    echo "  Junker der Provinz"
    echo ""
fi

# The caller prints its status line right after the trailing blank line.
if [ -n "${SUBTITLE}" ]; then
    printf '  %s · %s\n' "${CONTAINER}" "${SUBTITLE}"
else
    printf '  %s\n' "${CONTAINER}"
fi
echo ""
