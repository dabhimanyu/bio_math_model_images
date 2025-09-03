# TIRFM v2 Protocol (Phase 1-Checks)

This repository standardizes our TIRF analysis workflow into **reproducible, config‑driven runs**. Here, we focus on:
- a strict‑JSON config system, (strict in a sense - without any comments)
- a top‑level runner that creates isolated timestamped run folders, and
- provenance capture via `RUN_INFO.json`.

Later on we will add preprocessing, masking, detection, tracking, and CSV/MAT/overlay outputs.

---

## What’s included in Here:
- **Drivers:** `run_case.m` (dry‑run only)
- **Helpers:** `load_config.m`, `build_run_dir.m`, `list_input_images.m`
- **Docs:** this README, a User Guide, and a commented `CONFIG_REFERENCE`
- **Configs:** you provide three strict JSONs under `configs/`

---


## Prerequisites
- MATLAB **R2021a or newer** recommended (pretty JSON output). Older versions work but without nice printing. Not the end of the day. We can still use this code :-) 
- Image Processing Toolbox.

---


## Quickstart: from zero to a dry‑run
1. **Set absolute paths in your JSONs** under `configs/` (`*_default.json`).
2. **Open MATLAB** and go to where your repo is and add the repo to your path:
```matlab
addpath(genpath(pwd));

Run any config to perform a dry‑run:
run_case('configs/beads_default.json');
run_case('configs/synthetic_default.json');
run_case('configs/tirf_default.json');
Inspect outputs: each call creates outputs in the output folder containing RUN_INFO.json.

```
---

# What the dry‑run proves
- Your JSON parses and passes validation.
- Paths are correct and input files are discoverable.
- You have write permissions to outputs/.

---
# Troubleshooting
- **JSON error** → remove comments/trailing commas; ensure quotes around all strings.
- **No files matched** → check io.input_root and io.file_glob (try *.tif), confirm files exist.
- **Permission denied** → choose a different io.output_root or fix OS permissions.

---