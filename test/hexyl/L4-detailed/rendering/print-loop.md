---
id: HEXYL-REN-D-LOOP
name: Print loop, squeezing and ending
level: L4
status: DRAFT
origin: reverse-engineered
---

# HEXYL-REN-D-LOOP — Print loop, squeezing and ending

## Purpose

Specify how bytes are consumed and lines are emitted, including squeezing, endianness, the last line and the empty case. Realises `HEXYL-REN-F-004`, `-007`, `-008`, `-009`, `-012`.

## Description

### HEXYL-REN-D-004 — Main loop

```
procedure printAll(reader)
  isEmpty := true
  if includeMode ≠ Off then return includeExport(reader)       // HEXYL-INC-D-001

  leftover := none
  loop
     n := reader.read(lineBuffer, up to lineBytes)             // see FND-007: a read error is ignored
     if 0 < n < lineBytes then                                 // short read
         if isEmpty then printHeader(); isEmpty := false
         total := n
         repeat                                                // fill the line, or detect the end
            m := reader.read(lineBuffer[total ..])
            total := total + m
            if m = 0 then lineBuffer.resize(total); leftover := total; break outer loop
         until total >= lineBytes                              // full line gathered: continue below
     else if n = 0 then                                        // end of input
         if squeezer = Delete then lineBuffer.clear(); leftover := 0; break
         else break (leftover := none)
     if isEmpty then printHeader()                             // first full line (isEmpty is cleared after the first line is printed)

     // squeezing check on a full line, see D-005
     if squeezer in {Print, Delete} then
         if all words of lineBuffer equal squeezeWord then
             if squeezer = Delete then index += lineBytes; continue
         else squeezer := Ignore

     printPositionPanel(); printBytes(); if showCharPanel then printCharPanel()
     write newline
     if isEmpty then flush; isEmpty := false                   // first line is flushed early
     index += lineBytes
     if squeezer = Print then squeezer := Delete

     // arm the squeezer, see D-005
     w := replicate(lineBuffer[0] over the machine word)
     if squeezer ∉ {Disabled, Delete} and all words of lineBuffer equal w then
          squeezer := Print; squeezeWord := w

  // ending
  if isEmpty then printEmpty()                                 // D-007
  else if leftover is some n then printPartialLine(n)          // D-006
  printFooter(); flush
```

Remark: the "word" is the machine word (the original implementation compares word-sized chunks of the line; lines have a length multiple of 8, so every byte participates as long as the word is 8 bytes). A 4-byte word machine gives the same result for line lengths multiple of 8 only if every chunk is compared; the specification requires all bytes of the line to be equal to one value.

### HEXYL-REN-D-005 — Squeezing rule (logical)

```
uniform(line)   := all bytes of the full line have the same value v
state           ∈ {Disabled, Ignore, Print, Delete}
initial         := squeezing ? Ignore : Disabled

after printing a full line L (state ≠ Disabled):
    if state = Print       then state := Delete        // L was the "*" line
    if state ≠ Delete and uniform(L) then state := Print, squeezeValue := value(L)
before printing a full line L (state ∈ {Print, Delete}):
    if uniform(L) and value(L) = squeezeValue then
          state = Delete → omit L (index advances)
          state = Print  → print L as "*" line (position "*", empty panels)
    else state := Ignore, print L normally
```

Examples: 33 zero bytes with 2 panels give lines `00000000`, `*`, `00000020 00`. 32 zero bytes give a line, a `*` line, and a final line showing only the position `00000020` when the end falls in the omitted region (see D-006).

```
context Printer inv: squeezer = Disabled implies not squeezing
```

### HEXYL-REN-D-006 — Last line

```
procedure printPartialLine(n)
  squeezer := Ignore
  printPositionPanel()                       // offset of the first byte of this line
  printBytes()                               // n bytes (lineBuffer was resized to n); n may be 0
  squeezer := Print                          // pad: for i in n .. lineBytes-1: printByte(i, 0) → blanks
  for i in n .. lineBytes-1: printByte(i, 0)
  if showCharPanel then
     squeezer := Ignore; printCharPanel()    // iterates over the n bytes then sets squeezer := Print itself on first missing cell
     squeezer := Print
     for i in n .. lineBytes-1: printChar(i)
  newline
```

When n = 0 (the input ended in a squeezed region) the line shows only the offset (the total length, display offset included) and blank panels.

### HEXYL-REN-D-007 — Empty input

```
procedure printEmpty()
  baseDigits := 2                    // forced
  printHeader()
  if showPositionPanel then write "│" right-aligned in a field of 9      // 8 spaces, then "│"
  write "│" left-aligned in a field of 2 ⊕ "No content" left-aligned in a field of (panelWidth - 1)
        ⊕ "│" ⊕ "│" right-aligned in a field of (panelWidth + 1)
  if showCharPanel then write "│" right-aligned in 9, twice
  newline
```

Observable result with default settings (REN-F-009):

```
┌────────┬─────────────────────────┬─────────────────────────┬────────┬────────┐
│        │ No content              │                         │        │        │
└────────┴─────────────────────────┴─────────────────────────┴────────┴────────┘
```

Remark (OBSERVED, see FND-010): the empty case is hard-coded for two panels and unicode separators. With other panel counts or border styles the row does not match the border; this is current behaviour, not a requirement.

### HEXYL-REN-D-008 — Endianness

```
procedure printBytes()
  buf := copy of lineBuffer
  if endianness = Little then
     for idx in 0, groupSize, 2*groupSize, … < buf.size:
         reverse buf[idx .. min(idx + groupSize, buf.size)]
  for i, b in buf: printByte(i, b)
```

The character panel uses `lineBuffer` in its original order. Group size 1 makes both endiannesses identical.

## Error handling

- Any write failure is returned to the caller, which exits (`HEXYL-CLI-D-010`).
- Read errors: see FND-007.

## Verification

Specified at L5 (`L5-test/`); results and gaps in `HEXYL-TEST-RES`.

## References

- Realises: `HEXYL-REN-F-004`, `-007`…`-009`, `-012`; components `HEXYL-REN-C-002`, `-003`
- Findings: FND-003, FND-007
