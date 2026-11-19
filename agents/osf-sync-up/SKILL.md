---
name: osf-sync-up
description: >
  Bottom-up synchronisation in an OSF project. Use whenever code (L6), tests
  (L5) or detailed specs (L4) are edited directly, including bug fixes and
  refactors, and after any implementation step. Updates the sub-levels the
  edit owns, checks it against higher levels, and marks contradictions with
  OSF-VIOLATION instead of modifying higher levels.
---

# OSF — bottom-up sync

Load `osf` first. Run this after every lower-level edit, before you report
completion.

## Procedure

1. **List what changed** (files, functions) and map each to the spec elements
   it implements or verifies (IDs in headers, comments, L5 references; search
   the spec if absent).
2. **Classify each change:**

   | Class | Meaning | Action |
   |---|---|---|
   | Conformance | Restores/implements what the spec says | No spec change. Mark `COMPLIANT`. |
   | Refinement | Adds detail the higher level leaves open | Record it at the **lowest level that owns it** (L4, or L5 for tests). Allowed (C-004). |
   | Contradiction | Code behaves differently from L1–L4 | Violation (below). |
   | Unspecified | Behaviour exists that no spec covers | Treat as refinement if harmless, otherwise ask. Never assume it is intended (reverse rules, method §8). |

3. **Update owned sub-levels.** Update L4 and L5 (and L3 if the change is
   purely structural and stays within L2) so they describe the code truthfully
   and still comply with L1–L2. Do this directly: that is the agent's job.
4. **Check upwards.** For each changed element, verify compliance with every
   applicable higher-level element (parent L4 → L3 → L2 → L1; constraints in
   L1 such as language and platform).
5. **On contradiction, do not edit the higher level.** Either:
   - **Preferred:** change your lower-level edit to restore compliance; or
   - if the user's instruction requires the deviation, or compliance is
     impossible, **insert an `OSF-VIOLATION` marker** at the offending
     location (code line, L4/L5 section) with the violated rule ID, using
     `osf-violations`, and continue.
6. Never convert a violation into a spec edit on your own. If the lower-level
   behaviour is actually desirable, tell the user and propose a change request
   (`osf-change`), but leave the marker until they decide.
7. **Report** at the end of the task, prominently, every violation created or
   still open (see `osf-violations`).

## Direct user instruction that contradicts the spec

If the user says "just do X" and X contradicts a higher level:

1. Tell the user which rule it contradicts, before or while doing it.
2. Do it only if they confirm, or if the instruction was explicit.
3. Insert the marker. Offer `osf-change` to bring the spec in line later.
