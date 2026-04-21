# SV benchmarking frameworks analysis and evaluation

This repository contains the preprocessing and benchmarking pipeline used in our study comparing five structural variant (SV) callers — **Manta, Delly, Lumpy, GRIDSS, and Wham** — against validated truth sets for samples HG002 (GIAB) and NA12878 (HGSVC2).

Three independent evaluation frameworks are applied: **Truvari**, **EvalSVcallers**, and **SVAnalyzer**.

---
## Repository Structure

```
sv-benchmarking/
├── README.md
├── envs/
│   ├── truvari_env.yml       
│   └── evalsvcallers_env.yml
│   └── svbenchmark_env.yml
├── scripts/
│   ├── 00_config.sh                  # paths and parameters
│   ├── 01_preprocess_truth.sh        # Truth set preprocessing
│   ├── 02_preprocess_callers.sh      # Caller VCF preprocessing
│   ├── 03_evaluate_truvari.sh        # Truvari bench
│   ├── 04_evaluate_evalsvcallers.sh  # EvalSVcallers
│   ├── 05_evaluate_svbenchmark.sh    # SVbenchmark
│   └── run_pipeline.sh               # Master script            
└── results/
    └── figures/              
```

---

## Data Availability

All data has been obtained from publicly available sources. Due to file sizes, the raw data is not included in this repository. 

| Sample | Veri | Kaynak |
|--------|------|--------|
| HG002 | 50× WGS BAM | [GIAB NIST FTP](https://ftp-trace.ncbi.nlm.nih.gov/giab/ftp/data/AshkenazimTrio/HG002_NA24385_son/NIST_HiSeq_HG002_Homogeneity-10953946/HG002Run02-11611685/) |
| HG002 | SV Truth Set and BED v5.0q (GRCh37) | [GIAB Release FTP](https://ftp-trace.ncbi.nlm.nih.gov/ReferenceSamples/giab/release/AshkenazimTrio/HG002_NA24385_son/v5.0q/) |
| NA12878 | WGS FASTQ (SRR17658585) | [NCBI SRA](https://www.ncbi.nlm.nih.gov/sra/?term=SRR17658585) |
| NA12878 | SV Truth Set (HGSVC2 v1.0) (GRCh37) | [1000 Genomes EBI FTP](https://ftp.1000genomes.ebi.ac.uk/vol1/ftp/data_collections/HGSVC2/release/v1.0/integrated_callset/) |

---

## Environment Setup

```bash

# Truvari
conda env create -f envs/truvari_env.yml
conda activate truvari
# EvalSVcallers
conda env create -f envs/evalsvcallers_env.yml
conda activate evalsvcallers
# SVbenchmark
conda env create -f envs/svbenchmark_env.yml
conda activate svbenchmark

```
---

## Pipeline Overview

```
BAM (HG002 / NA12878)
        │
        ▼
┌───────────────────┐
│  SV Callers       │  Manta · Delly · Lumpy · GRIDSS · Wham
└────────┬──────────┘
         │  raw VCF
         ▼
┌───────────────────────────────────────────────────────────┐
│  02_preprocess_callers.sh                                 │
│                                                           │
│  0. octopusv correct → svcf2vcf                           │
│  1. SVLEN filter (|SVLEN| ≥ 50 bp)                        │
│  2. PASS filter                                           │
│  3. Sort                                                  │
│  4. Restrict to high-confidence BED regions (HG002 only)  │
└────────┬──────────────────────────────────────────────────┘
         │  preprocessed VCF (.final.vcf.gz)
         │
         ├──────────────────┬──────────────────┐
         ▼                  ▼                  ▼
┌─────────────┐   ┌──────────────────┐   ┌────────────────────┐
│   Truvari   │   │  EvalSVcallers   │   │    SVbenchmark     │
│    bench    │   │ convert+overlap  │   │                    │
└─────────────┘   └──────────────────┘   └────────────────────┘
         │                  │                  │
         └──────────────────┴──────────────────┘
                            │
                            ▼
                    results/evaluation/
                    ├── truvari/
                    ├── evalsvcallers/
                    └── svbenchmark/
```
---

## Step-by-Step Usage

### 1. Configuration

`scripts/00_config.sh` # define paths according to your system

```bash
SAMPLE="HG002"   # HG002 or NA12878
REF_FA="/path/to/ref.fa"
BAM="/path/to/HG002.bam"
TRUTH_VCF="/path/to/HG002_GRCh37_v5.0q_stvar.vcf.gz"
TRUTH_BED="/path/to/HG002_GRCh37_v5.0q_stvar.benchmark.bed"  # BED file is only available for HG002
CALLER_DIR="/path/to/caller_outputs"
OUT_DIR="/path/to/output"
```

### 2. Truth Set Preprocessing

```bash
conda activate svbenchmark
bash scripts/01_preprocess_truth.sh
```

### 3. Caller VCF Preprocessing

```bash
# Tek caller:
bash scripts/02_preprocess_callers.sh manta

# Tüm callerlar:
bash scripts/run_pipeline.sh callers
```

### 4. Evaluation

```bash
# Truvari + EvalSVcallers:
conda activate svbenchmark
bash scripts/run_pipeline.sh truvari
bash scripts/run_pipeline.sh evalsv

# SVAnalyzer (ayrı ortam):
conda activate svanalyzer
bash scripts/run_pipeline.sh svanalyzer
```

### 5. Run the full pipeline

```bash
conda activate svbenchmark
bash scripts/run_pipeline.sh all
```
---

## License

This project is licensed under the MIT License. See [LICENSE](LICENSE) for details.
