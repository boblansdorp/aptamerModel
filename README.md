# aptamerModel
Physical electrochemistry model of aptamer-based electrochemical biosensors using Square Wave Voltammetry (SWV) and a Laplace equation solver for estimating solution resistance in a cylindrical geometry.

Latest version: [github.com/boblansdorp/aptamerModel](https://github.com/boblansdorp/aptamerModel)

## Introduction

These simulations are written in Mathematica (tested on version 13.1).

The model combines a Butler–Volmer kinetic description of Methylene Blue electron transfer with an equivalent circuit (Randles cell: Rsol, CDL, Rct, Capt) to reproduce SWV measurements from aptamer-functionalized gold electrodes. It also provides an analytical Laplace-transform solution for the SWV response, and a time-domain Butler-Volmer model for estimating solution resistance in different geometries.

The third-party [`CustomTicks`](CustomTicks/) package (Mark A. Caprio, MIT License) is included for publication-quality axis tick formatting.

---

## Repository structure

| File | Purpose |
|---|---|
| `Aptamer-Model.m` | Main ODE simulation — sweeps frequency × concentration, exports `.mx` result files |
| `analyticalCurrentGivenParams.m` | Laplace-transform SWV current: derives the analytical step-response expression for the 4-component circuit |
| `theoryExperimentalDataComparison.m` | Loads simulation `.mx` files and experimental voltammogram data; generates all theory-vs-experiment comparison plots |
| `loadExperimentalVoltammogramGeneratePlots.m` | Package `LoadVoltammogramData` — parses CHI potentiostat `.txt` files into frequency-indexed associations |
| `AnalyzeVoltammogram.m` | Package `AnalyzeVoltammogram` — Gaussian peak fit to extract baseline, ΔI, and peak current from each voltammogram |
| `loadMxGeneratePlots.m` | Loads a saved `.mx` result file and restores all simulation parameters and ODE definitions |
| `addedResistanceKDM.m` | KDM (Kinetic Differentiation Metric) analysis — computes how solution resistance drift degrades concentration estimates; uses the closed-form `CHISignalBaselineSubtractedExpr` |
| `radialConductivity.m` | Finite-element electrostatics (axisymmetric Laplace) — estimates solution resistance for different electrode geometries and tissue conductivities |
| `fitRsolCDLfromData.m` | Fits CDL and Rsol from SWV non-faradaic baseline current vs frequency; publication values obtained from EIS instead (see below) |
| `fit aptamer parameters at low resistance with known Rsol and CDL.m` | Fits Rct and Capt from measured current vs frequency at zero target concentration |
| `fitRCData_resistors.m` | Fits CDL and Rsol from RC-circuit standard measurements (2 kΩ and 47 kΩ datasets, 2026-07-15) |
| `CustomTicks/` | Third-party tick-formatting package (MIT License, Mark A. Caprio) |

---

## Reproducing manuscript figures

### Figure 5 — Equivalent circuit model and Rs-dependent voltammogram distortion

| Panel | Description | Code |
|---|---|---|
| 5A | Experimental voltammograms, low-Rs vs high-Rs (unbound state) | `theoryExperimentalDataComparison.m` → `voltammogramPlots` (top row) |
| 5B | Simulated SWV voltammograms (Butler–Volmer + circuit) | `Aptamer-Model.m` (generates `.mx`); `theoryExperimentalDataComparison.m` → `voltammogramPlots` (bottom row) |


### Figure 6 — Rs distorts the frequency response (experimental and model)

| Panel | Description | Code |
|---|---|---|
| 6A | Experimental non-faradaic baseline current vs frequency | `theoryExperimentalDataComparison.m` → `baselineStandardPlot2Exp` |
| 6B | Experimental faradaic peak current vs frequency, unbound (0 mM) | `theoryExperimentalDataComparison.m` → `deltaILowConcPlotExp` |
| 6C | Experimental faradaic peak current vs frequency, bound (9.3 mM) | `theoryExperimentalDataComparison.m` → `deltaIHighConcPlotExp` |
| 6D | Simulated + analytical baseline current vs frequency | `theoryExperimentalDataComparison.m` → `baselineStandardPlot2Theory` |
| 6E | Simulated + analytical faradaic peak current vs frequency, unbound | `theoryExperimentalDataComparison.m` → `theoryLowConcPlot` |
| 6F | Simulated + analytical faradaic peak current vs frequency, bound | `theoryExperimentalDataComparison.m` → `theoryHighConcPlot` |

Analytical curves in 6D–F use `chiAnalytical[]` wrapping `CHISignalBaselineSubtractedExpr` from `analyticalCurrentGivenParams.m`. Simulation points come from `Aptamer-Model.m` outputs loaded via `loadMxGeneratePlots.m`.

### Figure 7 — Elevated Rs delays potential transduction to the tunneling region

| Panel | Description | Code |
|---|---|---|
| 7C | Potential step experienced by redox reporter vs time for different Rs | `analyticalCurrentGivenParams.m` — plots `1000*(v0Val + rsol*it)` at t=0 onset using `vtime` step |

### Figure S2 — Simulated potential field (in vitro and rat jugular vein)

`radialConductivity.m` — solves the axisymmetric Laplace equation for two geometries (shot glass R = 15 mm; vein R = 1 mm), exports `potential_field_two_panel.png`.

### Table S2 — In vivo solution resistance predictions

`radialConductivity.m` — iterates over tissue conductivity values (PBS, blood, muscle, fat) and prints `Resistance (Ohms)` and `GeometryFactor` for each.

### Figure S5 — Current vs frequency at zero concentration; Rct and Capt fit

`fit aptamer parameters at low resistance with known Rsol and CDL.m` — fits the full analytical expression (baseline-subtracted Faradaic current) to current vs frequency data at zero target concentration.

### Figures S7–S8 — RC circuit standard: analytical theory fits

| Figure | Parameters | Code |
|---|---|---|
| S7 | Rs = 2000 Ω, C = 220 nF | `fitRCData_resistors.m` |
| S8 | Rs = 47 000 Ω, C = 220 nF | `fitRCData_resistors.m` |

---

## Assigning model parameters

Parameters are assigned in the following order:

1. **EIS fit** → Rsol and CDL (`fitRsolCDLfromData.m`)
2. **Current vs frequency at zero concentration** → Rct (unbound) and Capt (`fitAptamerParametersLowResistanceKnownRsolandCapt.m`)
3. **Lovric normalization** → electron transfer rates k0u and k0b (normalized Lovric plots in `theoryExperimentalDataComparison.m`)
4. **Surface coverage** → Lambda from current amplitude (`Aptamer-Model.m` line 61: `Lambda = 4 R T Capt / ((nElec F)^2 A)`)
5. **KDM vs frequency** → dissociation constant Kd (`addedResistanceKDM.m`)

Best-fit parameters (phenylalanine sensor, 1× PBS + 2 mM MgCl₂ + 35 mg/mL BSA at 37 °C):

| Parameter | Value | Source |
|---|---|---|
| Rsol (no added resistor) | 294 Ω | EIS fit |
| Rsol (added resistor) | 1620 Ω | EIS fit |
| CDL | 355 nF | EIS fit |
| Rct (unbound) | 17 034 Ω | Current vs freq fit |
| Rct (bound) | 6 542 Ω | Current vs freq fit |
| Capt | 227.7 nF | Current vs freq fit |
| kD | 17.2 mM | EIS/KDM fit |

---

## Acknowledgements

Portions of this codebase were developed with assistance from ChatGPT (OpenAI) and Claude Code (Anthropic).
