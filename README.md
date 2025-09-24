# Minimal CA-Based Model

This repository contains the source code accompanying the article:

> **A Minimal CA-Based Model Captures Evolutionarily Relevant Features of Biological Development**  
> *Miguel Brun-Usan (CABD-CSIC, Universidad Pablo de Olavide)*  
> *Javier de Juan García (Universidad Autónoma de Madrid)*  
> *Roberto Latorre (Universidad Autónoma de Madrid)*  
> *(Manuscript submitted, under review)*

## Overview
This project implements a minimal cellular-automaton (CA)–based model designed to capture key evolutionary aspects of biological development.  
The repository provides the Fortran source code of the model and a simple Perl/Gnuplot visualization pipeline.

## Repository Contents
- **`autom3_clean.f90`** – Fortran source code of the model (includes detailed usage instructions in the header).  
- **`pdfs6.pl`** – Perl script for basic visualization of simulation outputs using Gnuplot.  
- **`LICENSE`** – License file (GNU General Public License v3).  
- **`README.md`** – This file.

## Requirements
- **Fortran compiler** (e.g., `gfortran`)  
- **Perl** (for the visualization script)  
- **Gnuplot** (for plotting results)

Example installation on Debian/Ubuntu:
```bash
sudo apt-get install gfortran perl gnuplot
```
On macOS (with Homebrew):
```bash
brew install gcc perl gnuplot
```

## Compilation and Execution
Compile and run the model:
```bash
gfortran -fbounds-check autom3_clean.f90 -o autom3_clean
./autom3_clean
```
Each run generates one output file per replicate:
```
autom.dat
```

## Visualization
To produce a basic plot of the results:
```bash
perl pdfs6.pl
```
This will invoke **Gnuplot** to create simple visualizations of the output data.

## Citation
If you use this code, please cite the corresponding article once published:

> Brun-Usan, M., de Juan García, J., & Latorre, R. (2025).  
> *A Minimal CA-Based Model Captures Evolutionarily Relevant Features of Biological Development.*  
> Mathematics (in press). DOI to be added upon publication.

## License
This project is licensed under the [GNU General Public License v3](LICENSE).  
You are free to use, modify, and redistribute the code under the terms of this license.

## Contact
For questions or suggestions, please open a GitHub issue or contact:  
- Miguel Brun-Usan – [miguel.brun@csic.es]  
- Roberto Latorre – [roberto.latorre@uam.es]


