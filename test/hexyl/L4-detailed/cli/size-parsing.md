---
id: HEXYL-CLI-D-SZ
name: Byte-count parsing
level: L4
status: DRAFT
origin: reverse-engineered
---

# HEXYL-CLI-D-SZ — Byte-count parsing

## Purpose

Specify the grammar and algorithm of the size parser (`HEXYL-CLI-C-002`). Realises `HEXYL-CLI-F-003`, `-004`, `-005`, `-006`, `-007`.

## Description

### HEXYL-CLI-D-001 — Data model

```
Unit        := Byte | Kilobyte | Megabyte | Gigabyte | Terabyte
             | Kibibyte | Mebibyte | Gibibyte | Tebibyte | Block(customSize?)
multiplier  := Byte 1; Kilobyte 10^3; Megabyte 10^6; Gigabyte 10^9; Terabyte 10^12;
               Kibibyte 2^10; Mebibyte 2^20; Gibibyte 2^30; Tebibyte 2^40;
               Block(c) c; Block() 512
Kind        := ForwardFromBeginning | ForwardFromLastOffset | BackwardFromEnd
ByteOffset  := { value : NonNegativeInteger (signed 64-bit range), kind : Kind }
PositiveInt := integer >= 1
```

```
context ByteOffset inv: self.value >= 0
context PositiveInt inv: self >= 1
```

### HEXYL-CLI-D-002 — Grammar

```
byteOffset := [sign] ( hexNumber | decNumber [unit] )
sign       := "+" | "-"
hexNumber  := "0x" hexDigits        // no sign and no unit after the prefix
decNumber  := digit+
unit       := "kB"|"MB"|"GB"|"TB"|"kiB"|"MiB"|"GiB"|"TiB"|"block"|"blocks"   // case-insensitive
```

No whitespace is allowed anywhere. A unit with no number, a number with an unknown unit, or leftover characters, are errors.

### HEXYL-CLI-D-003 — Algorithm

```
function parseByteOffset(text, blockSize : PositiveInt) : ByteOffset | Error
  (rest, kind) := processSign(text)
  if rest starts with "0x" then
     n := parseHex(rest minus "0x")          // errors below
     return ByteOffset(n, kind)              // hex: unit not supported
  (num, unit) := extractNumAndUnit(rest)
  if unit = Block() then unit := Block(blockSize)
  product := checkedMultiply(num, multiplier(unit))   // 64-bit signed
  if overflow then return UnitMultiplicationOverflow
  return ByteOffset(product, kind)

function processSign(text)
  if text = ""            then Empty
  if text[0] = "+"        then (text[1..], ForwardFromLastOffset)  or EmptyAfterSign if nothing follows
  if text[0] = "-"        then (text[1..], BackwardFromEnd)        or EmptyAfterSign if nothing follows
  else (text, ForwardFromBeginning)

function extractNumAndUnit(text)
  if text = "" then Empty
  p := index of first non-digit character in text
  if none: return (parseSigned64(text), Byte)       // ParseNum on failure
  (digits, rawUnit) := split(text, p)
  unit := lookup(lowercase(rawUnit))                // table in D-002; "" gives Byte
  if unit unknown: return digits = "" ? InvalidNumAndUnit(rawUnit) : InvalidUnit(rawUnit)
  if digits = "" then EmptyWithUnit(rawUnit)
  return (parseSigned64(digits) or ParseNum, unit)

function parseHex(s)
  if s begins with "+" or "-" then (s has only that char ? EmptyAfterSign : SignFoundAfterHexPrefix(c))
  return parseRadix16Signed64(s) or ParseNum
```

Block-size parsing (value of `--block-size`) uses `extractNumAndUnit` (no sign handling), refuses `Block`, multiplies, and requires the result ≥ 1 ("block size argument must be positive").

When a count is required (length, display offset), the parsed kind must not be `BackwardFromEnd`; otherwise `NegativeOffsetSpecifiedError`: "negative offset specified, but only positive offsets (counts) are accepted in this context".

### HEXYL-CLI-D-004 — Error catalogue

| Error | Message |
| --- | --- |
| Empty | no character data found, did you forget to write it? |
| EmptyAfterSign | no digits found after sign, did you forget to write them? |
| SignFoundAfterHexPrefix(c) | found `c` sign after hex prefix ("0x"); signs should go before it |
| InvalidNumAndUnit(s) | `s` is not of the expected form <pos-integer>[<unit>] |
| EmptyWithUnit(s) | `s` is a valid unit, but an integer should come before it |
| InvalidUnit(s) | invalid unit `s` |
| ParseNum | failed to parse integer part |
| UnitMultiplicationOverflow | count multiplied by the unit overflowed a signed 64-bit integer; are you sure it should be that big? |

Wrappers: `--skip`: "failed to parse `--skip` arg … as byte count"; `--length`: "… `--length` …"; `--display-offset`: "… `--display-offset` …".

## Verification

Specified at L5 (`L5-test/`); results and gaps in `HEXYL-TEST-RES`.

## References

- Realises: `HEXYL-CLI-F-003`…`-007`; component `HEXYL-CLI-C-002`
- Findings: FND-008
