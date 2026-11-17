---
id: HEXYL-CLI-D-RES
name: Option resolution and run sequence
level: L4
status: DRAFT
origin: reverse-engineered
---

# HEXYL-CLI-D-RES — Option resolution and run sequence

## Purpose

Specify how the option set becomes printer settings and an input reader (`HEXYL-CLI-C-003`, `-004`, `-005`).

## Description

### HEXYL-CLI-D-005 — Run sequence

```
function run(args) : Success | Error
  opt := parse(args)                          // may print help/version/usage error and exit
  if opt.printColorTable then return printColorTable()
  if opt.completion = shell then write completion script to standard output; return
  reader := open(opt.file)                    // "-" or none: standard input
     if opt.file is directory: Error "'<file>' is a directory."
     else if cannot open: Error (system)
  if opt.blockSize is hex number then         // see FND-001
        validate positive; return Success (nothing displayed)
  blockSize := resolveBlockSize(opt.blockSize)
  skipArg   := opt.skip ? parseByteOffset(opt.skip, blockSize) (context: --skip) : none
  skipPos   := skipArg ? reader.seek(...) (D-INP-002) : 0
  limit     := opt.length ? parseCount(opt.length)  (context: --length) : none
  reader    := limit ? first(limit bytes of reader) : reader
  settings  := resolveSettings(opt)           // D-006 … D-010
  displayOffset := parseCount(opt.displayOffset) (context: --display-offset)
  printer.displayOffset(skipPos + displayOffset)
  printer.printAll(reader)
```

`parseCount(text) := parseByteOffset(text, blockSize)`, which must be of kind other than `BackwardFromEnd`.

Note on order: the input is opened before any value is validated; the order of the checks above defines which error is reported first.

### HEXYL-CLI-D-006 — Colour decision

```
noColor := environment variable NO_COLOR is set (any value, even empty)
showColor := case opt.color of
   never  -> false
   always -> not noColor
   force  -> true
   auto   -> not noColor and standardOutputSupportsBasicColour()
```

Default of `opt.color` is `always`, or `never` if `--plain` is present (and `--color` is absent).

### HEXYL-CLI-D-007 — Panels

```
function maxPanels(width, baseDigits, groupSize)
  offset   := showPositionPanel ? 10 : 1
  colWidth := (8 div groupSize) * (baseDigits * groupSize + 1) + 2 + (showCharPanel ? 8 : 0)
  if saturatingSub(width, offset) div colWidth < 1 then 1 else (width - offset) div colWidth

terminalWidth := terminal width if known else 80
panels :=
  opt.panels = "auto"       -> maxPanels(terminalWidth, ...)
  opt.panels = number       -> number (positive integer, error: "failed to parse `--panels` arg ... as unsigned nonzero integer")
  opt.terminalWidth given   -> maxPanels(opt.terminalWidth, ...)
  otherwise                 -> min(2, maxPanels(terminalWidth, ...))
```

`--terminal-width` and `--panels` are mutually exclusive (argument model). `baseDigits`: see D-008.

### HEXYL-CLI-D-008 — Base

```
baseDigits: Binary 8, Octal 3, Decimal 3, Hexadecimal 2
if opt.base parses as unsigned 8-bit integer n:  2→Binary, 8→Octal, 10→Decimal, 16→Hexadecimal, else Error
      "The number provided is not a valid base. Valid bases are 2, 8, 10, and 16."
else lowercase name table: b|bin|binary, o|oct|octal, d|dec|decimal, x|hex|hexadecimal, else Error
      "The base provided is not valid. Valid bases are \"b\", \"o\", \"d\", and \"x\"."
```

### HEXYL-CLI-D-009 — Other derived settings

```
showCharPanel     := not opt.noCharacters and not opt.plain
showPositionPanel := not opt.noPosition   and not opt.plain
border            := opt.border   (default none when --plain given and --border absent)
squeeze           := not opt.noSqueezing
groupSize         := opt.groupSize (1|2|4|8)
endianness        := opt.littleEndianShortFlag ? Little : opt.endianness
includeMode       := if not opt.include then Off
                     else if opt.file absent then Stdin
                     else if opt.file = "-" then File("stdin")
                     else File(fileNameWithoutDirectory(opt.file) or "file")
```

### HEXYL-CLI-D-010 — Exit protocol

```
main:
  result := run()
  if result is Error:
     if cause is an I/O error of kind BrokenPipe: exit(0)
     write "Error: " ⊕ describe(cause) to standard error;  exit(1)
```

### HEXYL-CLI-D-011 — Colour legend

Output (each category line starts with the category colour sequence and ends with the reset sequence):

```
hexyl color reference:
<blank line>
⋄ NULL bytes (0x00)
a ASCII printable characters (0x20 - 0x7E)
_ ASCII whitespace (0x09 - 0x0D, 0x20)
• ASCII control characters (except NULL and whitespace)
× Non-ASCII bytes (0x80 - 0xFF)
```

(See FND-004. The printable line says 0x20–0x7E although 0x20 is classified as whitespace; this only affects the legend text.)

## Constraints

```
context OptionSet inv: terminalWidth.notEmpty() implies panels.isEmpty()
context OptionSet inv: include implies (not littleEndianShortFlag and endianness = default)
```

## Verification

Specified at L5 (`L5-test/`); results and gaps in `HEXYL-TEST-RES`.

## References

- Realises: `HEXYL-CLI-F-001`…`-018`
- Findings: FND-001, FND-002, FND-004
