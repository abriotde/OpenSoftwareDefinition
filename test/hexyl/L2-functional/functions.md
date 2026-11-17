---
id: HEXYL-FUNC
name: hexyl functional specification
level: L2
status: DRAFT
origin: reverse-engineered
---

# HEXYL-FUNC — Functional specification

Requirement identifiers are `HEXYL-<AREA>-F-nnn`. Origin tags: `OBSERVED` (read from implementation/tests), `DOCUMENTED` (help text/README, confirmed in the implementation), `ASSUMPTION` (to be confirmed). Anomalies are not requirements: see `FND-nnn` in [`../L4-detailed/findings.md`](../L4-detailed/findings.md). Refines `HEXYL-SYS-001`. Verification of every requirement is specified at L5 (`../L5-test/`), with the coverage map in `results.md`.

## Command-line interface

Verification is by test unless noted. Tests are in the integration test suite (references in `L4-detailed/cli`).

### Requirements

| ID | Origin | Requirement |
| --- | --- | --- |
| HEXYL-CLI-F-001 | DOCUMENTED | The tool shall accept at most one positional argument FILE. If FILE is absent, or is `-`, the input shall be standard input. |
| HEXYL-CLI-F-002 | OBSERVED | If FILE names a directory, the tool shall fail with the message `'<FILE>' is a directory.` If FILE cannot be opened, the tool shall fail with the system error. |
| HEXYL-CLI-F-003 | DOCUMENTED | `-n`/`--length N` (aliases `-c`, `--bytes`, `-l`) shall limit the displayed bytes to N. N accepts a byte-count syntax (HEXYL-CLI-F-004). A negative N shall be rejected. Giving two of these aliases together shall be rejected (OBSERVED, tests). |
| HEXYL-CLI-F-004 | DOCUMENTED | A byte count shall be an unsigned integer, optionally followed (without space) by a unit: `kB MB GB TB` (powers of 1000), `kiB MiB GiB TiB` (powers of 1024), `block`/`blocks` (multiples of the block size); units are case-insensitive. A hexadecimal count shall be written `0x<hex digits>` and shall not take a unit. |
| HEXYL-CLI-F-005 | DOCUMENTED | `-s`/`--skip N` shall start the display after the first N bytes of the input. A leading `+` is accepted and means the same as no sign. A leading `-` shall mean N bytes before the end of the input. |
| HEXYL-CLI-F-006 | DOCUMENTED | `--block-size SIZE` (default 512) shall set the byte size of the `block` unit. SIZE shall be positive and shall not itself use the `block` unit. A non-positive size shall be rejected. See FND-001 for a hexadecimal SIZE. |
| HEXYL-CLI-F-007 | DOCUMENTED | `-o`/`--display-offset N` shall be added to the offsets shown in the position panel. Together with `--skip`, the shown offset is skip position + N. See FND-002 about negative values. |
| HEXYL-CLI-F-008 | DOCUMENTED | `-v`/`--no-squeezing` shall disable squeezing (`HEXYL-REN-F-008`). |
| HEXYL-CLI-F-009 | DOCUMENTED | `--color WHEN` with WHEN in `always` (default), `auto`, `never`, `force` shall decide on colour use (`HEXYL-COL-F-001`). |
| HEXYL-CLI-F-010 | DOCUMENTED | `--border STYLE` with STYLE in `unicode` (default), `ascii`, `none`. `-p`/`--plain` shall be equivalent to no character panel, no position panel, `--border=none` and `--color=never`; an explicit `--color` or `--border` given with `--plain` still takes effect (OBSERVED). |
| HEXYL-CLI-F-011 | DOCUMENTED | `--no-characters` shall hide the character panel; `-C`/`--characters` shall show it (the latter of the two on the command line wins). `-P`/`--no-position` shall hide the position panel. |
| HEXYL-CLI-F-012 | DOCUMENTED | `--panels N` shall display N numeric panels (N positive). `--panels=auto` shall display as many as fit the terminal width. `--terminal-width N` shall compute the number of panels for a terminal of N columns and shall not be combined with `--panels`. If neither is given, the number of panels shall be the smaller of 2 and what fits the terminal; at least 1. If the terminal width is unknown, 80 shall be assumed. |
| HEXYL-CLI-F-013 | DOCUMENTED | `-g`/`--group-size N` (alias `--groupsize`) with N in {1,2,4,8} (default 1); `--endianness little\|big` (default big); `-e` as an alias for little. |
| HEXYL-CLI-F-014 | DOCUMENTED | `-b`/`--base B` shall select the numeric base: `2`/`b`/`bin`/`binary`, `8`/`o`/`oct`/`octal`, `10`/`d`/`dec`/`decimal`, `16`/`x`/`hex`/`hexadecimal` (default). Other values shall be rejected with an explanatory message. |
| HEXYL-CLI-F-015 | DOCUMENTED | `--character-table` and `--color-scheme` shall select the tables of `HEXYL-CHR-F-*` and the schemes of `HEXYL-COL-F-*`. |
| HEXYL-CLI-F-016 | DOCUMENTED | `-i`/`--include` shall select C-include output (`HEXYL-INC-F-*`) and shall not be combined with `-e` or `--endianness`. |
| HEXYL-CLI-F-017 | DOCUMENTED | `--print-color-table` shall print a legend of the byte-category colours and exit; `--completion SHELL` shall print the completion script for the shell and exit; `-h`/`--help` and `-V`/`--version` shall be provided. These are handled before the input is read. The exact help and version text is defined in `HEXYL-CLI-D-HELP` (L4). |
| HEXYL-CLI-F-018 | OBSERVED | On failure the tool shall write `Error: <description>` to standard error and exit with status 1. If the failure is a closed output pipe, it shall exit with status 0 and no message. On success it shall exit with status 0. |

