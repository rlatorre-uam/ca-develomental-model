# Minimal CA-Based Model
[![DOI](https://img.shields.io/badge/DOI-10.3390%2Fmath13193238-purple?style=flat-square)](https://doi.org/10.3390/math13193238)
[![License: GPL v3](https://img.shields.io/badge/License-GPLv3-green?style=flat-square)](LICENSE)

This repository contains the source code accompanying the article:

**A Minimal CA-Based Model Capturing Evolutionarily Relevant Features of Biological Development** \
Brun-Usan, M.; de Juan García, J.; Latorre, R. (2025) 

## Overview
This project implements a minimal cellular automaton (CA)–based model designed to capture
evolutionarily relevant features of biological development.

The repository provides:
- The full **Fortran implementation** of the model used in the article.
- A simple **Perl/Gnuplot visualization pipeline** for inspecting simulation outputs.

The code corresponds to the version used for the analyses reported in the paper.

## Repository Contents
- **`autom3_clean.f90`** – Fortran source code of the model  
  Usage instructions and parameter descriptions are included in the file header.
- **`pdfs6.pl`** – Perl script for basic visualization of simulation outputs using Gnuplot.  
- **`LICENSE`** – GNU General Public License v3.
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
Compile and run the model using:
```bash
gfortran -fbounds-check autom3_clean.f90 -o autom3_clean
./autom3_clean
```
Each execution produces one output data file per run: `autom.dat`.

The format and meaning of the output variables are documented in the source code.

## Visualization
To generate basic plots from the simulation output:
```bash
perl pdfs6.pl
```
This script invokes **Gnuplot** to produce simple visualizations of the data contained in `autom.dat`.

## Citation
If you use this code in your work, please cite the associated article:

Brun-Usan, M.; de Juan García, J.; Latorre, R. 2025.
A Minimal CA-Based Model Capturing Evolutionarily Relevant Features of Biological Development.
*Mathematics*, 13(19), 3238.
https://doi.org/10.3390/math13193238

## License
This project is licensed under the [GNU General Public License v3](LICENSE).  
You are free to use, modify, and redistribute the code under the terms of this license.

## Contact
For questions or suggestions, please open a GitHub issue or contact:  
- Miguel Brun-Usan – miguel.brun@csic.es 
- Roberto Latorre – roberto.latorre@uam.es


