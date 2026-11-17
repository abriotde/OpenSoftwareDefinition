---
id: HEXYL-CLI-D-HELP
name: Help, version and completion output
level: L4
status: DRAFT
origin: reverse-engineered
---

# HEXYL-CLI-D-HELP — Help, version and completion output

Realises `HEXYL-CLI-F-017`. The texts below are the reference output of hexyl 0.17.0, captured with output redirected (no styling escape sequences). They are the authoritative definition of the text content; wrapping depends on the terminal width, capped at 90 columns.

## HEXYL-CLI-D-012 — Rules

- `--help` prints the long form (D-014): one option per block, description below the option, defaults and value lists on separate lines. `-h` prints the short form (D-015): option names in a left column and descriptions in a right column, defaults and value lists appended inline in brackets. Both write to standard output and exit with status 0.
- `--version` / `-V` prints `hexyl <version>` (D-013).
- Section order: description line, blank line, `Usage:`, `Arguments:`, `Options:`.
- When styled (terminal output), headers and usage are bold green, literals bold cyan, placeholders cyan.
- The hidden options `-e` (alias of `--endianness=little`) and `-l` (alias of `--length`) do not appear in either form. `-c` and `--bytes` are shown as aliases of `--length` in the long form only.
- `--completion <SHELL>` prints a completion script for bash, elvish, fish, powershell or zsh. Its exact content is defined by the argument-parsing component, not by this specification. A conforming implementation shall complete all options listed in D-014.
- An invalid option or value prints a usage error on standard error and exits with status 2 (D-016).

## HEXYL-CLI-D-013 — Version output

```
hexyl 0.17.0
```

## HEXYL-CLI-D-014 — Long help (`--help`)

```text
A command-line hex viewer

Usage: hexyl [OPTIONS] [FILE]

Arguments:
  [FILE]
          The file to display. If no FILE argument is given, read from STDIN

Options:
  -n, --length <N>
          Only read N bytes from the input. The N argument can also include a unit with a
          decimal prefix (kB, MB, ..) or binary prefix (kiB, MiB, ..), or can be specified
          using a hex number. The short option '-l' can be used as an alias.
          Examples: --length=64, --length=4KiB, --length=0xff

          [aliases: bytes]
          [short aliases: c]

  -s, --skip <N>
          Skip the first N bytes of the input. The N argument can also include a unit (see
          `--length` for details).
          A negative value is valid and will seek from the end of the file.

      --block-size <SIZE>
          Sets the size of the `block` unit to SIZE.
          Examples: --block-size=1024, --block-size=4kB

          [default: 512]

  -v, --no-squeezing
          Displays all input data. Otherwise any number of groups of output lines which
          would be identical to the preceding group of lines, are replaced with a line
          comprised of a single asterisk

      --color <WHEN>
          When to use colors

          [default: always]

          Possible values:
          - always: Always use colorized output
          - auto:   Only displays colors if the output goes to an interactive terminal
          - never:  Do not use colorized output
          - force:  Override the NO_COLOR environment variable

      --border <STYLE>
          Whether to draw a border

          [default: unicode]

          Possible values:
          - unicode: Draw a border with Unicode characters
          - ascii:   Draw a border with ASCII characters
          - none:    Do not draw a border at all

  -p, --plain
          Display output with --no-characters, --no-position, --border=none, and
          --color=never

      --no-characters
          Do not show the character panel on the right

  -C, --characters
          Show the character panel on the right. This is the default, unless
          --no-characters has been specified

      --character-table <FORMAT>
          Defines how bytes are mapped to characters

          [default: default]

          Possible values:
          - default:       Show printable ASCII characters as-is, '⋄' for NULL bytes, ' '
            for space, '_' for other ASCII whitespace, '•' for other ASCII characters, and
            '×' for non-ASCII bytes
          - ascii:         Show printable ASCII as-is, ' ' for space, '.' for everything
            else
          - codepage-1047: Show printable EBCDIC as-is, ' ' for space, '.' for everything
            else
          - codepage-437:  Uses code page 437 (for non-ASCII bytes)
          - braille:       Uses braille characters for non-printable bytes

      --color-scheme <FORMAT>
          Defines the color scheme for the characters

          [default: default]

          Possible values:
          - default:  Show the default colors: bright black for NULL bytes, green for
            ASCII space characters and non-printable ASCII, cyan for printable ASCII
            characters, and yellow for non-ASCII bytes
          - gradient: Show bright black for NULL bytes, cyan for printable ASCII
            characters, a gradient from pink to violet for non-printable ASCII characters
            and a heatmap-like gradient from red to yellow to white for non-ASCII bytes

  -P, --no-position
          Whether to display the position panel on the left

  -o, --display-offset <N>
          Add N bytes to the displayed file position. The N argument can also include a
          unit (see `--length` for details).
          A negative value is valid and calculates an offset relative to the end of the
          file.

          [default: 0]

      --panels <N>
          Sets the number of hex data panels to be displayed. `--panels=auto` will display
          the maximum number of hex data panels based on the current terminal width. By
          default, hexyl will show two panels, unless the terminal is not wide enough for
          that

  -g, --group-size <N>
          Number of bytes/octets that should be grouped together. You can use the
          '--endianness' option to control the ordering of the bytes within a group.
          '--groupsize' can be used as an alias (xxd-compatibility)

          [default: 1]

          Possible values:
          - 1: Grouped together every byte/octet
          - 2: Grouped together every 2 bytes/octets
          - 4: Grouped together every 4 bytes/octets
          - 8: Grouped together every 8 bytes/octets

      --endianness <FORMAT>
          Whether to print out groups in little-endian or big-endian format. This option
          only has an effect if the '--group-size' is larger than 1. '-e' can be used as
          an alias for '--endianness=little'

          [default: big]

          Possible values:
          - little: Print out groups in little-endian format
          - big:    Print out groups in big-endian format

  -b, --base <B>
          Sets the base used for the bytes. The possible options are binary, octal,
          decimal, and hexadecimal

          [default: hexadecimal]

      --terminal-width <N>
          Sets the number of terminal columns to be displayed.
          Since the terminal width may not be an evenly divisible by the width per hex
          data column, this will use the greatest number of hex data panels that can fit
          in the requested width but still leave some space to the right.
          Cannot be used with other width-setting options.

      --print-color-table
          Print a table showing how different types of bytes are colored

  -i, --include
          Output in C include file style

      --completion <SHELL>
          Show shell completion for a certain shell

          [possible values: bash, elvish, fish, powershell, zsh]

  -h, --help
          Print help (see a summary with '-h')

  -V, --version
          Print version
```

