---
name: osf-change
description: >
  Handle a user request to add, modify or remove behaviour in an OSF project.
  Use for every modification request: first update the highest affected
  specification level, then propagate down through L2–L5 to the code.
  Includes impact analysis.
---

# OSF — change request (top-down)

Load `osf` first. This is the default workflow for "make the software do X".

## Procedure

### 1. Impact analysis (read-only)

1. Restate the request in one sentence.
2. Find the **highest level** whose content must change:
   - new/removed purpose, scope, constraint, language → L1
   - user-visible behaviour, business rule → L2
   - components, responsibilities, interfaces → L3
   - algorithms, formats, messages, errors → L4
   - only tests → L5
   - behaviour already specified but code differs → not a change: use
     `osf-sync-up`.
3. Follow IDs and references downward and build the chain: edited element →
   refining elements at lower levels → tests → code locations.
4. Check **upward** too: does the change contradict any element above the
   level you will edit? If yes, that higher element must change as well (or
   the request must be refused/clarified). Never stop at the first level.
5. Check **siblings**: other elements that reuse or depend on the changed one.

If the change is large, or the request is ambiguous or contradicts an existing
requirement, present the chain and the question to the user **before**
editing. Otherwise continue.

### 2. Update the highest level first

- Edit the authoritative definition only (C-003); do not duplicate it.
- Set the element `status: RUNNING` while editing, then `PENDING` (awaiting
  human review) when done.
- Keep IDs stable. For a removal request, set the element `DEPRECATED`
  (method §7.2) instead of deleting it; physical deletion needs separate
  explicit user authorisation.

### 3. Propagate down, level by level

For each lower level in order (L2 → L3 → L4 → L5 → L6):

1. Update only elements in the impact chain.
2. After each level, re-read it against the level above to confirm
   compliance; set `COMPLIANT`.
3. If a lower level cannot comply without contradicting the higher one: stop
   and ask. Do not "fix" the higher level to make it fit (see `osf-sync-up`
   if code must temporarily deviate; mark with `osf-violations`).

### 4. Tests and code

- L5: add/modify tests before code; each references the verified IDs.
- L6: implement, run tests, fix.
- Code written in this step follows the spec by construction. If a decision
  has to be made that the spec does not cover, add it to L4 (lower level
  detail is allowed) rather than leaving it only in code.

### 5. Close

Verify the chain is consistent top to bottom, then give the final report
defined in `osf`. List every higher-level edit as `PENDING` review.
