---
id: HEXYL-INC-D
name: Include export algorithm
level: L4
status: DRAFT
origin: reverse-engineered
---

# HEXYL-INC-D — Include export algorithm

## Purpose

Specify the include-mode output. Realises `HEXYL-INC-F-001`…`-005`.

## Description

### HEXYL-INC-D-001 — Algorithm

```
procedure includeExport(reader, mode)
  case mode of
    File(name):
       var := map each character c of name: isAlphanumeric(c) ? c : "_"       // alphanumeric in the Unicode sense
       write "unsigned char " ⊕ var ⊕ "[] = {" ⊕ newline
       total := writeValues(reader)
       write "};" ⊕ newline
       write "unsigned int " ⊕ var ⊕ "_len = " ⊕ total ⊕ ";" ⊕ newline
    Stdin | Slice:
       writeValues(reader)

function writeValues(reader) : total
  total := 0; k := 0      // k: number of values written so far
  repeat: chunk := reader.read(up to 1024 bytes); if empty then stop
     total := total + chunk.size
     for each byte b in chunk:
        if k mod 12 = 0 then
            if k > 0 then write "," ⊕ newline
            write "  "                       // two spaces
        else write ", "
        write "0x" ⊕ lowercaseHex2(b)
        k := k + 1
  write newline
  return total
```

### HEXYL-INC-D-002 — Contract

```
context includeExport post: output matches
  ( "unsigned char " var "[] = {\n" )? lines ( "};\nunsigned int " var "_len = " total ";\n" )?
  where lines = ( "  " value ( ", " value ){0..11} ( ",\n" )? )* "\n"
```

For an empty input: `writeValues` writes only a newline, so the File form is
`unsigned char x[] = {\n\n};\nunsigned int x_len = 0;\n`. (OBSERVED by analysis of the code; not covered by a test.)

The dump layout settings (borders, panels, colour, squeezing) are not used. Position (skip) and length are applied by the caller before this procedure.

## Error handling

Read or write failure: returned as an error to the caller (unlike in the dump loop, see FND-007).

## Verification

Specified at L5 (`L5-test/`); results and gaps in `HEXYL-TEST-RES`.

## References

- Realises: `HEXYL-INC-F-*`; component `HEXYL-INC-C-001`
- Findings: FND-006
