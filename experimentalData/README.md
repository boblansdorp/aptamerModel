# Raw square-wave voltammetry data: EAB sensor titrations at low and high solution resistance

Raw data behind the titration figures (normalized peak current vs concentration, and ΔI<sub>p</sub>/f vs frequency) for three electrochemical aptamer-based (EAB) sensors, each titrated with and without a resistor in series with the working electrode.

Data collected by **Jennifer Gibson**, Plaxco Group, University of California, Santa Barbara.

If you use these data, please cite the associated manuscript (citation to be added).

## Data sets

| Folder | Sensor (target) | Date | Medium | Low R<sub>s</sub> | High R<sub>s</sub> | Concentrations |
|---|---|---|---|---|---|---|
| `2025_11_11_PheTitration/` | phenylalanine | 2025-11-11 | 1× PBS + 2 mM MgCl<sub>2</sub> + 35 mg/mL BSA, 37 °C | `titration/` | `titration_2000_Ohms/` (2000 Ω added) | 14: 0, 0.1 µM – 5.6 mM |
| `2025_09_10_MTX/` | methotrexate | 2025-09-10 | undiluted bovine blood, 37 °C | `titration/` | `titration_2000_Ohms/` (2000 Ω added) | 9: 0, 0.1 µM – 10 mM |
| `2026_01_21_tobramycin_calibration/` | tobramycin | 2026-01-21 | undiluted bovine blood, 37 °C | `titration_0R/` | `titration_1500_ohms/` (1500 Ω added) | 12: 0, then 10<sup>−7</sup> – 10<sup>−2</sup> M in half-decade steps |

"Low R<sub>s</sub>" means no added resistor. The manuscript reports the resulting total solution resistances as roughly 100–200 Ω (low) and ≈2000 Ω (phenylalanine), ≈2200 Ω (methotrexate) and ≈1700 Ω (tobramycin) (high).

## Files

Each condition folder contains:

- **`S1_<f>Hz__<n>.txt`**: one square-wave voltammogram, exported as text by the CHI potentiostat, at frequency `<f>` (Hz) for titration step `<n>`.
  - Phenylalanine and tobramycin: 16 frequencies, 5–600 Hz. Methotrexate: 15 frequencies, 5–600 Hz (no 8 Hz).
  - After a text header with the acquisition settings, the data are comma-separated columns: `Potential/V, i1d/A, i1f/A, i1r/A, i2d/A, …, i3r/A`. For each of the three electrodes measured simultaneously (channels 1–3), `d` is the difference current, `f` the forward current and `r` the reverse current, in amperes.
- **`Concentrations.txt`**: target concentration (M) of step `n`, one value per line, in step order. The first step is 0 M.

## Acquisition

| | Phenylalanine | Methotrexate | Tobramycin |
|---|---|---|---|
| Instrument | CHI1040C | CHI1040C | CHI1040C |
| Potential window | −0.12 to −0.42 V | −0.10 to −0.40 V | −0.12 to −0.42 V |
| Step (Incr E) | 3 mV | 1 mV | 1 mV |
| Square-wave amplitude | 25 mV | 25 mV | 25 mV |
| Electrodes per scan | 3 | 3 | 3 |

Full settings are in each file's header.

## Scan order

Within each titration, the resistor conditions were measured in alternation at every concentration (for example: no resistor, then added resistor), and the scans were then split into one folder per condition and renumbered 1, 2, 3, …. The `File:` line in each header keeps the original, un-split scan number. At one step the order was reversed: phenylalanine step 3, where the added-resistor scan came first, and methotrexate step 6, where the 2000 Ω scan came first. The concentration of every step is the same in both folders.

## Notes

- The tobramycin `Concentrations.txt` files were written from the experimenter's titration spreadsheet (nominal concentrations 10<sup>−7</sup>, 10<sup>−6.5</sup>, … M, given here to four significant figures).
- Only the text exports used for the figures are included. Not included: CHI binary files (`.bin`), equilibration prescans, titrations at other resistor values, and peak-current tables produced by analysis software.
