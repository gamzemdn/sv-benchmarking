#!/usr/bin/env bash
# =============================================================================
# 05_evaluate_evalsvcallers.sh — EvalSVcallers Evaluation
#
# Two steps:
#   1. convert_SV_callers_vcf.pl  → converts caller VCF to EvalSVcallers format
#   2. evaluate_SV_callers.pl     → computes overlap against the truth set
#
# HG002:   uses BED-filtered preprocessed VCF.
# NA12878: same pipeline applied without BED filtering.
#
# Usage:
#   bash 05_evaluate_evalsvcallers.sh manta
#   bash 05_evaluate_evalsvcallers.sh all
# =============================================================================
set -euo pipefail

source "$(dirname "$0")/00_config.sh"

CALLERS=(manta delly lumpy gridss wham)
CONVERT="${EVALSVCALLERS_DIR}/scripts/convert_SV_callers_vcf.pl"
EVALUATE="${EVALSVCALLERS_DIR}/scripts/evaluate_SV_callers.pl"

# Caller name formatting for the EvalSVcallers -t parameter
# (Manta, DELLY, Lumpy, GRIDSS, Wham)
caller_label() {
    case "$1" in
        manta)  echo "Manta"  ;;
        delly)  echo "DELLY"  ;;
        lumpy)  echo "Lumpy"  ;;
        gridss) echo "GRIDSS" ;;
        wham)   echo "Wham"   ;;
    esac
}

run_evalsv() {
    local CALLER="$1"
    local LABEL
    LABEL="$(caller_label "${CALLER}")"

    case "${CALLER}" in
        manta)  CALLER_VCF="${MANTA_OUT}/manta.final.vcf.gz"   ;;
        delly)  CALLER_VCF="${DELLY_OUT}/delly.final.vcf.gz"   ;;
        lumpy)  CALLER_VCF="${LUMPY_OUT}/lumpy.final.vcf.gz"   ;;
        gridss) CALLER_VCF="${GRIDSS_OUT}/gridss.final.vcf.gz" ;;
        wham)   CALLER_VCF="${WHAM_OUT}/wham.final.vcf.gz"     ;;
        *)  echo "Unknown caller: ${CALLER}"; exit 1 ;;
    esac

    local OUT="${EVALSV_OUT}/${CALLER}"
    mkdir -p "${OUT}"

    echo "--- EvalSVcallers: ${CALLER} (${SAMPLE}) ---"

    # ── Step 1: PASS filter ───────────────────────────────────────────────────
    echo "  [1] PASS filter..."
    bcftools view -f PASS "${CALLER_VCF}" \
        -Oz -o "${OUT}/${CALLER}.pass.vcf.gz"
    tabix -p vcf "${OUT}/${CALLER}.pass.vcf.gz"

    # ── Step 2: Format conversion ─────────────────────────────────────────────
    echo "  [2] convert_SV_callers_vcf.pl (-t ${LABEL})..."
    "${CONVERT}" \
        -t "${LABEL}" \
        "${OUT}/${CALLER}.pass.vcf.gz" \
        > "${OUT}/${CALLER}_converted.vcf"

    # ── Step 3: Overlap against truth set ────────────────────────────────────
    echo "  [3] evaluate_SV_callers.pl..."
    "${EVALUATE}" \
        -r2 "${TRUTH_VCF}" \
        "${OUT}/${CALLER}_converted.vcf" \
        -of 3 \
        > "${OUT}/${CALLER}_overlap.vcf"

    echo "    Output: ${OUT}/${CALLER}_overlap.vcf"
}

# ── Run ───────────────────────────────────────────────────────────────────────
TARGET="${1:?Usage: $0 <caller|all>}"

if [[ "${TARGET}" == "all" ]]; then
    for C in "${CALLERS[@]}"; do
        run_evalsv "${C}"
    done
else
    run_evalsv "${TARGET}"
fi

echo "=== EvalSVcallers complete. Results: ${EVALSV_OUT} ==="
