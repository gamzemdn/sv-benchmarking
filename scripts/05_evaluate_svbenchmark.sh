#!/usr/bin/env bash
# =============================================================================
# 06_evaluate_svbenchmark.sh — SVbenchmark Evaluation
#
# Runs svbenchmark to compare each caller VCF against the truth set.
# BED-based region restriction is applied upstream during caller VCF preprocessing (02_preprocess_callers.sh).
#
# Conda environment: svbenchmark
#
# Usage:
#   conda activate svbenchmark
#   bash 06_evaluate_svbenchmark.sh manta
#   bash 06_evaluate_svbenchmark.sh all
# =============================================================================
set -euo pipefail

source "$(dirname "$0")/00_config.sh"

CALLERS=(manta delly lumpy gridss wham)

# Check that svbenchmark is available in PATH
if ! command -v svbenchmark &> /dev/null; then
    echo "ERROR: svbenchmark not found."
    echo "Please activate the correct conda environment first:"
    echo "  conda activate svbenchmark"
    exit 1
fi

run_svbenchmark() {
    local CALLER="$1"

    case "${CALLER}" in
        manta)  CALLER_VCF="${MANTA_OUT}/manta.final.vcf.gz"   ;;
        delly)  CALLER_VCF="${DELLY_OUT}/delly.final.vcf.gz"   ;;
        lumpy)  CALLER_VCF="${LUMPY_OUT}/lumpy.final.vcf.gz"   ;;
        gridss) CALLER_VCF="${GRIDSS_OUT}/gridss.final.vcf.gz" ;;
        wham)   CALLER_VCF="${WHAM_OUT}/wham.final.vcf.gz"     ;;
        *)  echo "Unknown caller: ${CALLER}"; exit 1 ;;
    esac

    local OUT="${SVBENCHMARK_OUT}/${CALLER}"
    mkdir -p "${OUT}"

    echo "--- SVbenchmark: ${CALLER} (${SAMPLE}) ---"

    svanalyzer benchmark \
        --ref    "${REF_FA}"          \
        --test   "${CALLER_VCF}"      \
        --truth  "${TRUTH_VCF}"       \
        --prefix "${OUT}/${CALLER}"

    echo "    Output: ${OUT}/${CALLER}.*"
}

# ── Run ───────────────────────────────────────────────────────────────────────
TARGET="${1:?Usage: $0 <caller|all>}"

if [[ "${TARGET}" == "all" ]]; then
    for C in "${CALLERS[@]}"; do
        run_svbenchmark "${C}"
    done
else
    run_svbenchmark "${TARGET}"
fi

echo "=== SVbenchmark complete. Results: ${SVBENCHMARK_OUT} ==="