### Exceptional situations

| Situation | Expected outcome |
| --- | --- |
| `--skip` beyond end of input | An empty dump ("No content", `HEXYL-REN-F-009`), exit 0 (OBSERVED, tests). |
| Negative skip larger than input size, or any backward skip on a non-seekable input | Failure (`HEXYL-INP-F-003`). |
| Invalid number, unit, base or option value | Failure with description; nothing is displayed. |

### Constraints

- Option names, aliases and defaults are part of the external contract.

**See also**

- Findings: FND-001, FND-002, FND-005

## Input

| ID | Origin | Requirement |
| --- | --- | --- |
| HEXYL-INP-F-001 | OBSERVED | The input shall be a file or the standard input, read as a sequence of bytes with no interpretation. |
| HEXYL-INP-F-002 | OBSERVED | For a skip to a forward position, a seekable input shall be repositioned directly; a non-seekable input shall be advanced by reading and discarding the bytes. |
| HEXYL-INP-F-003 | OBSERVED | A skip measured from the end of the input, or any seek not relative to the current position, shall fail on a non-seekable input with a message that says that only forward relative skipping is supported. The CLI shall report this as `Failed to jump to the desired input position. This could be caused by a negative offset that is too large or by an input that is not seek-able (e.g. if the input comes from a pipe).` |
| HEXYL-INP-F-004 | OBSERVED | The displayed offset base shall be the position reached by the skip (the absolute position from the start of the input, also for skip from the end). |
| HEXYL-INP-F-005 | DOCUMENTED | When a length is given, at most that many bytes after the start position shall be displayed. The length is applied after the skip. |

### Exceptional situations

- A skip beyond the end of the input yields an empty input (`HEXYL-REN-F-009`); skipping from the end by more than the input size fails.

**See also**

- Related: `HEXYL-CLI-F-003`, `HEXYL-CLI-F-005`

## Rendering

Example of the default layout (two panels, hexadecimal, unicode border, colour disabled):

```
┌────────┬─────────────────────────┬─────────────────────────┬────────┬────────┐
│00000000│ 73 70 61 6d 73 70 61 6d ┊ 73 70 61 6d 73 70 61 6d │spamspam┊spamspam│
│00000010│ 73 70 61 6d             ┊                         │spam    ┊        │
└────────┴─────────────────────────┴─────────────────────────┴────────┴────────┘
```

