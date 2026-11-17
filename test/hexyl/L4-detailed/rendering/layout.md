---
id: HEXYL-REN-D-LAY
name: Dump layout
level: L4
status: DRAFT
origin: reverse-engineered
---

# HEXYL-REN-D-LAY — Dump layout

## Purpose

Specify settings, geometry and the text of each part of a dump line. Realises `HEXYL-REN-F-001`…`-007`.

## Description

### HEXYL-REN-D-001 — Settings

| Setting | Type | Default |
| --- | --- | --- |
| showColor | boolean | true |
| showCharPanel | boolean | true |
| showPositionPanel | boolean | true |
| borderStyle | Unicode, Ascii, None | Unicode |
| squeezing | boolean | true |
| panels | positive integer | 2 |
| groupSize | integer in {1,2,4,8} (a divisor of 8) | 1 |
| base | Binary, Octal, Decimal, Hexadecimal | Hexadecimal |
| endianness | Little, Big | Big |
| characterTable | see `HEXYL-CHR-D-*` | Default |
| includeMode | File(name), Stdin, Slice, Off | Off |
| colorScheme | Default, Gradient | Default |
| displayOffset | unsigned 64-bit | 0 |

```
context Printer inv: panels >= 1
context Printer inv: 8 mod groupSize = 0
context Printer inv: lineBuffer.size = 8 * panels   // except the final partial line
```

Derived:

```
baseDigits  := Binary 8 | Octal 3 | Decimal 3 | Hexadecimal 2
lineBytes   := 8 * panels
panelWidth  := 1 + (baseDigits * groupSize + 1) * (8 div groupSize)     // counted in characters, incl. leading space
byteText[b] := Binary  → 8 digits binary, zero padded
               Octal   → 3 digits octal, zero padded
               Decimal → 3 digits decimal, zero padded
               Hex     → 2 digits lowercase hex, zero padded
charText[b] := glyph(characterTable, b)       // HEXYL-CHR-D-003
offsetText[b] := 2 digits lowercase hex (always hexadecimal, regardless of base)
```

### HEXYL-REN-D-002 — Border elements

| Style | Header (left, line, sep, right) | Footer | Outer separator | Inner separator |
| --- | --- | --- | --- | --- |
| Unicode | `┌ ─ ┬ ┐` | `└ ─ ┴ ┘` | `│` | `┊` |
| Ascii | `+ - + +` | `+ - + +` | `\|` | `\|` |
| None | no line printed | no line printed | space | space |

Border line algorithm:

```
function writeBorder(e)
  write e.left
  if showPositionPanel then write e.line*8 ⊕ e.sep
  repeat (panels - 1) times: write e.line*panelWidth ⊕ e.sep
  write e.line*panelWidth
  if showCharPanel then write e.sep
         repeat (panels - 1) times: write e.line*8 ⊕ e.sep
         write e.line*8 ⊕ e.right  ⊕ newline
  else write e.right ⊕ newline
```

### HEXYL-REN-D-003 — Parts of a data line

```
line := position numeric chars newline
position (always starts with outerSep):
   outerSep
   [color] 
   if showPositionPanel:
        if squeezer = Print:  "*" ⊕ [reset] ⊕ 7 spaces
        else:  digits of (index + displayOffset): 8-byte big-endian value,
               drop leading zero bytes while at most 4 are dropped (so at least 4 bytes remain),
               each remaining byte as 2 lowercase hex digits; then [reset]
        outerSep
numeric: for i in 0 .. lineBytes-1, see printByte (D-004)
chars:   for i in 0 .. lineBytes-1, see printChar
```

Hence the offset has 8 to 16 digits (see FND-009). When the position panel is hidden, no offset and no second outer separator are written; the `*` of a squeezed line is then written in the first byte cell.

`printByte(i, b)` (numeric panel):

```
case squeezer of
  Print:   if not showPositionPanel and i = 0 then
              [offsetColour] ⊕ "*" ⊕ [reset]            // written in the first cell instead of a leading space
           else if i mod groupSize = 0 then " "
           baseDigits spaces
  Delete:  "   " (three spaces)        // only used when the line is omitted
  else:    if i mod groupSize = 0 then " "
           if showColor and colour(b) ≠ current then write colour(b); current := colour(b)
           write byteText[b]
if i mod 8 = 7:
   if showColor then current := none; write reset
   write " "
   if (i mod lineBytes) = lineBytes - 1 then outerSep else innerSep
```

`printChar(i)` (character panel):

```
case squeezer of
  Print or Delete: write " "
  else: if i < lineBuffer.size then
           if showColor and colour(b) ≠ current: write colour(b); current := colour(b)
           write charText[b]
        else squeezer := Print       // end of a partial line; following cells are padded
if i = lineBytes - 1: [reset, current := none] ⊕ outerSep
else if i mod 8 = 7:  [reset, current := none] ⊕ innerSep
```

## Constraints

- With colour disabled, no escape sequence is ever written.
- In the numeric panel the colour of a byte is looked up with the byte itself, the same as in the character panel (COL-F-005).

## Verification

Specified at L5 (`L5-test/`); results and gaps in `HEXYL-TEST-RES`.

## References

- Realises: `HEXYL-REN-F-001`…`-007`; components `HEXYL-REN-C-001`, `-002`, `-004`
- Findings: FND-009
