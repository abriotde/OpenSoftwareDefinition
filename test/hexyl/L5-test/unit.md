---
id: HEXYL-TEST-UNIT
name: Unit tests
level: L5
status: DRAFT
origin: reverse-engineered
---

# HEXYL-TEST-UNIT — Unit tests

Existing unit tests: 5 for the command-line part (U-CLI-*) and 10 for the rendering engine (U-REN-*, 15 in total, all passing).
Notation: language-independent Python-like pseudocode. `assert_equal(actual, expected)`, `result(...)` is the value or error of an operation, `Err(name)` denotes an error kind from `HEXYL-CLI-D-SZ`.
Each test names the specification elements it verifies and the existing test it describes.

## Byte-count parsing — verifies `HEXYL-CLI-D-001`…`D-004`, `HEXYL-CLI-F-004`

```python
def U_CLI_1_unit_multipliers():                # existing: unit_multipliers
    assert multiplier("kB") == 1000 * multiplier("B")
    assert multiplier("MB") == 1000 * multiplier("kB")
    assert multiplier("GB") == 1000 * multiplier("MB")
    assert multiplier("TB") == 1000 * multiplier("GB")
    assert multiplier("kiB") == 1024 * multiplier("B")
    assert multiplier("MiB") == 1024 * multiplier("kiB")
    assert multiplier("GiB") == 1024 * multiplier("MiB")
    assert multiplier("TiB") == 1024 * multiplier("GiB")

def U_CLI_2_sign():                            # existing: test_process_sign
    assert process_sign("123")  == ("123", ForwardFromBeginning)
    assert process_sign("+123") == ("123", ForwardFromLastOffset)
    assert process_sign("-123") == ("123", BackwardFromEnd)
    assert process_sign("-")    == Err("EmptyAfterSign")
    assert process_sign("+")    == Err("EmptyAfterSign")
    assert process_sign("")     == Err("Empty")

def U_CLI_3_hex_prefix():                      # existing: test_parse_as_hex
    assert try_parse_hex("73") is None                 # no prefix: not a hex number
    assert try_parse_hex("0x1337") == Ok(0x1337)
    assert is_error(try_parse_hex("0xnope"))
    assert is_error(try_parse_hex("0x-1"))

def U_CLI_4_number_and_unit():                 # existing: extract_num_and_unit
    assert extract("4")        == (4, "B")             # default unit
    assert extract("2blocks")  == (2, Block(None))     # block size not yet applied
    assert extract("1024kb")   == (1024, "kB")         # no normalisation
    assert extract("gib")      == Err("EmptyWithUnit", "gib")
    assert extract("")         == Err("Empty")
    assert extract("25litres") == Err("InvalidUnit", "litres")

def U_CLI_5_parse_byte_offset():               # existing: test_parse_byte_offset
    cases_ok = [   # (text, kind, value, block_size)
        ("0", Fwd, 0, 512), ("100", Fwd, 100, 512), ("+100", FwdLast, 100, 512),
        ("0xf", Fwd, 15, 512), ("0xdeadbeef", Fwd, 3735928559, 512), ("+0xFF", FwdLast, 255, 512),
        ("1KB", Fwd, 1000, 512), ("2MB", Fwd, 2_000_000, 512), ("4TB", Fwd, 4 * 10**12, 512),
        ("1GiB", Fwd, 2**30, 512), ("2TiB", Fwd, 2 * 2**40, 512),
        ("1block", Fwd, 512, 512), ("2block", Fwd, 1024, 512),
        ("1block", Fwd, 4, 4),     ("2block", Fwd, 8, 4),
    ]
    for text, kind, value, block in cases_ok:
        assert parse_byte_offset(text, block) == ByteOffset(value, kind)
    cases_err = [
        ("", "Empty"), ("+", "EmptyAfterSign"), ("-", "EmptyAfterSign"),
        ("K", "InvalidNumAndUnit"), ("k", "InvalidNumAndUnit"), ("m", "InvalidNumAndUnit"),
        ("block", "EmptyWithUnit"),
        (" 0", "InvalidNumAndUnit"), ("0 ", "InvalidUnit"),
        ("0x-12", "SignFoundAfterHexPrefix"), ("0x+12", "SignFoundAfterHexPrefix"),
        ("1234asdf", "InvalidUnit"), ("asdf1234", "InvalidNumAndUnit"), ("a1s2d3f4", "InvalidNumAndUnit"),
        ("20000000TiB", "UnitMultiplicationOverflow"),
    ]
    for text, name in cases_err:
        assert parse_byte_offset(text, 512).error_kind == name
    assert parse_byte_offset("99999999999999999999", 512).error_kind == "ParseNum"
```