| ID | Origin | Requirement |
| --- | --- | --- |
| HEXYL-REN-F-001 | OBSERVED | Each data line shall show 8 × P bytes (P = number of panels), in P numeric panels of 8 bytes, followed by P character panel segments of 8 characters. Panels shall be separated by an inner separator and the whole by an outer separator. |
| HEXYL-REN-F-002 | OBSERVED | The position panel shall show the offset of the first byte of the line (display offset included) in hexadecimal, lowercase, with at least 8 digits, more if needed up to 16, in the offset colour. |
| HEXYL-REN-F-003 | OBSERVED | The numeric panel shall show each byte in the selected base with a fixed width: 8 digits for base 2, 3 for base 8, 3 for base 10 (zero padded) and 2 for base 16 (lowercase). |
| HEXYL-REN-F-004 | OBSERVED | Bytes shall be grouped by the group size, groups being separated by one space. With little endianness the bytes of each group shall be shown in reverse order; the character panel shall keep the memory order. |
| HEXYL-REN-F-005 | OBSERVED | Borders shall be drawn at the top and bottom according to the style: unicode (`┌ ─ ┬ ┐ └ ┴ ┘ │ ┊`), ascii (`+ - + +` for corners and column joins, `|` for both separators), none (separators are spaces, no border lines). |
| HEXYL-REN-F-006 | OBSERVED | The position panel and the character panel shall be individually removable; borders shall adapt. |
| HEXYL-REN-F-007 | OBSERVED | An incomplete last line shall be completed with blank space so that all columns stay aligned. |
| HEXYL-REN-F-008 | DOCUMENTED / OBSERVED | When squeezing is enabled, when a full line consists of one repeated byte value, and the following full lines consist of the same byte value, the first such line shall be printed, the next one shall be shown as a line with `*` in the position panel and empty panels, and any further ones shall be omitted. If the dump ends in the squeezed region, the final line shall show the offset after the last byte. See FND-003. |
| HEXYL-REN-F-009 | OBSERVED | For an empty input, the dump shall consist of the borders and one line with `No content` in the first numeric panel. |
| HEXYL-REN-F-010 | OBSERVED | Output shall be deterministic: with colour disabled, the output depends only on the input bytes and the options. |
| HEXYL-REN-F-011 | OBSERVED | When C-include output is selected, none of the above applies (`HEXYL-INC-F-*`). |
| HEXYL-REN-F-012 | OBSERVED | Output shall be streamed: the first line shall be flushed before the whole input is read. |

### Exceptional situations

- Write errors on the output are failures (`HEXYL-CLI-F-018`).
- See FND-007 about read errors.

**See also**

- Findings: FND-003, FND-007

## Characters

| ID | Origin | Requirement |
| --- | --- | --- |
| HEXYL-CHR-F-001 | OBSERVED | Each byte shall belong to exactly one category: NULL (0x00); ASCII printable (0x21–0x7E); ASCII whitespace (0x20, 0x09, 0x0A, 0x0C, 0x0D); ASCII other (remaining 0x01–0x7F); non-ASCII (0x80–0xFF). See FND-004 about 0x0B. |
| HEXYL-CHR-F-002 | DOCUMENTED | `default` table: printable ASCII as is; NULL `⋄`; space ` `; other whitespace `_`; other ASCII `•`; non-ASCII `×`. |
| HEXYL-CHR-F-003 | DOCUMENTED | `ascii` table: printable ASCII and space as is; every other byte `.`. |
| HEXYL-CHR-F-004 | DOCUMENTED | `codepage-437` table: each byte maps to its glyph in code page 437 (graphic versions of 0x01–0x1F and 0x7F; 0x00 shown as `⋄`). |
| HEXYL-CHR-F-005 | DOCUMENTED | `codepage-1047` table: each byte maps to its EBCDIC code page 1047 printable character, space as ` `, any other as `.`. |
| HEXYL-CHR-F-006 | DOCUMENTED | `braille` table: printable ASCII, space and NULL (`⋄`) as in `default`; TAB `→`, LF `↵`, CR `←`; every other byte as the braille pattern that encodes its 8 bits. |
| HEXYL-CHR-F-007 | OBSERVED | Each table shall give exactly one displayed character per byte. |

