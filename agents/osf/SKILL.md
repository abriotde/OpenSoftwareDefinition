---
name: osf
description: >
  Core rules of the Open Specification Framework (OSF) method and router to the
  other osf-* skills. Load this first in any project that has
  L1-general/ ... L6-code/ directories or that the user wants to manage with
  OSF. Use it whenever the user asks to start a project, change behaviour,
  fix or edit code, or check consistency in such a project.
---

# OSF — core rules

Reference: `open-specification-framework.md` (the method). If this skill and the
method disagree, the method wins; report the discrepancy.

## Levels

L1 general → L2 functional → L3 architectural → L4 detailed → L5 test → L6 code.
Each level refines the one above. **Higher levels are authoritative.**

## Golden rules

1. **Spec first, top-down.** Any request (new project or modification) starts
   by finding the highest level it touches and updating that level first, then
   propagating downward, code last.
2. **Never silently change a higher level to excuse a lower one.** Lower-level
   work that contradicts a higher level gets an `OSF-VIOLATION` marker and is
   reported to the user (skill `osf-violations`).
3. **A user request is the approval for the higher-level change it implies,**
   and only that. Anything beyond it (side effects on other requirements,
   ambiguity) is asked, not assumed. Those edits are still listed as
   `PENDING` for human review (C-010).
4. **Never delete a specification, or remove a violation, without explicit
   authorisation.**
5. **Passing tests are not proof of compliance** (L5 verifies L2–L4; it does
   not replace them).
6. **Concise specs (C-013).** Add detail only when it is new information.
7. Report ambiguities before assuming.

## Pick the skill

| Situation | Skill |
|---|---|
| Empty or non-OSF project, user wants a new software | `osf-new-project` |
| User asks to add / change / remove a behaviour or feature | `osf-change` |
| Code (or L4/L5) edited directly, or a bug fix, with no spec-level request | `osf-sync-up` |
| Writing, resolving or waiving a violation marker; end-of-task report | `osf-violations` |
| User asks "is everything consistent?" / before a release | `osf-audit` |
| Existing code, no or stale specs | `osf-reverse` |

Several skills can apply in one task (typically `osf-change`, then
`osf-sync-up` once code is touched, and `osf-violations` for the final
report). Load each when you reach that step.

## Locating the specification

1. Find the level directories (`L1-*` … `L6-*`) from the project root. If the
   user works in a sub-folder (e.g. `test/hexyl/`), the nearest ancestor that
   contains them is the OSF root.
2. Read top-down and only as deep as needed: L1, then the L2/L3/L4 documents
   of the affected area (same directory name across levels, C-006), then L5
   and code.
3. Use stable IDs from document front matter (C-005), never file paths, to
   reference elements.

## Element status

States from method §7.2: `RUNNING`, `COMPLIANT`, `VIOLATION`, `PENDING`,
`WAIVED`, `DEPRECATED`. Record them in front matter (`status:`) for documents or in the
marker for code. Set `RUNNING` while you edit and never leave it at the end
of a task: finish at `COMPLIANT` or `PENDING` (or `VIOLATION`).

## Final report (every task)

End every task with:

- Files modified, by level.
- Higher-level edits made (ID, what, why) — all `PENDING` review.
- Violations created, still open, and waived (rule ID, location).
- Tests created / modified / run, and results.
- Elements not covered by any test.
- Ambiguities and questions for the user.
