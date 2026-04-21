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
│   ├── 00_config.sh                  # Tüm path ve parametreler
│   ├── 01_preprocess_truth.sh        # Truth set hazırlama
│   ├── 02_preprocess_callers.sh      # Caller VCF preprocessing
│   ├── 03_evaluate_truvari.sh        # Truvari bench
│   ├── 04_evaluate_evalsvcallers.sh  # EvalSVcallers
│   ├── 05_evaluate_svbenchmark.sh    # SVbenchmark
│   └── run_pipeline.sh               # Master script
├── data/
│   └── README.md             
└── results/
    └── figures/              
```

---

## Data Availability

All data has been obtained from publicly available sources. Due to file sizes, the raw data is not included in this repository. See [`data/README.md`](data/README.md) for download instructions.

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