## Rendering engine — verifies `HEXYL-REN-D-*`, `HEXYL-REN-F-*`, `HEXYL-INC-F-*`

All tests build a printer with the default settings except those listed, with colour off, run `print_all` on an in-memory input and compare the whole output text with a reference text. The reference texts are the ones in `functional.feature` or follow the layout of `HEXYL-REN-F`; they are not repeated except when new.

```python
def make_printer(**overrides):
    defaults = dict(show_color=False, char_panel=True, position_panel=True, border="unicode",
                    squeezing=True, panels=2, group_size=1, base="hex", endianness="big",
                    table="default", include_mode="off", scheme="default")
    return Printer(Output(), **{**defaults, **overrides})

def U_REN_1_empty():                    # existing: empty_file_passes     (REN-F-009)
    assert render(make_printer(), b"") == NO_CONTENT_DUMP

def U_REN_2_short_input():              # existing: short_input_passes    (REN-F-001, -007)
    assert render(make_printer(), b"spam") == (
        "┌────────┬─────────────────────────┬─────────────────────────┬────────┬────────┐\n"
        "│00000000│ 73 70 61 6d             ┊                         │spam    ┊        │\n"
        "└────────┴─────────────────────────┴─────────────────────────┴────────┴────────┘\n")

def U_REN_3_display_offset():           # existing: display_offset        (REN-F-002)
    p = make_printer(); p.display_offset(0xdeadbeef)
    out = render(p, b"spamspamspamspamspam")
    assert out.line(1).startswith("│deadbeef│") and out.line(2).startswith("│deadbeff│")

def U_REN_4_four_panels():              # existing: multiple_panels       (REN-F-001)
    out = render(make_printer(panels=4), b"supercalifragilisticexpialidocious" * 3)
    assert out.data_lines() == 4 and out.line(1).startswith("│00000000│") and out.line(4).startswith("│00000060│")

def U_REN_5_squeeze_zero():             # existing: squeeze_works         (REN-F-008)
    out = render(make_printer(), b"\x00" * 33)
    assert out.data_lines_positions() == ["00000000", "*", "00000020"]

def U_REN_6_squeeze_nonzero():          # existing: squeeze_nonzero      (REN-F-008)
    assert render(make_printer(), b"0" * 33).data_lines_positions() == ["00000000", "*", "00000020"]

def U_REN_7_squeeze_three_panels():     # existing: squeeze_multiple_panels
    assert render(make_printer(panels=3), b"0" * 49).data_lines_positions() == ["00000000", "*", "00000030"]
    # Lines of identical content that are not one repeated byte value are NOT squeezed (FND-003): no test.

def U_REN_8_offset_in_last_line():      # existing: display_offset_in_last_line  (issue 238)
    out = render(make_printer(), b"A" * 16 + b"CCCC")
    assert out.line(2).startswith("│00000010│ 43 43 43 43 ")

def U_REN_9_include_file():             # existing: include_mode_from_file  (INC-F-001, -002)
    out = render(make_printer(include_mode=File("test.txt")), b"spamspamspamspamspam")
    assert out == ("unsigned char test_txt[] = {\n"
                   "  0x73, 0x70, 0x61, 0x6d, 0x73, 0x70, 0x61, 0x6d, 0x73, 0x70, 0x61, 0x6d,\n"
                   "  0x73, 0x70, 0x61, 0x6d, 0x73, 0x70, 0x61, 0x6d\n"
                   "};\nunsigned int test_txt_len = 20;\n")

def U_REN_10_include_stdin():           # existing: include_mode_from_stdin  (INC-F-003)
    out = render(make_printer(include_mode=Stdin), b"spamspamspamspamspam")
    assert out == ("  0x73, 0x70, 0x61, 0x6d, 0x73, 0x70, 0x61, 0x6d, 0x73, 0x70, 0x61, 0x6d,\n"
                   "  0x73, 0x70, 0x61, 0x6d, 0x73, 0x70, 0x61, 0x6d\n")
```

## Not covered by unit tests

Classification (`HEXYL-CHR-D-001`), braille mapping (`HEXYL-CHR-D-003`), gradient construction (`HEXYL-COL-D-003`), colour override parsing, input source seek (`HEXYL-INP-D-002`), option resolution (`HEXYL-CLI-D-005`…`-009`), include export for an empty input (`HEXYL-INC-D-002`).
