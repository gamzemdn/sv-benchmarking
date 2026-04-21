#!/usr/bin/env bash
# =============================================================================
# run_pipeline.sh — Master Pipeline Runner
#
# Runs the full SV benchmarking pipeline in order.
# Before starting, fill in all paths in 00_config.sh.
#
# Usage:
#   bash run_pipeline.sh               # run everything
#   bash run_pipeline.sh truth         # truth set preprocessing only
#   bash run_pipeline.sh callers       # caller VCF preprocessing only
#   bash run_pipeline.sh eval          # run all 3 evaluators
#   bash run_pipeline.sh truvari       # Truvari only
#   bash run_pipeline.sh evalsv        # EvalSVcallers only
#   bash run_pipeline.sh svbenchmark   # SVbenchmark only
#
# NOTE: SVbenchmark requires its own conda environment:
#   conda activate svbenchmark
#   bash run_pipeline.sh svbenchmark
# =============================================================================
set -euo pipefail

SCRIPTS_DIR="$(cd "$(dirname "$0")" && pwd)"
CALLERS=(manta delly lumpy gridss wham)

run_truth() {
    echo "========================================"
    echo " [1/3] Truth set preprocessing"
    echo "========================================"
    bash "${SCRIPTS_DIR}/01_preprocess_truth.sh"
}

run_callers() {
    echo "========================================"
    echo " [2/3] Caller VCF preprocessing"
    echo "========================================"
    for C in "${CALLERS[@]}"; do
        echo "--- ${C} ---"
        bash "${SCRIPTS_DIR}/02_preprocess_callers.sh" "${C}"
    done
}

run_truvari() {
    echo "========================================"
    echo " [3a] Evaluation: Truvari bench"
    echo "========================================"
    bash "${SCRIPTS_DIR}/04_evaluate_truvari.sh" all
}

run_evalsv() {
    echo "========================================"
    echo " [3b] Evaluation: EvalSVcallers"
    echo "========================================"
    bash "${SCRIPTS_DIR}/05_evaluate_evalsvcallers.sh" all
}

run_svbenchmark() {
    echo "========================================"
    echo " [3c] Evaluation: SVbenchmark"
    echo "========================================"
    if ! command -v svbenchmark &> /dev/null; then
        echo "WARNING: svbenchmark not found in PATH."
        echo "  → Activate the correct environment and re-run:"
        echo "      conda activate svbenchmark"
        echo "      bash run_pipeline.sh svbenchmark"
        return 1
    fi
    bash "${SCRIPTS_DIR}/06_evaluate_svbenchmark.sh" all
}

case "${1:-all}" in
    truth)      run_truth ;;
    callers)    run_callers ;;
    truvari)    run_truvari ;;
    evalsv)     run_evalsv ;;
    svbenchmark) run_svbenchmark ;;
    eval)
        run_truvari
        run_evalsv
        run_svbenchmark
        ;;
    all)
        run_truth
        run_callers
        run_truvari
        run_evalsv
        run_svbenchmark
        echo ""
        echo "========================================"
        echo " Pipeline complete."
        echo "========================================"
        ;;
    *)
        echo "Usage: $0 [all|truth|callers|eval|truvari|evalsv|svbenchmark]"
        exit 1
        ;;
esac
