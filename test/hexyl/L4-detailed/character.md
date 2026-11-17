---
id: HEXYL-CHR-D
name: Classification and character tables
level: L4
status: DRAFT
origin: reverse-engineered
---

# HEXYL-CHR-D — Classification and character tables

## Purpose

Specify `category(b)` and `glyph(table, b)`. Realises `HEXYL-CHR-F-001`…`-007`.

## Description

### HEXYL-CHR-D-001 — Classification

```
function category(b : u8) : ByteCategory
  if b = 0x00                          then Null
  else if 0x21 <= b <= 0x7E            then AsciiPrintable
  else if b in {0x20, 0x09, 0x0A, 0x0C, 0x0D} then AsciiWhitespace
  else if b <= 0x7F                    then AsciiOther       // 0x01–0x08, 0x0B, 0x0E–0x1F, 0x7F
  else NonAscii
```

```
context category post: the five categories partition 0..255
```

### HEXYL-CHR-D-002 — Table rules

```
Default:  Null '⋄'; AsciiPrintable b; AsciiWhitespace: b=0x20 ? ' ' : '_'; AsciiOther '•'; NonAscii '×'
Ascii:    Null '.'; AsciiPrintable b; AsciiWhitespace: b=0x20 ? ' ' : '.'; AsciiOther '.'; NonAscii '.'
CP437:    CP437[b]     // 256-entry table, D-004
CP1047:   CP1047[b]    // 256-entry table, D-004
Braille:  Null '⋄'; AsciiPrintable b; 0x20 ' '; 0x09 '→'; 0x0A '↵'; 0x0D '←';
          any other byte (remaining whitespace, AsciiOther, NonAscii): U+2800 + brailleBits(b)
```

### HEXYL-CHR-D-003 — Braille bit permutation

The dots of a braille character are numbered differently from the bits of a byte. For bit position `from` (0 = least significant) of the byte, the destination bit is `to`:

```
map = [0, 3, 1, 4, 2, 5, 6, 7]     // map[from] = to
function brailleBits(b)
  out := 0
  for from in 0..7: out := out OR ((b >> from AND 1) << map[from])
  return out
function brailleChar(b) := codePoint(0x2800 + brailleBits(b))
```

Properties: bijective on 0..255 (so all 256 braille patterns are used), `brailleBits(0) = 0`.

### HEXYL-CHR-D-004 — Constant tables

- `CP437`: authoritative source is the table of code page 437 in the Wikipedia article revision <https://en.wikipedia.org/w/index.php?title=Code_page_437&oldid=978947122>, using the graphic glyphs for 0x01–0x1F and 0x7F (not the Unicode consortium mapping <ftp://ftp.unicode.org/Public/MAPPINGS/VENDORS/MICSFT/PC/CP437.TXT>, which uses control characters). One deviation: entry 0x00 is `⋄`, not `␀`. The 256-entry table is taken from Delan Azabani (2016, ISC-style licence) and is not copied here.
- `CP1047`: authoritative source is the conversion table in <https://github.com/ibm-messaging/mq-smf-csv/blob/master/src/smfConv.c> (IBM, 2016, 2024, Eclipse Public License 1.0), archived description of the code page at <https://web.archive.org/web/20150607033635/http://www-01.ibm.com/software/globalization/cp/cp01047.html>. The implementation shows only the printable characters (letters, digits, space and the ASCII punctuation present in that table) and `.` for every other position; the exact set of punctuation positions is defined by the table in the IBM source, not by this document.
- ASSUMPTION (to confirm): referencing the sources instead of copying the tables is enough for conformance. Verification must compare the full 256-character output with the reference tables.

Observed properties, useful for verification:

```
CP1047[0x40] = ' '     CP1047[0x81..0x89] = 'a'..'i'
CP1047[0xC1..0xC9] = 'A'..'I'   CP1047[0xF0..0xF9] = '0'..'9'
CP437[0x41] = 'A'      CP437[0x80] = 'Ç'
```

## Verification

Specified at L5 (`L5-test/`); results and gaps in `HEXYL-TEST-RES`.

## References

- Realises: `HEXYL-CHR-F-*`; components `HEXYL-CHR-C-001`, `-002`
- Findings: FND-004
