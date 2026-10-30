# Nexus Language Guide

> **A Comprehensive, Friendly Manual for Developers at All Levels.**  
> *Learn how to write, structure, run, and optimize programs in Nexus Baremetal.*

---

## 1. Introduction

Nexus Baremetal is designed to provide high-level, expressive code that compiles directly into high-speed bytecode executed by a pure x86-64 assembly engine. You don't need deep assembly knowledge to write Nexus code—it feels familiar, readable, and clean.

### Core Principles
- **Predictable Performance**: Everything runs with direct-threaded execution speed.
- **Safety by Default**: Automatic bounds checking, safe memory arenas, and vectored exception containment ensure your program never crashes the operating system.
- **Microarchitectural Efficiency**: Native support for direct hardware GPU acceleration, vector instructions, and sub-nanosecond timers.

---

## 2. Syntax Basics

### Comments
Nexus supports standard single-line and multi-line comments:

```nexus
// This is a single line comment

/* This is a multi-line
   comment that can span
   multiple lines */
```

### Statements and Semicolons
Statements in Nexus typically end with a semicolon (`;`). Semicolons clarify statement boundaries for the parser:

```nexus
let a = 10;
let b = 20;
let c = a + b;
```

---

## 3. Data Types and Variables

Variables are created using the `let` keyword:

```nexus
// Numbers (64-bit double precision float)
let count = 42;
let price = 19.99;
let temperature = -5.4;

// Strings (dynamically sized text with cached length)
let greeting = "Hello, Nexus!";
let empty_str = "";

// Booleans (represented numerically: 1.0 for true, 0.0 for false)
let is_ready = 1.0;
let is_finished = 0.0;
```

### Type Conversion
You can convert numbers to strings using `to_string()`:

```nexus
let score = 95;
let output = "Your score is " + to_string(score);
print(output);
```

---

## 4. Input and Output

### Printing Output (`print`)
The `print()` function directly prints strings, numbers, arrays, and dictionaries:

```nexus
print("Calculation complete.");
print(100.5);
print([1, 2, 3]);
print({ "status": "active" });
```

### Reading User Input (`input` / `read_line`)
To ask the user for input via the terminal, use `input()` or `read_line()`:

```nexus
let user_name = input("Enter your username: ");
print("Welcome back, " + user_name + "!");

let user_age = input("Enter your age: ");
print("You entered: " + user_age);
```

Behind the scenes, Nexus uses a high-speed 64 KB line-buffered reader (`op_input` in `src/vm/nexus_core.s`) that eliminates operating system syscall delays and normalizes newlines (`\r\n` and `\n`) safely.

---

## 5. Operators and Expressions

### Arithmetic Operators
| Operator | Description | Example | Result |
| :---: | :--- | :--- | :--- |
| `+` | Addition | `10 + 5` | `15` |
| `-` | Subtraction | `10 - 5` | `5` |
| `*` | Multiplication | `10 * 5` | `50` |
| `/` | Division | `10 / 5` | `2` |
| `%` | Modulo (Remainder) | `10 % 3` | `1` |

### Comparison Operators
All comparisons return `1.0` (true) or `0.0` (false):
| Operator | Meaning | Example |
| :---: | :--- | :--- |
| `==` | Equal to | `score == 100` |
| `!=` | Not equal to | `status != 0` |
| `<` | Less than | `speed < 60` |
| `<=` | Less than or equal to | `age <= 18` |
| `>` | Greater than | `height > 150` |
| `>=` | Greater than or equal to | `level >= 10` |

### Logical Operators
- `&&`: Logical AND
- `||`: Logical OR
- `!`: Logical NOT

```nexus
let can_proceed = (user_age >= 18) && (is_ready == 1.0);
```

---

## 6. Control Flow

### If / Else Conditions
Execute code blocks conditionally based on expressions:

```nexus
let health = 75;

if health > 80 {
    print("Status: Excellent");
} else if health > 40 {
    print("Status: Moderate");
} else {
    print("Status: Critical!");
}
```

### While Loops
Repeat code while a condition remains true:

```nexus
let counter = 0;
while counter < 5 {
    print("Tick: " + to_string(counter));
    counter = counter + 1;
}
```

---

## 7. Functions

Functions allow you to group reusable code. Define them with `fn`:

```nexus
fn add_numbers(a, b) {
    let result = a + b;
    return result;
}

let total = add_numbers(25, 75);
print("Total: " + to_string(total));
```

### Unbounded Arguments Scaling
Nexus supports **unbounded function arguments**. While conventional languages cap parameter lists at 255 arguments, Nexus uses a two-tier architecture:
- Fast registers for arguments 0 through 255.
- Dynamic spill arena buffers for arguments 256 through 10,000+.
You will never encounter an "argument list overflow" error in Nexus.

---

## 8. Arrays and Dictionaries

### Arrays
Arrays are dynamic, ordered lists:

