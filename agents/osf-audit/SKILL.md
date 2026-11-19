---
name: osf-audit
description: >
  Verify consistency of an OSF project across all levels, traceability, test
  coverage and implementation compliance. Use when the user asks for a
  consistency check, review, or status of the specification, or before a
  release. Read-only unless the user asks for fixes.
---

# OSF — consistency audit

Load `osf` first. Read-only by default: report, do not fix, unless asked.

## Checks

1. **Structure (C-006/7, §4):** one directory per level; `index.md` exactly in
   directories that have subdirectories; same area names across levels; no
   single-document directories.
2. **Metadata (§6):** every document has `id`, `name`, `level`, `status`;
   IDs are unique and not path-derived.
3. **Top-down consistency:** for each L2 element, there is refinement at
   L3/L4 where needed; each L4 element has no contradiction with its parents;
   each element references its parent IDs.
4. **Bottom-up consistency:** no lower element contradicts a higher one
   (compare statements, formats, constants, error messages). Contradiction
   without a marker is a finding.
5. **Single source (C-003):** duplicated definitions with divergent content,
   including chapters repeated across PRD / SRS / FRD / SDD files (§3.7), and
   `document:` parts that no longer cover the chapters the standard requires.
6. **Traceability and tests (C-005, C-009):** every L2/L4 element lists the
   tests that verify it or says it is not covered; every L5 test references
   existing IDs; list orphans both ways.
7. **Configuration and targets (§4.5):** `open-specification-framework.yaml` paths exist; configured
   targets match what L1 requires; each target runs its own tests (report
   per target); behaviour differing between targets is specified as
   platform/target-specific, otherwise it is a finding.
   **Implementation:** run the test suite of each target; spot-check code against L4 for
   behaviours/outputs (C-014) that differ; look for unspecified behaviour.
8. **Markers:** list every `OSF-VIOLATION` and `OSF-WAIVED`; flag markers
   whose rule ID no longer exists, and `RUNNING` elements left behind.
9. **Status:** list `DRAFT`, `PENDING`, `RUNNING` elements awaiting a human.

## Output

A table sorted by severity:

| # | Severity | Check | Location (IDs + files) | Problem | Suggested fix |
|---|---|---|---|---|---|

Severity: `High` (contradiction with higher level, failing test), `Medium`
(missing trace, duplicated definition, unmarked deviation), `Low` (structure,
style). End with counts per severity and the violation block from
`osf-violations`.
