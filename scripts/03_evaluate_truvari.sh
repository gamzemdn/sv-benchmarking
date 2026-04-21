#!/usr/bin/env bash
# =============================================================================
# 04_evaluate_truvari.sh — Truvari bench Evaluation
#
# Runs truvari bench for each SV caller.
# HG002:   restricted to high-confidence regions via --includebed.
# NA12878: --includebed is skipped as no BED file is available.
#
# Usage:
#   bash 04_evaluate_truvari.sh manta
#   bash 04_evaluate_truvari.sh delly
#   bash 04_evaluate_truvari.sh lumpy
#   bash 04_evaluate_truvari.sh gridss
#   bash 04_evaluate_truvari.sh wham
#   bash 04_evaluate_truvari.sh all   # run all callers
# =============================================================================
set -euo pipefail

source "$(dirname "$0")/00_config.sh"

CALLERS=(manta delly lumpy gridss wham)

run_truvari() {
    local CALLER="$1"

    # Preprocessed final VCF (output of 02_preprocess_callers.sh)
    case "${CALLER}" in
        manta)  CALLER_VCF="${MANTA_OUT}/manta.final.vcf.gz"   ;;
        delly)  CALLER_VCF="${DELLY_OUT}/delly.final.vcf.gz"   ;;
        lumpy)  CALLER_VCF="${LUMPY_OUT}/lumpy.final.vcf.gz"   ;;
        gridss) CALLER_VCF="${GRIDSS_OUT}/gridss.final.vcf.gz" ;;
        wham)   CALLER_VCF="${WHAM_OUT}/wham.final.vcf.gz"     ;;
        *)  echo "Unknown caller: ${CALLER}"; exit 1 ;;
    esac

    local OUT="${TRUVARI_OUT}/${CALLER}"
    mkdir -p "${OUT}"

    echo "--- Truvari bench: ${CALLER} (${SAMPLE}) ---"

    # --includebed is only used for HG002; skipped when TRUTH_BED is empty
    local BED_ARG=""
    if [[ -n "${TRUTH_BED}" ]]; then
        BED_ARG="--includebed ${TRUTH_BED}"
    else
        echo "    [!] NA12878: no BED file available, skipping --includebed."
    fi

    truvari bench \
        --base      "${TRUTH_VCF}"  \
        --comp      "${CALLER_VCF}" \
        --output    "${OUT}"        \
        --reference "${REF_FA}"     \
        ${BED_ARG}

    echo "    Output: ${OUT}/summary.json"
}

# ── Run ───────────────────────────────────────────────────────────────────────
TARGET="${1:?Usage: $0 <caller|all>}"

if [[ "${TARGET}" == "all" ]]; then
    for C in "${CALLERS[@]}"; do
        run_truvari "${C}"
    done
else
    run_truvari "${TARGET}"
fi

echo "=== Truvari complete. Results: ${TRUVARI_OUT} ==="