```nexus
let fruits = ["Apple", "Banana", "Cherry"];

// Access by index (0-based)
print(fruits[0]); // "Apple"

// Append an element
fruits = Array.push(fruits, "Dragonfruit");

// Pop the last element
let last = Array.pop(fruits);

// Length of array
let count = Array.len(fruits);
```

### Dictionaries
Dictionaries store key-value mappings:

```nexus
let config = {};
config["host"] = "127.0.0.1";
config["port"] = 8080;
config["debug"] = 1.0;

print("Connecting to: " + config["host"]);
```

---

## 9. Classes and Object-Oriented Programming

Classes group related functions and data models:

```nexus
class Player {
    fn create(player_name, initial_health) {
        let p = {};
        p["name"] = player_name;
        p["health"] = initial_health;
        return p;
    }

    fn take_damage(p, damage_amount) {
        p["health"] = p["health"] - damage_amount;
        if p["health"] < 0 {
            p["health"] = 0;
        }
        return p;
    }
}

let hero = Player.create("Aria", 100);
hero = Player.take_damage(hero, 25);
print(hero["name"] + " health: " + to_string(hero["health"])); // 75
```

### Adaptive Flat-to-Hash Object Model
Nexus objects scale automatically:
- Objects with up to 64 fields use fast inline arrays.
- Objects with more than 64 fields promote to dynamic hash tables.
This ensures small objects are lightweight and large objects have zero limit on attribute count.

---

## 10. Universal Dot Syntax

Nexus provides universal dot syntax for instances:

```nexus
let message = "nexus baremetal";

// String methods:
print(message.len());        // O(1) length from header
print(message.upper());      // "NEXUS BAREMETAL"
print(message.slice(0, 5));  // "nexus"

// Array methods:
let list = [10, 20, 30];
list.push(40);
print(list.len());           // 4
```

---

## 11. Standard Library Modules

To use a standard module, import it at the top of your file:

```nexus
import stdlib;
import stddata;
import stdgpu;
import stdtensor;
import stdtorch;
import stdlsp;
import stdpkg;
import stdprofile;
```

### Standard Module Overview

| Module | Purpose | Key Classes & Functions |
| :--- | :--- | :--- |
| **`stdlib`** | Core system functionality | `Math` (`sin`, `cos`, `sqrt`, `pow`), `String` (`len`, `substring`), `Array`, `Crypto` (`sha256`, `md5`, `hmac`), `Channel`, `System.cpu_cycles` |
| **`stddata`** | Tabular and scientific data | `NDArray`, `Series` (`sum`, `mean`), `DataFrame` (`filter`, column indexing) |
| **`stdgpu`** | Baremetal hardware GPU compute | `GPU.sync`, `Stream.sync`, `GPUMemory.alloc`, `GEMM.matmul` |
| **`stdtensor`** | Multi-dimensional tensor mathematics | `Tensor.create`, `Tensor.shape`, `TensorMath.add`, `TensorNN.linear` |
| **`stdtorch`** | Deep learning & LLM inference | `LinearLayer`, `Sequential`, `FlashAttention.forward`, `QuantGEMM.forward` |
| **`stdlsp`** | Language Server Protocol | `LSPProtocol.frame`, `LSPDiagnostics.validate`, `LSPCompletions.get_items` |
| **`stdpkg`** | Package & lockfile manager | `PackageManifest.create`, `PackageLockfile.record_module`, `verify_integrity` |
| **`stdprofile`** | Hardware performance profiler | `ProfileRecord.create`, `Profiler.benchmark`, `Profiler.print_summary` |

---

## 12. Hardware Profiling Example

Measure the exact CPU cycle cost of any function using `stdprofile`:

```nexus
import stdlib;
import stdprofile;

fn compute_workload() {
    let x = 123.45;
    let y = 678.90;
    return x * y + 3.14159;
}

fn main() {
    let metrics = Profiler.benchmark("Compute Task", 10000, compute_workload);
    Profiler.print_summary(metrics);
}

main();
```

Output:
```text
------------------------------------------------------------------
NEXUS HARDWARE PROFILER METRICS: Compute Task
------------------------------------------------------------------
  Iterations:       10000
  Total CPU Cycles: 1542300
  Avg Cycles/Op:    154.23
  VRAM Delta:       0 bytes
------------------------------------------------------------------
```

---

## 13. Understanding Diagnostic Errors

When an issue occurs, Nexus provides a clear Rust-style diagnostic report:

```text
error[E0101]: delimiter error: unmatched closing parenthesis ')'
  --> src/main.nx:14:28
   |
14 |     let total = (x + y * 2));
   |                            ^
   = note: unexpected delimiter without corresponding opener
   = help: verify matching brackets and parentheses in expression
```

### Common Error Codes
- `E0001`: Syntax error (unexpected keyword or token).
- `E0002`: Unclosed string literal (missing ending `"`).
- `E0101`: Unmatched parenthesis `)` or `(`.
- `E0102`: Unclosed curly brace `{` or `}`.
- `E0502`: Unresolved method or function call.
- `E0503`: Division by zero.
- `W0001`: Unreachable dead code warning.
