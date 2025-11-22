# Preterm Motor Gamma MEG — Analysis Code

This repository contains the MATLAB code used to extract motor-related high-gamma oscillations (70–90 Hz) from MEG time–frequency (TF) data for the study of motor system development in preschool children born preterm. TF maps were generated in Brainstorm using Morlet wavelets and exported to MATLAB for further analysis.

The included script (`extract_gamma_metrics.m`) loads each subject’s TF `.mat` file, identifies the 0–100 ms post-movement window, extracts peak gamma power and frequency from contralateral and ipsilateral M1 sensors, computes a lateralisation index, and outputs a summary table.

## Features
- Works directly on Brainstorm-exported TF structures (`TF`, `Freqs`, `Time`)
- Automatically handles left/right sensor selection
- Computes:
  - peak gamma frequency (70–90 Hz)
  - peak gamma power
  - contralateral vs. ipsilateral difference
  - hemispheric lateralisation index
- Exports a single Excel table with per-participant metrics

## Dependencies
- MATLAB R2023b+ (RRID: SCR_001622)  
- Brainstorm (RRID: SCR_001761)  
- Input: Brainstorm-exported TF `.mat` file per subject

## Usage
1. Place all subject `.mat` files in one folder.  
2. Open MATLAB and add this repo to your path.  
3. Run:
   ```matlab
   extract_gamma_metrics
