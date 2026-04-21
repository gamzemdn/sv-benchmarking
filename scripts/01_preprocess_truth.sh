#!/usr/bin/env bash
# =============================================================================
# 01_preprocess_truth.sh — Essential Truth Set Preparation
#
# Steps:
#   1. Restrict truth set to benchmark BED regions
#   2. Retain variants with |SVLEN| >= 50 bp
#   3. bgzip + tabix index
# =============================================================================
set -euo pipefail

source "$(dirname "$0")/00_config.sh"

mkdir -p "${TRUTH_OUT}"

echo "[1/2] Filtering truth set to benchmark BED regions if BED file is available..."
bcftools view \
    -R "${TRUTH_BED}" \
    -Oz -o "${TRUTH_OUT}/truth.bedfiltered.vcf.gz" \
    "${TRUTH_VCF}"
tabix -f -p vcf "${TRUTH_OUT}/truth.bedfiltered.vcf.gz"

echo "[2/2] Filtering by SV length (|SVLEN| >= ${SVLEN_MIN})..."
bcftools view \
    -i '(INFO/SVLEN>='${SVLEN_MIN}' || INFO/SVLEN<=-'${SVLEN_MIN}')' \
    -Oz -o "${TRUTH_OUT}/truth.final.vcf.gz" \
    "${TRUTH_OUT}/truth.bedfiltered.vcf.gz"
tabix -f -p vcf "${TRUTH_OUT}/truth.final.vcf.gz"

echo "Done. Final truth VCF: ${TRUTH_OUT}/truth.final.vcf.gz"
