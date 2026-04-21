# SV benchmarking frameworks analysis and evaluation
# Data

All data used in this study are publicly available. Raw files are not included in this repository due to size constraints. Download using the instructions below.

---

## HG002 (GIAB Ashkenazim Trio)

**BAM file (50× HiSeq coverage):**
```bash
wget https://ftp-trace.ncbi.nlm.nih.gov/giab/ftp/data/AshkenazimTrio/HG002_NA24385_son/NIST_HiSeq_HG002_Homogeneity-10953946/HG002Run02-11611685/
```

**SV Truth Set (v5.0q):**
```bash
wget https://ftp-trace.ncbi.nlm.nih.gov/ReferenceSamples/giab/release/AshkenazimTrio/HG002_NA24385_son/v5.0q/HG002_GRCh37_v5.0q_stvar.vcf.gz
wget https://ftp-trace.ncbi.nlm.nih.gov/ReferenceSamples/giab/release/AshkenazimTrio/HG002_NA24385_son/v5.0q/HG002_GRCh37_v5.0q_stvar.benchmark.bed
```

---

## NA12878

**FASTQ reads (SRA: SRR17658585):**
```bash
prefetch SRR17658585
fasterq-dump SRR17658585
```

**SV Truth Set (HGSVC2 v1.0):**
```bash
wget https://ftp.1000genomes.ebi.ac.uk/vol1/ftp/data_collections/HGSVC2/release/v1.0/integrated_callset/
```

---

## Reference Genome

hg19 canonical chromosomes were used. Source: [UCSC hg19](https://hgdownload.soe.ucsc.edu/goldenPath/hg19/bigZips/)