## HEXYL-CLI-D-015 — Short help (`-h`)

```text
A command-line hex viewer

Usage: hexyl [OPTIONS] [FILE]

Arguments:
  [FILE]  The file to display. If no FILE argument is given, read from STDIN

Options:
  -n, --length <N>                Only read N bytes from the input. The N argument can
                                  also include a unit with a decimal prefix (kB, MB, ..)
                                  or binary prefix (kiB, MiB, ..), or can be specified
                                  using a hex number. The short option '-l' can be used as
                                  an alias.
                                  Examples: --length=64, --length=4KiB, --length=0xff
                                  [aliases: bytes] [short aliases: c]
  -s, --skip <N>                  Skip the first N bytes of the input. The N argument can
                                  also include a unit (see `--length` for details).
                                  A negative value is valid and will seek from the end of
                                  the file.
      --block-size <SIZE>         Sets the size of the `block` unit to SIZE.
                                  Examples: --block-size=1024, --block-size=4kB [default:
                                  512]
  -v, --no-squeezing              Displays all input data. Otherwise any number of groups
                                  of output lines which would be identical to the
                                  preceding group of lines, are replaced with a line
                                  comprised of a single asterisk
      --color <WHEN>              When to use colors [default: always] [possible values:
                                  always, auto, never, force]
      --border <STYLE>            Whether to draw a border [default: unicode] [possible
                                  values: unicode, ascii, none]
  -p, --plain                     Display output with --no-characters, --no-position,
                                  --border=none, and --color=never
      --no-characters             Do not show the character panel on the right
  -C, --characters                Show the character panel on the right. This is the
                                  default, unless --no-characters has been specified
      --character-table <FORMAT>  Defines how bytes are mapped to characters [default:
                                  default] [possible values: default, ascii,
                                  codepage-1047, codepage-437, braille]
      --color-scheme <FORMAT>     Defines the color scheme for the characters [default:
                                  default] [possible values: default, gradient]
  -P, --no-position               Whether to display the position panel on the left
  -o, --display-offset <N>        Add N bytes to the displayed file position. The N
                                  argument can also include a unit (see `--length` for
                                  details).
                                  A negative value is valid and calculates an offset
                                  relative to the end of the file. [default: 0]
      --panels <N>                Sets the number of hex data panels to be displayed.
                                  `--panels=auto` will display the maximum number of hex
                                  data panels based on the current terminal width. By
                                  default, hexyl will show two panels, unless the terminal
                                  is not wide enough for that
  -g, --group-size <N>            Number of bytes/octets that should be grouped together.
                                  You can use the '--endianness' option to control the
                                  ordering of the bytes within a group. '--groupsize' can
                                  be used as an alias (xxd-compatibility) [default: 1]
                                  [possible values: 1, 2, 4, 8]
      --endianness <FORMAT>       Whether to print out groups in little-endian or
                                  big-endian format. This option only has an effect if the
                                  '--group-size' is larger than 1. '-e' can be used as an
                                  alias for '--endianness=little' [default: big] [possible
                                  values: little, big]
  -b, --base <B>                  Sets the base used for the bytes. The possible options
                                  are binary, octal, decimal, and hexadecimal [default:
                                  hexadecimal]
      --terminal-width <N>        Sets the number of terminal columns to be displayed.
                                  Since the terminal width may not be an evenly divisible
                                  by the width per hex data column, this will use the
                                  greatest number of hex data panels that can fit in the
                                  requested width but still leave some space to the right.
                                  Cannot be used with other width-setting options.
      --print-color-table         Print a table showing how different types of bytes are
                                  colored
  -i, --include                   Output in C include file style
      --completion <SHELL>        Show shell completion for a certain shell [possible
                                  values: bash, elvish, fish, powershell, zsh]
  -h, --help                      Print help (see more with '--help')
  -V, --version                   Print version
```

## HEXYL-CLI-D-016 — Usage error (`hexyl --bogus`)

Standard error, exit status 2:

```text
error: unexpected argument '--bogus' found

  tip: to pass '--bogus' as a value, use '-- --bogus'

Usage: hexyl [OPTIONS] [FILE]

For more information, try '--help'.
```
