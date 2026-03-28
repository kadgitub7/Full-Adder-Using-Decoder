# Full Adder Using Decoder | Verilog

![Language](https://img.shields.io/badge/Language-Verilog-blue)
![Tool](https://img.shields.io/badge/Tool-Xilinx%20Vivado-red)
![Type](https://img.shields.io/badge/Type-Combinational%20Logic-green)
![Status](https://img.shields.io/badge/Simulation-Passing-brightgreen)

A Verilog implementation of a **Full Adder using a 3×8 Decoder**, designed and simulated in **Xilinx Vivado**.

This document explains:
- What a full adder is and how it maps to a decoder
- How minterms are derived from the truth table
- The boolean expressions, K-Map, implementation details, and simulation results

The project includes the RTL design, testbench, and console-style output verifying correct behavior.

---

## Table of Contents

1. [What Is a Full Adder Using a Decoder?](#what-is-a-full-adder-using-a-decoder)
2. [How the Circuit Works](#how-the-circuit-works)
3. [Truth Table](#truth-table)
4. [Minterm Assignment](#minterm-assignment)
5. [Boolean Expressions](#boolean-expressions)
6. [K-Map](#k-map)
7. [Verilog Implementation](#verilog-implementation)
8. [Testbench](#testbench)
9. [Testbench Output](#testbench-output)
10. [Circuit Diagram](#circuit-diagram)
11. [Waveform Diagram](#waveform-diagram)
12. [Running the Project in Vivado](#running-the-project-in-vivado)
13. [Project Files](#project-files)

---

## What Is a Full Adder Using a Decoder?

A **full adder** is a combinational logic circuit that computes the sum of three binary inputs: `A`, `B`, and carry-in `Cin`. It produces two outputs: a **sum bit** `S` and a **carry-out** `Co`.

A **3×8 decoder** takes a 3-bit binary input and asserts exactly one of its eight output lines — corresponding to the input's minterm. By connecting these minterm outputs through OR gates, any combinational function of three variables can be implemented directly.

> **Key idea:** A decoder generates all minterms of its inputs. Any boolean function can then be expressed as a sum of selected minterms.

---

## How the Circuit Works

With three inputs (`A`, `B`, `Cin`), there are `2³ = 8` possible input combinations, labeled `m0` through `m7`. The decoder asserts exactly one output line per input combination.

Two OR gates combine the appropriate decoder outputs to realize `S` and `Co`:

```
S  = Σ(m1, m2, m4, m7)
Co = Σ(m3, m5, m6, m7)
```

---

## Truth Table

| A | B | Cin | S | Co |
|:-:|:-:|:---:|:-:|:--:|
| 0 | 0 |  0  | 0 |  0 |
| 0 | 0 |  1  | 1 |  0 |
| 0 | 1 |  0  | 1 |  0 |
| 0 | 1 |  1  | 0 |  1 |
| 1 | 0 |  0  | 1 |  0 |
| 1 | 0 |  1  | 0 |  1 |
| 1 | 1 |  0  | 0 |  1 |
| 1 | 1 |  1  | 1 |  1 |

---

## Minterm Assignment

Each row of the truth table is assigned a minterm label `m0`–`m7` based on the decimal value of `{A, B, Cin}`:

| A | B | Cin | S | Co | Minterm |
|:-:|:-:|:---:|:-:|:--:|:-------:|
| 0 | 0 |  0  | 0 |  0 | `m0`    |
| 0 | 0 |  1  | 1 |  0 | `m1`    |
| 0 | 1 |  0  | 1 |  0 | `m2`    |
| 0 | 1 |  1  | 0 |  1 | `m3`    |
| 1 | 0 |  0  | 1 |  0 | `m4`    |
| 1 | 0 |  1  | 0 |  1 | `m5`    |
| 1 | 1 |  0  | 0 |  1 | `m6`    |
| 1 | 1 |  1  | 1 |  1 | `m7`    |

---

## Boolean Expressions

The outputs are expressed as the OR of the minterms where each output equals `1`:

```
S  = Σ(m1, m2, m4, m7)
Co = Σ(m3, m5, m6, m7)
```

- **`S`** is high when an odd number of inputs are `1` (XOR behavior)
- **`Co`** is high when two or more inputs are `1`

---

## K-Map

### Sum (S)

|  A \ BCin  | 00 | 01 | 11 | 10 |
|:----------:|:--:|:--:|:--:|:--:|
|   **0**    |  0 |  1 |  0 |  1 |
|   **1**    |  1 |  0 |  1 |  0 |

No simplification — `S` implements a 3-input XOR function.

### Carry-Out (Co)

|  A \ BCin  | 00 | 01 | 11 | 10 |
|:----------:|:--:|:--:|:--:|:--:|
|   **0**    |  0 |  0 |  1 |  0 |
|   **1**    |  0 |  1 |  1 |  1 |

Groups: `AB`, `ACin`, `BCin` — simplifies to the standard carry expression `Co = AB + ACin + BCin`.

---

## Circuit Diagram

Below is a circuit diagram illustrating the 3×8 decoder and OR gate structure used to implement the full adder:

![Full Adder Decoder Circuit](/imageAssets/FullAdderDecoderCircuit.png)

---

## Waveform Diagram

Below is the waveform diagram captured when running the simulation using the files in this project:

![Full Adder Decoder Waveform](/imageAssets/FullAdderDecoderWaveform.png)

---

## Verilog Implementation

```verilog
`timescale 1ns / 1ps

module fullAdderDecoder(
    input  A, B, C,
    output [7:0] out,
    output S, Co
    );

    assign out[0] = ~A & ~B & ~C;
    assign out[1] = ~A & ~B &  C;
    assign out[2] = ~A &  B & ~C;
    assign out[3] = ~A &  B &  C;
    assign out[4] =  A & ~B & ~C;
    assign out[5] =  A & ~B &  C;
    assign out[6] =  A &  B & ~C;
    assign out[7] =  A &  B &  C;

    assign S  = out[1] | out[2] | out[4] | out[7];
    assign Co = out[3] | out[5] | out[6] | out[7];

endmodule
```

---

## Testbench

```verilog
`timescale 1ns / 1ps

module fullAdderDecoder_tb();
    reg A, B, C;
    wire [7:0] out;
    wire S, Co;

    fullAdderDecoder uut(A, B, C, out, S, Co);

    integer i;
    initial begin
        for (i = 0; i < 8; i = i + 1) begin
            {A, B, C} = i;
            #10 $display("A=%b, B = %b, C=%b, S = %b, Co = %b", A, B, C, S, Co);
        end
    end
endmodule
```

---

## Testbench Output

Console output confirming correct full adder behavior:

```
A=0, B = 0, C=0, S = 0, Co = 0
A=0, B = 0, C=1, S = 1, Co = 0
A=0, B = 1, C=0, S = 1, Co = 0
A=0, B = 1, C=1, S = 0, Co = 1
A=1, B = 0, C=0, S = 1, Co = 0
A=1, B = 0, C=1, S = 0, Co = 1
A=1, B = 1, C=0, S = 0, Co = 1
A=1, B = 1, C=1, S = 1, Co = 1
```

**Verification summary:**
- `S` is `1` for inputs `001`, `010`, `100`, `111` — odd number of high inputs (XOR behavior)
- `Co` is `1` for inputs `011`, `101`, `110`, `111` — two or more high inputs

---

## Running the Project in Vivado

### 1. Launch Vivado

Open **Xilinx Vivado**.

### 2. Create a New RTL Project

1. Click **Create Project**
2. Select **RTL Project**
3. Optionally enable *Do not specify sources at this time*, or add source files directly

### 3. Add Source Files

| Role              | File                        |
|-------------------|-----------------------------|
| Design Source     | `fullAdderDecoder.v`        |
| Simulation Source | `fullAdderDecoder_tb.v`     |

> Set `fullAdderDecoder_tb.v` as the **simulation top module**.

### 4. Run Behavioral Simulation

Navigate to:

```
Flow → Run Simulation → Run Behavioral Simulation
```

Observe the signals in the waveform viewer:

```
Inputs : A, B, C
Outputs: out[7:0], S, Co
```

Verify that the waveform output matches the truth table and the console output listed above.

---

## Project Files

| File                     | Description                                                                        |
|--------------------------|------------------------------------------------------------------------------------|
| `fullAdderDecoder.v`     | 3×8 decoder + OR gate full adder RTL module                                        |
| `fullAdderDecoder_tb.v`  | Testbench — iterates all 8 input combinations and displays `S` and `Co` outputs    |

---

## Author

**Kadhir Ponnambalam**

---

*Designed and simulated using Xilinx Vivado.*