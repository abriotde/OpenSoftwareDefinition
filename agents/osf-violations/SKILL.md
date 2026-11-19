---
name: osf-violations
description: >
  How to write, track, resolve and waive OSF-VIOLATION / OSF-WAIVED markers in
  code and specification documents, and how to report them to the user at the
  end of a task. Use whenever a lower-level element contradicts a higher-level
  rule, or when a marker already exists in the files you touch.
---

# OSF — violations and waivers

Format source: method §7.3. Statuses: §7.2.

## Marker format

Use the comment syntax of the host file. Fields in this order:

```
OSF-VIOLATION:
   Rule: <ID> <name>
   Description: <one-line reminder of the rule>
   Violation: <why this location offends it>
   Status: VIOLATION
```

Waived exception:

```
OSF-WAIVED:
   Rule: <ID> <name>
   Description: <rule reminder>
   Violation: <why it deviates>
   Comment: <human's justification, who and when if known>
   Status: WAIVED
```

| Host | Syntax |
|---|---|
| Python, shell, YAML, TOML | `# …` on each line |
| C, C++, Java, Rust, JS/TS, Go | `// …` on each line |
| HTML, Markdown | `<!-- … -->` |
| SQL, Lua | `-- …` |
| Gherkin (`.feature`), TSL | `# …` |
| Other | the language's line comment; never a syntax that breaks the file |

Rules for placement:

- Put the marker **immediately above** the smallest element that offends
  (function, block, requirement, scenario), not at the top of the file.
- The marker must not change the program's behaviour and must keep the file
  valid (build/parse still works).
- `Rule:` is a stable ID of the **higher-level** element (e.g. `L2-REQ-003`
  or `HEXYL-CLI-F-012`), never a path. If the rule has no ID, add one in the
  spec as a refinement of identification only, or cite the document ID plus
  section and say so.
- One marker per rule per location. Do not merge different rules.

## Lifecycle

1. **Create** (`VIOLATION`) via `osf-sync-up` when a contradiction can't be
   avoided.
2. **Keep** it until resolved. Never remove or soften a marker silently, and
   never rewrite it to hide the offence.
3. **Resolve** only by one of:
   1. fixing the lower-level element so it complies (then remove the marker,
      mention it in the report);
   2. changing the higher-level spec through the review process
      (`osf-change`, user-approved), then updating the lower level;
   3. an **explicit human waiver**: convert to `OSF-WAIVED` with the human's
      reason in `Comment`. Do not waive on your own initiative.
4. Waived markers stay forever as documentation; re-evaluate them when the
   rule they deviate from changes.

## Finding existing markers

Search before and after your work, in the whole OSF root:

```
grep -rnE "OSF-(VIOLATION|WAIVED)" <root>
```

Do not leave new or pre-existing violations in files you touched without
mentioning them.

## End-of-task message to the user

When any violation exists (new or still open), end the final message with this
block, placed prominently:

```
OSF violations
  NEW      <rule ID> — <file>:<line> — <one-line reason>
  OPEN     <rule ID> — <file>:<line> — <one-line reason>
  RESOLVED <rule ID> — <file>:<line>
  WAIVED   <rule ID> — <file>:<line>
Decision needed: fix the lower level, change <rule ID> (osf-change), or waive.
```

If there is none, say "No OSF violations."
