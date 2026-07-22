# 8-bit Arithmetic Logic Unit (ALU) RTL Design & Golden Model Verification

> Verilog HDL • RTL Design • Golden Model Verification (MATLAB) • SystemVerilog File I/O • Intel Quartus Prime • ModelSim • Static Timing Analysis

This project implements a synchronous **8-bit Arithmetic Logic Unit (ALU)** using Verilog HDL. It demonstrates a complete, industry-standard digital IC design flow, featuring an **Automated Golden Model Verification Flow** using MATLAB and SystemVerilog, alongside logic synthesis and timing analysis.

The ALU supports 12 distinct arithmetic, logical, and shift operations (including hardware multiplication and division), producing a 16-bit result to prevent overflow/truncation, along with standard processor status flags: **Carry**, **Zero**, and **Overflow**.

---

## 1. Specification

### Objective

Design a synchronous ALU capable of performing arithmetic and logical operations on two 8-bit operands (`A`, `B`) according to a 4-bit operation selector (`op_code`). The design is driven by a system clock and an enable signal.

### Inputs

| Signal | Width | Description |
|---------|-------|-------------|
| `clk` | 1 | System clock |
| `EN` | 1 | ALU enable signal |
| `op_code` | 4 | Operation selector |
| `A` | 8 | Operand A |
| `B` | 8 | Operand B |

### Outputs

| Signal | Width | Description |
|---------|-------|-------------|
| `result` | 16 | ALU computed result (16-bit to accommodate multiplication) |
| `carry_flag` | 1 | Carry/Borrow indication (valid for ADD/SUB) |
| `zero_flag` | 1 | Result equals zero indication |
| `overflow_flag` | 1 | Signed 2's complement arithmetic overflow |

---

## 2. Supported Operations

| `op_code` | Category | Operation | RTL Implementation |
|---------|----------|-----------|--------------------|
| `0000` | Arithmetic | ADD | `A + B` |
| `0001` | Arithmetic | SUB | `A - B` |
| `0010` | Arithmetic | MUL | `A * B` |
| `0011` | Arithmetic | DIV | `A / B` (with divide-by-zero protection) |
| `0100` | Logical | AND | `A & B` |
| `0101` | Logical | OR | `A | B` |
| `0110` | Logical | XOR | `A ^ B` |
| `0111` | Logical | NOT A | `~A` |
| `1000` | Shift | SHL A | `A << 1` |
| `1001` | Shift | SHR A | `A >> 1` |
| `1010` | Shift | SHL B | `B << 1` |
| `1011` | Shift | SHR B | `B >> 1` |

---

## 3. RTL Implementation & Schematic

**Tool:** Intel Quartus Prime

The ALU is implemented as a synchronous RTL module using a single sequential process triggered by the rising edge of the system clock. 

The architecture incorporates a large multiplexer network driven by the `op_code` and utilizes dedicated DSP blocks for multiplication. The synthesized RTL schematic is shown below:

![RTL Schematic](docs/schematic.png)

A higher resolution version of the schematic is also provided:
- `docs/schematic_high_res.pdf`

---

## 4. Verification & Simulation

**Tools:** MATLAB, ModelSim, Verilog HDL, SystemVerilog

To verify the RTL design, an automated verification flow was developed using a MATLAB Golden Model together with a SystemVerilog File I/O testbench. MATLAB is responsible for generating exhaustive test vectors and the corresponding Golden Model results, while the SystemVerilog testbench applies these vectors to the DUT and records the RTL outputs for comparison.

```text
                 MATLAB
        +---------------------+
        | gen_ALU_vectors.m   |
        +----------+----------+
                   |
      +------------+-------------+
      |                          |
      v                          v
 alu_input.txt             alu_gold.txt
      |
      v
+---------------------------+
| SystemVerilog Testbench   |
| (File I/O)                |
+-------------+-------------+
              |
              v
        ALU RTL (DUT)
              |
              v
      alu_output.txt
              |
              v
      +------------------+
      | verify_ALU.m     |
      +--------+---------+
               |
               v
      PASS / FAIL Report
```

