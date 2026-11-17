# id: HEXYL-TEST-FUNC
# level: L5   status: DRAFT   origin: reverse-engineered
# Describes the existing end-to-end tests of the command-line program (41 tests, all passing at the time of writing).
# Tags give the verified L2 requirement; "# existing:" gives the name of the existing test, "# GAP:" marks a scenario
# that is expected from the specification but has no existing test.
#
# Fixtures: `ascii` = the 16 bytes "0123456789abcde\n"; `empty` = 0 bytes;
#           `hello_world_elf64` = 8488-byte executable (its content is only used for its zero runs).
# All scenarios run with colour disabled unless stated.

Feature: Hex dump of an input
  Background:
    Given the fixtures `ascii`, `empty` and `hello_world_elf64`

  # ---------- Input and range ----------

  @HEXYL-CLI-F-001 @HEXYL-REN-F-001
  Scenario: Dump a file                                   # existing: basic::can_print_simple_ascii_file
    When I run "hexyl ascii --color=never"
    Then the exit status is 0
    And the output is
      """
      ┌────────┬─────────────────────────┬─────────────────────────┬────────┬────────┐
      │00000000│ 30 31 32 33 34 35 36 37 ┊ 38 39 61 62 63 64 65 0a │01234567┊89abcde_│
      └────────┴─────────────────────────┴─────────────────────────┴────────┴────────┘
      """

  @HEXYL-CLI-F-001
  Scenario: Dump standard input                           # existing: basic::can_read_input_from_stdin
    When I run "hexyl --color=never" with standard input "abc"
    Then the output is
      """
      ┌────────┬─────────────────────────┬─────────────────────────┬────────┬────────┐
      │00000000│ 61 62 63                ┊                         │abc     ┊        │
      └────────┴─────────────────────────┴─────────────────────────┴────────┴────────┘
      """

  @HEXYL-CLI-F-002
  Scenario: Missing file                                  # existing: basic::fails_on_non_existing_input
    When I run "hexyl non-existing"
    Then the exit status is not 0

  # GAP: HEXYL-CLI-F-002 (directory as input) has no test.

  @HEXYL-REN-F-009
  Scenario: Empty input                                   # existing: basic::prints_warning_on_empty_content
    When I run "hexyl empty --color=never"
    Then the output is
      """
      ┌────────┬─────────────────────────┬─────────────────────────┬────────┬────────┐
      │        │ No content              │                         │        │        │
      └────────┴─────────────────────────┴─────────────────────────┴────────┴────────┘
      """

  @HEXYL-CLI-F-003 @HEXYL-INP-F-005
  Scenario: Length limit                                  # existing: length::length_restricts_output_size
    When I run "hexyl hello_world_elf64 --color=never --length=32"
    Then the output has exactly 2 data lines, at offsets 00000000 and 00000010

  @HEXYL-CLI-F-003
  Scenario Outline: Two aliases of length are rejected together
    # existing: length::fail_if_length_and_bytes_..., length::fail_if_length_and_count_..., bytes::fail_if_bytes_and_count_...
    When I run "hexyl hello_world_elf64 <first> <second>"
    Then the exit status is not 0
    Examples:
      | first       | second   |
      | --length=32 | --bytes=10 |
      | --length=32 | -l=10    |
      | --bytes=32  | -l=10    |

  @HEXYL-CLI-F-005 @HEXYL-INP-F-004
  Scenario: Skip from the end                             # existing: skip::negative_offset
    When I run "hexyl ascii --color=never --skip=-4 --length=3"
    Then the output is
      """
      ┌────────┬─────────────────────────┬─────────────────────────┬────────┬────────┐
      │0000000c│ 63 64 65                ┊                         │cde     ┊        │
      └────────┴─────────────────────────┴─────────────────────────┴────────┴────────┘
      """

  @HEXYL-CLI-F-018 @HEXYL-INP-F-003
  Scenario: Skip from the end beyond the start            # existing: skip::fails_if_negative_offset_is_too_large
    When I run "hexyl ascii --color=never --skip=-1MiB"
    Then the exit status is not 0
    And the error output contains "Failed to jump"

  @HEXYL-CLI-F-005 @HEXYL-REN-F-009
  Scenario: Skip beyond the end                           # existing: skip::prints_warning_when_skipping_past_the_end
    When I run "hexyl ascii --color=never --skip=1000"
    Then the output is the "No content" dump

  # GAP: skip on a non-seekable input (pipe) has no test (HEXYL-INP-F-002, -003).

  @HEXYL-CLI-F-006
  Scenario Outline: Non-positive block size is rejected   # existing: display_offset::fails_for_zero_or_negative_blocksize
    When I run "hexyl ascii --block-size=<size>"
    Then the exit status is not 0
    Examples:
      | size |
      | 0    |
      | -16  |

  # GAP: units of `--block-size` and of the `block` unit have no end-to-end test; hexadecimal block size: see FND-001.

  # ---------- Layout ----------

  @HEXYL-CLI-F-007 @HEXYL-REN-F-002
  Scenario: Display offset                                # existing: display_offset::basic
    When I run "hexyl ascii --color=never --display-offset=0xc0ffee"
    Then the first line starts with "│00c0ffee│"

  @HEXYL-CLI-F-007 @HEXYL-INP-F-004
  Scenario: Display offset combined with skip             # existing: display_offset::display_offset_and_skip
    When I run "hexyl hello_world_elf64 --color=never --display-offset=0x20 --skip=0x10 --length=0x10"
    Then the first line starts with "│00000030│"

  @HEXYL-CLI-F-010
  Scenario: Plain mode                                    # existing: display_settings::plain
    When I run "hexyl ascii --plain"
    Then the output is "  30 31 32 33 34 35 36 37   38 39 61 62 63 64 65 0a  " followed by a newline

  @HEXYL-CLI-F-011 @HEXYL-REN-F-006
  Scenario Outline: Hide a panel                          # existing: display_settings::no_chars, display_settings::no_position
    When I run "hexyl ascii --color=never <option>"
    Then the output has no <hidden> panel and a consistent border
    Examples:
      | option          | hidden    |
      | --no-characters | character |
      | --no-position   | position  |

  @HEXYL-CLI-F-013 @HEXYL-REN-F-004
  Scenario Outline: Groups and endianness        # existing: group_and_endianness::group_{2,4,8}_bytes_{be,le}, group_size_plain
    When I run "hexyl ascii --color=never --group-size=<size> --endianness=<endianness>"
    Then the numeric panel shows groups of <size> bytes in <endianness> order
    And the character panel keeps the memory order
    Examples:
      | size | endianness |
      | 2    | big        |
      | 2    | little     |
      | 4    | big        |
      | 4    | little     |
      | 8    | big        |
      | 8    | little     |

  Scenario: Group size 2, little endian, reference output
    When I run "hexyl ascii --color=never --group-size=2 --endianness=little"
    Then the output is
      """
      ┌────────┬─────────────────────┬─────────────────────┬────────┬────────┐
      │00000000│ 3130 3332 3534 3736 ┊ 3938 6261 6463 0a65 │01234567┊89abcde_│
      └────────┴─────────────────────┴─────────────────────┴────────┴────────┘
      """

  @HEXYL-REN-F-007
  Scenario: Incomplete last group is padded               # existing: group_and_endianness::group_size_fill_space
    When I run "hexyl --color=never --group-size=2" with standard input "abc"
    Then the columns of the dump stay aligned

  @HEXYL-CLI-F-013
  Scenario: Invalid group size                            # existing: group_and_endianness::group_size_invalid
    When I run "hexyl ascii --plain --group-size=3"
    Then the exit status is not 0

  @HEXYL-CLI-F-014 @HEXYL-REN-F-003
  Scenario: Binary base                                   # existing: group_and_endianness::base2
    When I run "hexyl ascii --plain --base=binary"
    Then the numeric cells have 8 binary digits
    And the first cell is "00110000" and the last is "00001010"

  # GAP: bases octal and decimal, base names and numbers (CLI-F-014), invalid base: no test.

  # ---------- Squeezing ----------

  @HEXYL-CLI-F-008 @HEXYL-REN-F-008
  Scenario Outline: Squeezing a run of zero bytes
    # existing: group_and_endianness::squeeze_no_chars, squeeze_no_chars_one_panel, squeeze_no_position,
    #           squeeze_no_position_one_panel, squeeze_odd_panels_remainder_bytes, squeeze_plain, squeeze_plain_remainder
    When I run "hexyl hello_world_elf64 --color=never --skip=1024 --length=<length> <options>"
    Then a run of identical lines is replaced by a line with "*" in the position panel
    And the final line is shown correctly
    Examples:
      | length | options                          |
      | 4096   | --no-characters                  |
      | 4096   | --no-characters --panels=1       |
      | 4096   | --no-position                    |
      | 4096   | --no-position --panels=1         |
      | 4092   | --panels=3                       |
      | 4096   | --plain                          |
      | 4092   | --plain                          |

  Scenario: Squeezing, reference output (default options; reproduced from the program)
    When I run "hexyl hello_world_elf64 --color=never --skip=1024 --length=4096"
    Then the output starts with
      """
      ┌────────┬─────────────────────────┬─────────────────────────┬────────┬────────┐
      │00000400│ 00 00 00 00 00 00 00 00 ┊ 00 00 00 00 00 00 00 00 │⋄⋄⋄⋄⋄⋄⋄⋄┊⋄⋄⋄⋄⋄⋄⋄⋄│
      │*       │                         ┊                         │        ┊        │
      │00001000│ ba 0e 00 00 00 b9 00 20 ┊ 40 00 bb 01 00 00 00 b8 │×•⋄⋄⋄×⋄ ┊@⋄×•⋄⋄⋄×│
      """

  # GAP: --no-squeezing (-v) has no end-to-end test.

  # ---------- Character tables ----------

  @HEXYL-CLI-F-015 @HEXYL-CHR-F-003 @HEXYL-CHR-F-004 @HEXYL-CHR-F-005
  Scenario Outline: Character table                       # existing: character_table::ascii, codepage_437, codepage_1047
    When I run "hexyl hello_world_elf64 --color=never --character-table=<table>"
    Then the output equals the stored reference output of the table <table>
    Examples:
      | table         |
      | ascii         |
      | codepage-437  |
      | codepage-1047 |

  # GAP: the input fixture has only 46 distinct byte values; a scenario using all 256 byte values is needed for the tables.
  # GAP: tables `default` (only through other scenarios) and `braille` have no dedicated test.

  # ---------- Colours ----------

  @HEXYL-COL-F-001 @HEXYL-COL-F-002 @HEXYL-COL-F-005
  Scenario Outline: Colour output                         # existing: colors::hex_colors, binary_colors, groupsize_colors
    When I run "hexyl --color=always <options>" with standard input of all byte categories
    Then the output equals the stored reference output containing colour sequences
    Examples:
      | options                      |
      |                              |
      | --panels=1 --base=binary     |
      | --panels=1 --groupsize=2     |

  # GAP: --color=auto/force, NO_COLOR, HEXYL_COLOR_* variables, gradient scheme, --print-color-table: no test.

  # ---------- C include output and utilities ----------

  # GAP: -i / --include has unit tests only (see unit.md); no end-to-end test.
  # GAP: --help, --version, --completion, usage errors: no test (reference text: L4 HEXYL-CLI-D-HELP).
  # GAP: --panels (explicit number, auto), --terminal-width: only used as an option in squeezing scenarios.
