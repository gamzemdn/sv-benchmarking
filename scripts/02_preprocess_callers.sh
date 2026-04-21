#!/usr/bin/env bash
# =============================================================================
# 02_preprocess_callers.sh — Essential Caller VCF Preparation
#
# Steps:
#   0. Standardize raw caller VCFs using Octopus
#      - octopusv correct
#      - octopusv svcf2vcf
#   1. SVLEN filter (|SVLEN| >= 50 bp)
#   2. PASS filter
#   3. Sort
#   4. Restrict to high-confidence BED regions (HG002 only)
# =============================================================================
set -euo pipefail

source "$(dirname "$0")/00_config.sh"

CALLER="${1:?Usage: $0 <caller>  (manta|delly|lumpy|gridss|wham)}"

case "${CALLER}" in
    manta)  RAW_VCF="${MANTA_RAW}";  OUT="${MANTA_OUT}"  ;;
    delly)  RAW_VCF="${DELLY_RAW}";  OUT="${DELLY_OUT}"  ;;
    lumpy)  RAW_VCF="${LUMPY_RAW}";  OUT="${LUMPY_OUT}"  ;;
    gridss) RAW_VCF="${GRIDSS_RAW}"; OUT="${GRIDSS_OUT}" ;;
    wham)   RAW_VCF="${WHAM_RAW}";   OUT="${WHAM_OUT}"   ;;
    *) echo "Unknown caller: ${CALLER}"; exit 1 ;;
esac

mkdir -p "${OUT}"
PREFIX="${OUT}/${CALLER}"

echo "=== Preprocessing: ${CALLER} ==="

# ── Step 0: Standardize raw caller VCFs using Octopus ───────────────────────
echo "[0/4] Standardizing raw caller VCF using Octopus..."
octopusv correct \
    "${RAW_VCF}" \
    "${PREFIX}.svcf"

octopusv svcf2vcf \
    -i "${PREFIX}.svcf" \
    -o "${PREFIX}.standardized.vcf"

bgzip -c "${PREFIX}.standardized.vcf" > "${PREFIX}.standardized.vcf.gz"
tabix -f -p vcf "${PREFIX}.standardized.vcf.gz"

# ── Step 1: SVLEN filter ─────────────────────────────────────────────────────
echo "[1/4] Filtering by SV length (|SVLEN| >= ${SVLEN_MIN})..."
bcftools view \
    -i "INFO/SVLEN>=${SVLEN_MIN} || INFO/SVLEN<=-${SVLEN_MIN}" \
    -Oz -o "${PREFIX}.len50.vcf.gz" \
    "${PREFIX}.standardized.vcf.gz"
tabix -f -p vcf "${PREFIX}.len50.vcf.gz"

# ── Step 2: PASS filter ──────────────────────────────────────────────────────
echo "[2/4] Retaining PASS records..."
bcftools view \
    -f PASS \
    -Oz -o "${PREFIX}.pass.vcf.gz" \
    "${PREFIX}.len50.vcf.gz"
tabix -f -p vcf "${PREFIX}.pass.vcf.gz"

# ── Step 3: Sort ─────────────────────────────────────────────────────────────
echo "[3/4] Sorting..."
bcftools sort \
    "${PREFIX}.pass.vcf.gz" \
    -O z -o "${PREFIX}.sorted.vcf.gz"
tabix -f -p vcf "${PREFIX}.sorted.vcf.gz"

# ── Step 4: Restrict to high-confidence BED regions (HG002 only) ────────────
echo "[4/4] Restricting to high-confidence BED regions..."
bcftools view \
    -R "${TRUTH_BED}" \
    -Oz -o "${PREFIX}.final.vcf.gz" \
    "${PREFIX}.sorted.vcf.gz"
tabix -f -p vcf "${PREFIX}.final.vcf.gz"

echo "Done. Final VCF: ${PREFIX}.final.vcf.gz"
