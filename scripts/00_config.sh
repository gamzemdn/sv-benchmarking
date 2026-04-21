#!/usr/bin/env bash
# =============================================================================
# 00_config.sh — Pipeline Configuration
# All paths and parameters are defined here.
# Source this file at the top of every other script:
#   source "$(dirname "$0")/00_config.sh"
# =============================================================================

# -----------------------------------------------------------------------------
# Sample identity  (HG002 | NA12878)
# -----------------------------------------------------------------------------
SAMPLE="HG002"

# -----------------------------------------------------------------------------
# Reference genome
# -----------------------------------------------------------------------------
REF_DIR="/path/to/reference"
REF_FA="${REF_DIR}/ref.fa"
REF_FAI="${REF_FA}.fai"

# -----------------------------------------------------------------------------
# Input BAM
# -----------------------------------------------------------------------------
BAM_DIR="/path/to/bam"
BAM="${BAM_DIR}/${SAMPLE}.bam"

# -----------------------------------------------------------------------------
# Truth sets
#
#   HG002  → VCF + BED (GIAB v5.0q)
#   NA12878 → only VCF (HGSVC2 v1.0) — BED does not exist
# -----------------------------------------------------------------------------
TRUTH_DIR="/path/to/truth"

HG002_TRUTH_VCF="${TRUTH_DIR}/HG002_GRCh37_v5.0q_stvar.vcf.gz"
HG002_TRUTH_BED="${TRUTH_DIR}/HG002_GRCh37_v5.0q_stvar.benchmark.bed"

NA12878_TRUTH_VCF="${TRUTH_DIR}/NA12878_HGSVC2_v1.0_stvar.vcf.gz"
NA12878_TRUTH_BED=""   # no BED file available for NA12878; BED related steps are skipped automatically

if [[ "${SAMPLE}" == "HG002" ]]; then
    TRUTH_VCF="${HG002_TRUTH_VCF}"
    TRUTH_BED="${HG002_TRUTH_BED}"
else
    TRUTH_VCF="${NA12878_TRUTH_VCF}"
    TRUTH_BED=""
fi

# -----------------------------------------------------------------------------
# Caller raw output VCFs (pre-octopus)
# -----------------------------------------------------------------------------
CALLER_DIR="/path/to/caller_outputs"
MANTA_RAW="${CALLER_DIR}/manta/50x_manta.vcf"
DELLY_RAW="${CALLER_DIR}/delly/50x_delly.vcf"
LUMPY_RAW="${CALLER_DIR}/lumpy/50x_lumpy.vcf"
GRIDSS_RAW="${CALLER_DIR}/gridss/50x_gridss.vcf.gz"
WHAM_RAW="${CALLER_DIR}/wham/50x_wham.vcf"

# -----------------------------------------------------------------------------
# Output directories 
# -----------------------------------------------------------------------------
OUT_DIR="/path/to/output"
TRUTH_OUT="${OUT_DIR}/truth"
MANTA_OUT="${OUT_DIR}/manta"
DELLY_OUT="${OUT_DIR}/delly"
LUMPY_OUT="${OUT_DIR}/lumpy"
GRIDSS_OUT="${OUT_DIR}/gridss"
WHAM_OUT="${OUT_DIR}/wham"

EVAL_OUT="${OUT_DIR}/evaluation"
TRUVARI_OUT="${EVAL_OUT}/truvari"
EVALSV_OUT="${EVAL_OUT}/evalsvcallers"
SVBENCHMARK_OUT="${EVAL_OUT}/svbenchmark"

# -----------------------------------------------------------------------------
# Tool paths
# -----------------------------------------------------------------------------
EVALSVCALLERS_DIR="/path/to/EvalSVcallers-master"

# -----------------------------------------------------------------------------
# Parameters
# -----------------------------------------------------------------------------
THREADS=8
SVLEN_MIN=50     # Minimum absolute SV length (bp)
