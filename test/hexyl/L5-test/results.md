---
id: HEXYL-TEST-RES
name: Test results, coverage and detected errors
level: L5
status: DRAFT
origin: reverse-engineered
---

# HEXYL-TEST-RES — Test results, coverage and detected errors

## Run

Version 0.17.0, run on 2026-11-17 with the project's own test suite, offline: 56 tests, 56 passed, 0 failed.

| Suite | Tests | Passed | Described in |
| --- | --- | --- | --- |
| Unit, command-line part | 5 | 5 | `unit.md` U-CLI-1…5 |
| Unit, rendering engine | 10 | 10 | `unit.md` U-REN-1…10 |
| Integration (end-to-end) | 41 | 41 | `functional.feature` |

## Errors detected by the existing tests

None. All existing tests pass, so no test detects a defect in the current implementation.

## Errors detected by additional manual checks

The following were found by running the program during reverse engineering. They are not caught by any existing test. They are recorded in `L4-detailed/findings.md`; status stays `OPEN` until a human decides.

| Finding | Check | Observed | Expected by documentation |
| --- | --- | --- | --- |
| FND-001 | `hexyl --block-size=0x10 file` | exit 0, nothing printed | a dump |
| FND-002 | `hexyl --display-offset=-4 file` | error "negative offset specified…" (exit 1) | negative values valid (help text). Also `--skip -2` and `-o -4` (value as separate word) are rejected by the argument parser (exit 2); only the `=` form works (`--skip=-4` is covered by a test). |
| FND-003 | 64 bytes made of 4 identical lines of varied bytes | all 4 lines printed | lines identical to the preceding group are replaced |
| FND-004 | byte `0x0b` | shown as `•` (ASCII other) | legend says whitespace is 0x09–0x0D |
| FND-009 | `-o 0x100000000` | offset shown with 10 digits, misaligned with the border | not specified |
| FND-010 | empty input with `--panels=1`, `--border=ascii` or `--border=none` | the "No content" row is always drawn for 2 panels and with unicode separators, so it does not match the border | not specified |

## Coverage of the specification

| Area | Covered by existing tests | Not covered |
| --- | --- | --- |
| Input (`INP-F`) | stdin, file, skip, skip from end, skip past end, too-large negative skip | skip on a pipe, error on a directory |
| Command line (`CLI-F`) | length, skip, display offset, block-size errors, plain, panels visibility, group size, endianness, base 2, tables ascii/437/1047, colour reference outputs; byte-count parser (unit) | bases 8 and 10, border styles, `--panels=auto`, `--terminal-width`, `--print-color-table`, `--completion`, help and version, exit status mapping of a closed pipe, option conflicts other than the alias pairs |
| Rendering (`REN-F`) | layout, offsets, partial last line, squeezing (several panel and option combinations), empty input | `--no-squeezing`, more than 4 panels end-to-end, other border styles |
| Characters (`CHR-F`) | ascii, codepage-437, codepage-1047, but only for the 46 distinct byte values present in the test file (of 256) | 210 of 256 byte values for each code page table; default table (only indirectly), braille |
| Colour (`COL-F`) | default scheme on all categories | gradient, `NO_COLOR`, `force`/`auto`, `HEXYL_COLOR_*` overrides, invalid override |
| Include export (`INC-F`) | file name and stdin forms (unit) | name sanitising, empty input, skip and length with include, conflicts with endianness |
| L4 algorithms | parser grammar and errors, squeezing, partial line | gradient construction, braille mapping, input source seek, option resolution |

## References

- Verifies: `HEXYL-FUNC` (L2) and L4 documents; findings: `../L4-detailed/findings.md`.
