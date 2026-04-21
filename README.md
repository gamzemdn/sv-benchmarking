# SV benchmarking frameworks analysis and evaluation

This repository contains the preprocessing and benchmarking pipeline used in our study comparing five structural variant (SV) callers — **Manta, Delly, Lumpy, GRIDSS, and Wham** — against validated truth sets for samples HG002 (GIAB) and NA12878 (HGSVC2).

Three independent evaluation frameworks are applied: **Truvari**, **EvalSVcallers**, and **SVAnalyzer**.

---
## Repository Structure

```
sv-benchmarking/
├── README.md
├── envs/
│   ├── svbenchmark.yml       # Manta, Delly, Lumpy, GRIDSS, Wham, bcftools, octopusv
│   └── svanalyzer.yml        # SVAnalyzer (ayrı ortam)
├── scripts/
│   ├── 00_config.sh                  # Tüm path ve parametreler
│   ├── 01_preprocess_truth.sh        # Truth set hazırlama
│   ├── 02_preprocess_callers.sh      # Caller VCF preprocessing
│   ├── 03_run_gridss.sh              # GRIDSS SV calling
│   ├── 04_evaluate_truvari.sh        # Truvari bench
│   ├── 05_evaluate_evalsvcallers.sh  # EvalSVcallers
│   ├── 06_evaluate_svanalyzer.sh     # SVAnalyzer benchmark
│   └── run_pipeline.sh               # Master script
├── data/
│   └── README.md             # Veri indirme talimatları
└── results/
    └── figures/              # Makalede kullanılan görseller
```

---

## Data Availability

Tüm veriler kamuya açık kaynaklardan elde edilmiştir. Dosya boyutları nedeniyle ham veriler bu repoda yer almamaktadır. İndirme talimatları için [`data/README.md`](data/README.md) dosyasına bakınız.

| Sample | Veri | Kaynak |
|--------|------|--------|
| HG002 | 50× WGS BAM | [GIAB NIST FTP](https://ftp-trace.ncbi.nlm.nih.gov/giab/ftp/data/AshkenazimTrio/HG002_NA24385_son/NIST_HiSeq_HG002_Homogeneity-10953946/HG002Run02-11611685/) |
| HG002 | SV Truth Set v5.0q | [GIAB Release FTP](https://ftp-trace.ncbi.nlm.nih.gov/ReferenceSamples/giab/release/AshkenazimTrio/HG002_NA24385_son/v5.0q/) |
| NA12878 | WGS FASTQ (SRR17658585) | [NCBI SRA](https://www.ncbi.nlm.nih.gov/sra/?term=SRR17658585) |
| NA12878 | SV Truth Set (HGSVC2 v1.0) | [1000 Genomes EBI FTP](https://ftp.1000genomes.ebi.ac.uk/vol1/ftp/data_collections/HGSVC2/release/v1.0/integrated_callset/) |

---

# Data

All data used in this study are publicly available. Raw files are not included in this repository due to size constraints. Download using the instructions below.

---

## HG002 (GIAB Ashkenazim Trio)

**BAM file (50× HiSeq coverage GRCh37):**
```bash
wget https://ftp-trace.ncbi.nlm.nih.gov/giab/ftp/data/AshkenazimTrio/HG002_NA24385_son/NIST_HiSeq_HG002_Homogeneity-10953946/HG002Run02-11611685/
```

**SV Truth Set (v5.0q):**
```bash
wget https://ftp-trace.ncbi.nlm.nih.gov/ReferenceSamples/giab/release/AshkenazimTrio/HG002_NA24385_son/v5.0q/HG002_GRCh37_v5.0q_stvar.vcf.gz
wget https://ftp-trace.ncbi.nlm.nih.gov/ReferenceSamples/giab/release/AshkenazimTrio/HG002_NA24385_son/v5.0q/HG002_GRCh37_v5.0q_stvar.benchmark.bed
```

---

## NA12878 (GRCh38)

**FASTQ reads (SRA: SRR17658585):**
```bash
prefetch SRR17658585
fasterq-dump SRR17658585
```

**SV Truth Set (HGSVC2 v1.0):**
```bash
wget https://ftp.1000genomes.ebi.ac.uk/vol1/ftp/data_collections/HGSVC2/release/v1.0/integrated_callset/
```
