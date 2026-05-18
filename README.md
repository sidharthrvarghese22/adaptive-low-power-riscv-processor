# Adaptive Low-Power Pipelined 32-bit RISC-V Processor

## Overview

This project implements a pipelined 32-bit RISC-V processor in Verilog HDL with:

- 5-stage pipelining
- Hazard detection
- Data forwarding
- Branch handling
- Pipeline flushing
- Adaptive clock gating
- Load/store support

Designed for low-power edge AI applications.

---

## Features

### Processor Architecture
- 32-bit RISC-V ISA
- Single-cycle datapath
- 5-stage pipeline

### Pipeline Stages
- IF
- ID
- EX
- MEM
- WB

### Hazard Handling
- Forwarding Unit
- Hazard Detection Unit
- Pipeline Stall Logic

### Branch Logic
- Branch target calculation
- Branch flush mechanism

### Low Power Features
- Clock gating
- Adaptive pipeline clock control
- Memory stage clock gating

---

## Tools Used

- Verilog HDL
- Icarus Verilog
- Surfer Waveform Viewer
- GitHub
- macOS Terminal

---

## Folder Structure

```text
rtl/    -> RTL Verilog modules
tb/     -> Testbench