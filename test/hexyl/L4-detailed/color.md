---
id: HEXYL-COL-D
name: Palette and gradients
level: L4
status: DRAFT
origin: reverse-engineered
---

# HEXYL-COL-D — Palette and gradients

## Purpose

Specify how each byte gets its colour sequence. Realises `HEXYL-COL-F-001`…`-008`.

## Description

### HEXYL-COL-D-001 — Default palette and overrides

| Name | Default | Variable |
| --- | --- | --- |
| NULL | bright black | `HEXYL_COLOR_NULL` |
| OFFSET | bright black | `HEXYL_COLOR_OFFSET` |
| ASCII_PRINTABLE | cyan | `HEXYL_COLOR_ASCII_PRINTABLE` |
| ASCII_WHITESPACE | green | `HEXYL_COLOR_ASCII_WHITESPACE` |
| ASCII_OTHER | green | `HEXYL_COLOR_ASCII_OTHER` |
| NONASCII | yellow | `HEXYL_COLOR_NONASCII` |
| reset | default foreground colour | — |

```
function initColor(name, defaultColour) : EscapeSequence
  value := environment["HEXYL_COLOR_" ⊕ name]
  colour := defaultColour
  if value exists and parseColour(value) succeeds then colour := parseColour(value)
  return the foreground-colour escape sequence of colour

parseColour accepts (case-insensitive names): black, red, green, yellow, blue, magenta, cyan, white,
   "bright <name>", and "#rrggbb" (24-bit) — the set recognised by the colour library used by the implementation.
```

Each sequence is computed once, at first use. Invalid values are ignored silently, with no message (COL-F-003).

### HEXYL-COL-D-002 — Colour selection per byte

```
function colour(scheme, b) : EscapeSequence
  case scheme of
    Default:  case category(b) of
                 Null→NULL; AsciiPrintable→ASCII_PRINTABLE; AsciiWhitespace→ASCII_WHITESPACE;
                 AsciiOther→ASCII_OTHER; NonAscii→NONASCII
    Gradient: case category(b) of
                 Null:                     rgb(100,100,100)
                 AsciiWhitespace and b=0x20: printableGradient[0]
                 AsciiPrintable:           printableGradient[b - 0x20]
                 AsciiWhitespace | AsciiOther: b = 0x7F ? rgb(64,128,0) : nonPrintableGradient[b - 1]
                 NonAscii:                 nonAsciiGradient[b - 128]
```

### HEXYL-COL-D-003 — Gradient construction

```
printableGradient    : 95 entries, stops [(0,128,255 @0.0), (0,255,128 @1.0)]
nonPrintableGradient : 31 entries, stops [(255,0,255 @0.0), (128,0,255 @1.0)]
nonAsciiGradient     : 128 entries, stops [(255,0,0 @0.0), (255,255,0 @0.66), (255,255,255 @1.0)]

function gradient(stops, N)       // stops: at least two, positions ascending
  for k in 0 .. N-1:
     r := k / N                    // real division, never reaches 1.0
     i := 1; while i < stops.size and stops[i].pos < r: i := i + 1
     if i >= stops.size then i := stops.size - 1
     (p, s) := (stops[i-1], stops[i])
     t := (r - p.pos) / (s.pos - p.pos)
     channel := truncate(p.channel + t * (s.channel - p.channel))     // for each of R, G, B
     out[k] := rgbSequence(R, G, B)

function rgbSequence(r,g,b) := ESC "[38;2;" ⊕ dec3(r) ⊕ ";" ⊕ dec3(g) ⊕ ";" ⊕ dec3(b) ⊕ "m"     // 19 bytes, zero-padded decimals
```

```
context gradient pre:  stops.size >= 2
context gradient post: out.size = N
```

### HEXYL-COL-D-004 — Emission rules

```
current : EscapeSequence or none
for each byte cell with showColor:
    c := colour(colorScheme, b)
    if c ≠ current: write c; current := c
at the end of each 8-byte panel (numeric or characters), and after the position panel:
    write reset; current := none          // for the numeric panel, current is also cleared
position panel: write OFFSET sequence before the digits, reset after
```

Remarks: in the gradient scheme the offset is still coloured by the OFFSET variable/default; the reset sequence is the same in both schemes.

## Verification

Specified at L5 (`L5-test/`); results and gaps in `HEXYL-TEST-RES`.

## References

- Realises: `HEXYL-COL-F-*`; components `HEXYL-COL-C-001`, `-002`
