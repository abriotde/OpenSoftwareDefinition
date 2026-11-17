---
id: HEXYL-INP-D
name: Input source contract
level: L4
status: DRAFT
origin: reverse-engineered
---

# HEXYL-INP-D — Input source contract

## Purpose

Specify read and seek on the input source (`HEXYL-INP-C-001`).

## Description

### HEXYL-INP-D-001 — Data model

```
InputSource := File(handle) | Stdin(lockedStream)
```

`read(buffer) : count` delegates to the underlying variant (0 means end of data).

`intoReader()` : returns a plain byte reader that owns the variant.

### HEXYL-INP-D-002 — Seek

Precondition: `pos` is one of `Start(n)`, `Current(n)`, `End(n)` (n signed 64-bit).
Postcondition: on success returns the new absolute position from the start of the input.

```
function seek(source, pos) : position | Error
  case source of
    File(f):
       r := f.seek(pos)                       // real seek
       if r failed with "illegal seek" (the file is a pipe/stream) then
            return trySkip(f, pos, "Pipes only support seeking forward with a relative offset")
       return r
    Stdin(s):
       return trySkip(s, pos, "STDIN only supports seeking forward with a relative offset")

function trySkip(reader, pos, message) : count | Error
  case pos of
    Current(o): if o < 0 then Error(message) else offset := o
    Start(_), End(_): Error(message)
  return copyAndDiscard(first(offset bytes of reader))   // number of bytes actually discarded
```

Remarks:

- `trySkip` returns the number of bytes discarded, not an absolute position. For standard input skipping from the start this is the absolute position as long as no byte was read before; if the input is shorter than `offset`, fewer bytes are discarded and the value is the actual count.
- The CLI maps any seek failure to the user message of `HEXYL-INP-F-003`.
- For a seekable file, a seek past the end succeeds; the following read returns 0 bytes (leading to the "No content" output).

```
context InputSource::seek(pos) post: result >= 0
```

## Error handling

| Condition | Result |
| --- | --- |
| Backward or absolute seek on a pipe | Error with the messages above |
| Negative absolute position on a file | Error from the system, mapped by the CLI |

## Verification

Specified at L5 (`L5-test/`); results and gaps in `HEXYL-TEST-RES`.

## References

- Realises: `HEXYL-INP-F-001`…`-005`, `HEXYL-INP-C-001`
