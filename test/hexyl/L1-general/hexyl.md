---
id: HEXYL-SYS-001
name: hexyl system overview
level: L1
status: DRAFT
origin: reverse-engineered
---

# HEXYL-SYS-001 — hexyl system overview

> Reverse-engineered from the implementation (version 0.17.0), its documentation and its tests. Not reviewed or approved by a human (C-010). Anomalies are recorded in `../L4-detailed/findings.md` and are not requirements.

## Purpose

hexyl is a hex viewer for the terminal. It shows the bytes of a file or of a standard-input stream as an offset-annotated dump, with a character panel next to the numeric panels. Bytes are coloured by category so that structure in binary data is easy to see (NULL bytes, printable ASCII, ASCII whitespace, other ASCII, non-ASCII).

## Description

### Objectives

- OBJ-1: Give a readable, colour-assisted view of binary data in a terminal.
- OBJ-2: Let the user select the part of the input to display, and the layout (panels, grouping, base, endianness, borders).
- OBJ-3: Work in pipelines (standard input and output, quiet exit on closed pipe).
- OBJ-4: Offer an alternative export of bytes as C source (`xxd -i` style).

### Scope

In scope: display of a byte stream from a file or standard input; layout and rendering; byte classification and character mapping; colouring and its configuration; C-include export; the command-line interface.

Out of scope (observed absence, not a stated exclusion — to be confirmed by a reviewer):

- editing or writing binary data;
- interactive paging, searching or navigation (the user may pipe into a pager);
- reverse conversion from a dump to binary.

### Users and other actors

| Actor | Role |
| --- | --- |
| Terminal user | Runs the tool interactively. |
| Script or pipeline | Runs the tool non-interactively, with the output piped or redirected. |
| Developer (library user) | Embeds the rendering engine in another program. This is a secondary use, observed in the existence of a public library interface and an example program. |

### Operating context

- Invoked as a command-line program, with input from a named file or from standard input and output on standard output.
- Written for terminals that support ANSI escape sequences and Unicode output.
- Reads these environment variables: `NO_COLOR`, `HEXYL_COLOR_*` (see `HEXYL-SYS-001`).
- Uses the terminal width when it is available (default 80 columns otherwise).

### Main capabilities

1. Dump bytes with offset, numeric panel(s) and character panel.
2. Select a byte range: skip, length, block units.
3. Choose layout: number of panels, group size, endianness, base 2/8/10/16, border style, optional panels.
4. Collapse runs of repeated data ("squeezing").
5. Colour bytes by category or with a gradient scheme, with user-configurable colours.
6. Choose a character table: default, ASCII, CP437, CP1047, braille.
7. Export bytes as C include data.
8. Print a colour legend and generate shell completions.

### External systems and dependencies

- Operating system file and standard streams.
- Terminal emulator (ANSI colours, Unicode).
- Environment variables listed above.

### Global constraints

- GC-1: The dump output is deterministic for given input and options, with colour disabled (see `HEXYL-SYS-001`).
- GC-2: Memory use must not depend on input size. The input is streamed (observed).
- GC-3: A closed output pipe is not an error (exit status 0, observed).
- GC-4: Licence: dual Apache-2.0 / MIT.

### Implementation environment (C-001 — the only place where this is stated)

| Item | Value (observed) |
| --- | --- |
| Language | Rust, edition 2021, minimum toolchain 1.88 |
| Artefacts | one library crate (`hexyl`) and one command-line binary (`hexyl`) in the same package |
| Version | 0.17.0 |
| Main third-party components | `clap` (argument parsing, completions), `owo-colors` and `supports-color` (colours), `terminal_size`, `anyhow`/`thiserror` (errors), `libc`, `const_format` |
| Test tooling | `assert_cmd`, `predicates`, `pretty_assertions` |
| Platforms | Unix-like systems, macOS, Windows (terminal with ANSI support) |
| Author / upstream | David Peter, <https://github.com/sharkdp/hexyl> |

## Constraints

See *Global constraints* above.

## Verification

Acceptance of this document is by review. Detailed verification is referenced from L2 and L4.

## References

- Refined by: L2 `HEXYL-FUNC`, L3 `HEXYL-ARCH-001`, L4 documents, L5 tests (`../L5-test/`).
- Open findings: `../L4-detailed/findings.md`
