---
id: HEXYL-FND
name: Findings register
level: L4
status: DRAFT
origin: reverse-engineered
---

# HEXYL-FND — Findings register

## Purpose

Record anomalies, doc/behaviour mismatches and open questions discovered during reverse engineering. Per the method (section 8), a bug or accident found in the code does not silently become a requirement. Each item needs a human decision: *accept as behaviour* (promote to a requirement via a change proposal), or *fix the implementation*, or *correct the documentation*.

## Description

| ID | Finding | Evidence | Where the spec handles it | Decision |
| --- | --- | --- | --- | --- |
| FND-001 | When `--block-size` is written in hexadecimal (`0x…`), the program validates it and then **exits successfully without displaying anything**. The decimal form works. Likely an unintended early return. Confirmed by running the program (exit 0, no output). | Resolver returns right after validating a hex block size. | CLI-F-006 describes only the intended meaning. L4 `CLI-D-005` records the current behaviour. | OPEN |
| FND-002 | Help text says a negative `--display-offset` is valid and relative to the end of the input; the implementation rejects negative values (`negative offset specified…`), and, when the value is a separate command-line word (`-o -4`, `--skip -2`), the argument parser rejects it before (usage error, exit 2). Only the `=` form reaches the parser of byte counts. Confirmed by running. | Display offset is parsed as a forward-only count. | CLI-F-007 says nothing about negative values. | OPEN |
| FND-003 | Help text says squeezing replaces lines *identical to the preceding group*. The implementation only squeezes lines made of **one repeated byte value** (e.g. all `00`, all `30`); two identical lines of varied content are printed. Confirmed by running (4 identical lines of 16 varied bytes are all printed). | Squeezer compares with the first byte replicated. | REN-F-008 documents the observed rule. | OPEN |
| FND-004 | Whitespace set excludes VT (0x0B), so VT is "ASCII other", whereas the colour-legend text says "ASCII whitespace (0x09 - 0x0D, 0x20)". | Classification uses the usual ASCII whitespace definition (space, TAB, LF, FF, CR). | CHR-F-001 documents the observed set. | OPEN |
| FND-005 | The manual page declares version 0.12.0, and lacks many current options (panels, group size, base, character table, include, …); it also lacks the `force` colour mode. | `doc/hexyl.1.md` | Not a requirement source; L2 is based on the `--help` text and implementation. | OPEN |
| FND-006 | In include mode, the array name is not checked to be a valid C identifier (a name starting with a digit stays so; non-ASCII alphanumerics are kept). | Name builder maps only non-alphanumerics to `_`. | INC-F-002 documents the observed mapping. | OPEN |
| FND-007 | Read errors while dumping are not reported: in the main loop a failed read is ignored and the loop continues with the previous buffer content, which may repeat output indefinitely on a persistent error. | Read result handled with a success-only pattern. | REN-F-010 says nothing. L4 `REN-D-004` notes it. | OPEN |
| FND-008 | `--skip +N` (explicit plus) is accepted, but means the same as `N`; the "from last offset" kind is never used differently. | Kinds are merged when seeking. | CLI-F-005 | ASSUMPTION: harmless; confirm intent. |
| FND-009 | The position panel width is "8 digits minimum, up to 16", but there is no distinction in widths between lines: the width of the position panel is decided line by line; a dump that crosses 0xFFFFFFFF would produce lines with a different width, misaligned with the border. | Digit count derived from each line's offset. | REN-D-003 records the rule. | OPEN |
| FND-010 | For an empty input the "No content" row is hard-coded for 2 panels and with unicode separators: with `--panels=1` the row is wider than the border, with `--border=ascii` or `none` the row still uses unicode separators. | Confirmed by running. | REN-F-009 and `REN-D-007` describe the default layout only. | OPEN |

## References

- Referenced from: L2 documents (`HEXYL-CLI-F`, `HEXYL-REN-F`, `HEXYL-CHR-F`, `HEXYL-COL-F`, `HEXYL-INC-F`) and L4 documents.
