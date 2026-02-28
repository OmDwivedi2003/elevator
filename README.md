## 🚀 Elevator Controller using Verilog (FSM Based RTL Design)

This project implements a 4-floor Elevator Control System using a Moore Finite State Machine (FSM) in Verilog. The controller manages floor movement, door operations, and request handling using synchronous digital design principles.

The design includes RTL implementation, simulation testbench, and waveform verification.

---

## 🧠 Design Overview

The elevator controller is implemented using a 5-state Moore FSM:

1. **IDLE** – Waits for floor request
2. **MOVING_UP** – Moves elevator upward
3. **MOVING_DOWN** – Moves elevator downward
4. **OPEN_DOOR** – Opens door for fixed duration
5. **CLOSE_DOOR** – Closes door and returns to IDLE

### Key Characteristics:

* Moore FSM architecture
* Outputs depend only on present state
* 4-floor support (0–3)
* 1 floor movement per clock cycle
* Door open delay of 3 clock cycles
* Asynchronous active-high reset
* Negative-edge clock triggered design

---

## ⚙️ Inputs & Outputs

### Inputs:

* `clk` – System clock
* `rst` – Asynchronous reset
* `floor_req[1:0]` – Requested floor

### Outputs:

* `move_up` – Elevator moving upward
* `move_down` – Elevator moving downward
* `door_open` – Door open signal

---

## 🔄 Working Principle

1. In IDLE state, the controller compares current floor with requested floor.
2. If request is higher → MOVING_UP state.
3. If request is lower → MOVING_DOWN state.
4. When destination is reached → OPEN_DOOR state.
5. Door remains open for 3 clock cycles.
6. CLOSE_DOOR state transitions back to IDLE.

---

## 🧪 Testbench & Simulation

A simulation testbench is developed to verify:

* Upward movement (0 → 2)
* Downward movement (2 → 0)
* Upward movement (0 → 3)
* Door open timing behavior

Waveforms confirm correct state transitions and signal timing.

---

## 📊 FSM Type

This design is implemented as a **Moore FSM**, where:

```
Outputs = f(current_state)
```

Input (`floor_req`) only affects state transitions.

---

## 🏗️ RTL Implementation Features

* Clean state encoding
* Sequential state transition logic
* Door delay counter implementation
* Synthesizable RTL design
* Simulation verified

---

## 🔧 Tools Used

* Verilog HDL
* ModelSim / Vivado Simulator (or whichever you used)
* RTL Simulation
* Waveform analysis

---

## 📌 Future Improvements

* Support for multiple floor requests (queue based system)
* Priority scheduling logic
* Scalable parameterized floor design
* Mealy FSM optimization
* Synthesis & FPGA implementation
* Assertion-based verification (SystemVerilog)

---

## 🎯 Learning Outcomes

* Practical FSM implementation
* State transition logic design
* RTL coding best practices
* Simulation-based verification
* Moore vs Mealy FSM comparison
* Digital system timing understanding

---