### Verification Flow

1. **Generate Test Vectors**
   - `gen_ALU_vectors.m` exhaustively generates every possible combination of inputs for all supported ALU operations.
   - Two files are produced:
     - `alu_input.txt` containing the input vectors.
     - `alu_gold.txt` containing the expected (Golden Model) results.

2. **RTL Simulation**
   - The SystemVerilog testbench (`tb_ALU_8bit.sv`) reads `alu_input.txt` using File I/O (`$fopen`, `$fscanf`).
   - Each test vector is applied to the ALU RTL at the rising edge of the clock.
   - The RTL outputs are written to `alu_output.txt` using `$fwrite`.

3. **Automatic Result Checking**
   - `verify_ALU.m` compares `alu_output.txt` against `alu_gold.txt`.
   - Every mismatch is reported automatically.
   - If no mismatch is detected, the RTL is considered functionally correct.

### Verification Coverage

- **Operations Tested:** 12 ALU operations
- **Operand Range:** A = 0–255, B = 0–255
- **Total Test Vectors:** **786,432**
- **Verification Method:** Exhaustive verification using MATLAB Golden Model
- **Simulation:** ModelSim with SystemVerilog File I/O

### Verification Result

```
========================================
ALU Verification PASSED
786432 / 786432 vectors matched
Functional correctness = 100%
========================================
```

The RTL implementation successfully matched the MATLAB Golden Model for all **786,432** test vectors, confirming the functional correctness of the ALU design.

![Simulation Waveform](docs/waveform.png)

The waveform confirms the correct execution of all ALU operations. Input operands (`A`, `B`) and `op_code` change synchronously with the clock, while the output `result` and status flags (`carry_flag`, `zero_flag`, and `overflow_flag`) are updated correctly after each rising clock edge.

## 5. Synthesis & Static Timing Analysis (STA)

**Tool:** Intel Quartus Prime TimeQuest Timing Analyzer

Following synthesis, Static Timing Analysis (STA) was performed to evaluate setup timing requirements and identify critical timing paths. 

The introduction of complex arithmetic operations (specifically hardware division `A / B`) extends the critical path. The timing report indicates a worst-case setup requirement of:

- **Max Data Path Delay:** `18.883 ns`
- **Estimated Maximum Frequency (Fmax):** `~52.9 MHz`

![Setup Timing Report](docs/setup_time.png)

---

## 6. Resource Utilization

The synthesized ALU utilizes dedicated hardware DSP blocks for multiplication, highly optimizing the standard logic element consumption.

| Resource | Usage |
|----------|-------|
| Logic utilization (ALMs) | 93 / 41,910 (< 1%) |
| Total Registers (FFs) | 19 |
| Total I/O Pins | 41 / 499 (8%) |
| **DSP Blocks** | **1 / 112 (< 1%)** |

![Resource Utilization](docs/resource.png)

---

## 7. Project Structure

8bit-ALU-SV-Verification/
│
├── README.md
├── .gitignore
│
├── docs/
│   ├── schematic.png
│   ├── schematic_high_res.pdf
│   ├── waveform.png
│   ├── setup_time.png
│   └── resource.png
│
├── rtl/
│   └── ALU_8bit.v
│
├── tb/
│   ├── tb_ALU_8bit.sv
│   └── tb_ALU_8bit_random.v
│
├── matlab/
│   ├── gen_ALU_vectors.m
│   └── verify_ALU.m
│
├── sim/
│   ├── compile.do
│   ├── wave.do
│   └── run.do
│
├── alu_input.txt
├── alu_gold.txt
└── alu_output.txt 

---

## 8. Conclusion

This project serves as a practical demonstration of a complete, industry-standard digital IC verification flow. It showcases:

- **RTL Design:** Parameterized Verilog HDL implementation with DSP inference.
- **Verification Methodology:** End-to-end Automated Golden Model flow.
- **System Integration:** SystemVerilog File I/O (`$fscanf`, `$fdisplay`).
- **Timing Awareness:** Understanding of critical paths, setup time, and trade-offs in hardware arithmetic logic.