**See also**

- Findings: FND-004

## Colour

| ID | Origin | Requirement |
| --- | --- | --- |
| HEXYL-COL-F-001 | DOCUMENTED / OBSERVED | Colour use: `never` → no colour. `always` → colour unless the `NO_COLOR` variable is set. `force` → colour regardless of `NO_COLOR`. `auto` → colour unless `NO_COLOR` is set, and only if standard output supports at least basic colours. Default is `always`; with `--plain` the default is `never`. |
| HEXYL-COL-F-002 | DOCUMENTED | Default scheme colours: NULL bright black; ASCII printable cyan; ASCII whitespace green; ASCII other green; non-ASCII yellow; offset bright black. |
| HEXYL-COL-F-003 | DOCUMENTED | In the default scheme, each colour can be overridden by `HEXYL_COLOR_NULL`, `_ASCII_PRINTABLE`, `_ASCII_WHITESPACE`, `_ASCII_OTHER`, `_NONASCII`, `_OFFSET`. Values: the 8 standard colour names, their `bright` variants, or `#rrggbb`. An invalid value shall be ignored without message (default is kept). |
| HEXYL-COL-F-004 | DOCUMENTED | The `gradient` scheme shall show NULL in grey, printable ASCII in a gradient from blue-green to green by value, non-printable ASCII in a gradient from pink to violet by value, DEL in dark green and non-ASCII in a heat-map gradient from red to yellow to white by value. The `HEXYL_COLOR_*` variables do not apply to byte colours in this scheme (OBSERVED). |
| HEXYL-COL-F-005 | OBSERVED | The colour of a byte shall be the same in the numeric panel and in the character panel. |
| HEXYL-COL-F-006 | OBSERVED | Colour shall be reset at the end of each panel, and at the end of the position panel. |
| HEXYL-COL-F-007 | OBSERVED | `--print-color-table` shall print the title `hexyl color reference:` and one line per category, in its colour, with the sample glyph and the range. |
| HEXYL-COL-F-008 | OBSERVED | Position panel digits are shown in the offset colour, also in the gradient scheme. |

**See also**

- Findings: FND-004

## C include export

Example for file `test.txt` containing 20 bytes:

```
unsigned char test_txt[] = {
  0x73, 0x70, 0x61, 0x6d, 0x73, 0x70, 0x61, 0x6d, 0x73, 0x70, 0x61, 0x6d,
  0x73, 0x70, 0x61, 0x6d, 0x73, 0x70, 0x61, 0x6d
};
unsigned int test_txt_len = 20;
```

| ID | Origin | Requirement |
| --- | --- | --- |
| HEXYL-INC-F-001 | OBSERVED | Each byte shall be written as `0x` followed by two lowercase hexadecimal digits. Values shall be separated by `, `, 12 per line, each line indented with two spaces, lines separated by `,` + newline, and the list ended by a newline. |
| HEXYL-INC-F-002 | OBSERVED | For a named file input, the list shall be wrapped by `unsigned char <name>[] = {` and `};`, followed by `unsigned int <name>_len = <count>;`. `<name>` is the file name without its directory, with every non-alphanumeric character replaced by `_`. For `-` as input the name is `stdin`. |
| HEXYL-INC-F-003 | OBSERVED | For standard input given without a file name, only the list of values shall be written. |
| HEXYL-INC-F-004 | OBSERVED | No border, panel, colour or squeezing shall be written in this mode. Skip and length still apply. |
| HEXYL-INC-F-005 | OBSERVED | For an empty input, the list shall be empty (a single newline in the list position). |

### Exceptional situations

- See FND-006 for names which are not valid C identifiers.

**See also**

- Related: `HEXYL-CLI-F-016`
- Findings: FND-006

