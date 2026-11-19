---
name: osf-check-external
description: >
  Check that the OSF specifications agree with a document stored outside the
  spec tree (a customer PRD, an SRS from a contract, a wiki page, a standard,
  a published design document), for example "check accordance with the PRD in
  myprd.md", typically after updates. Read-only comparison with a gap report;
  never edits the external document or the specs without approval.
---

# OSF — check accordance with an external document

Load `osf` first. Method §3.7 (standard documents) and §7.4.

## Inputs

- The external document: a file path or URL. Read files with `read` (it also
  handles PDF), URLs with `webfetch`. If it can't be read, say so.
- Optional scope: levels or areas to limit the check to.
- The **role** of the document. Infer it from the request, and ask when
  unclear:

  | Role | Meaning | Direction of authority |
  |---|---|---|
  | `upstream` (default) | A source the specs must satisfy (customer PRD, contract SRS, standard) | External → specs. A difference is a candidate requirement change. |
  | `downstream` | A document that must reflect the specs (README, wiki, published design) | Specs → external. A difference means the external document is out of date. |

  An external document is never automatically correct: a difference needs a
  human decision (C-010).

## Procedure

1. **Read the external document** and split it into atomic statements
   (requirement, constraint, decision, definition). Ignore content outside the
   method's scope (market, roadmap, prioritisation) and list it under "Out of
   scope".
2. **Place each statement at a level** using method §3.7: PRD → L1,
   FRD / SRS specific requirements → L2, SDD architecture → L3, SDD details
   → L4, test plan → L5. Use the level that actually owns the statement.
3. **Find the matching spec element** in that level (by meaning, then by IDs).
   Read the specs top-down and only the areas concerned.
4. **Classify** each statement:

   | Result | Meaning |
   |---|---|
   | `COVERED` | The spec states the same thing. |
   | `PARTIAL` | The spec states part of it, or less precisely. |
   | `MISSING` | No spec element corresponds. |
   | `CONTRADICTED` | The spec says something incompatible. |
   | `AMBIGUOUS` | The statement can't be mapped without a decision. |

5. **Reverse direction:** list spec elements at the checked levels that the
   external document does not mention (`EXTRA`). They are not errors; they
   are added detail or undocumented requirements.
6. **Check lower levels** only when the external statement implies a
   consequence there (e.g. a new L1 constraint affects L2–L4 or the code).
   Say which lower elements are affected, but do not audit the whole project
   (that is `osf-audit`).

## Output

A table, one row per statement, sorted by severity:

| # | External ref (section/line) | Statement | Level | Spec element (ID, file) | Result | Suggested action |
|---|---|---|---|---|---|---|

Then: counts per result, `EXTRA` elements, out-of-scope content, and the
questions for the user. Severity: `CONTRADICTED` > `MISSING` > `PARTIAL` >
`AMBIGUOUS` > `EXTRA`.

## Actions (only on the user's request)

- `upstream` differences → propose a change request and run `osf-change`
  from the highest affected level. Record the origin in the front matter of
  the edited documents (e.g. `source: myprd.md section 3`) if the user wants.
- `downstream` differences → propose the text to update in the external
  document, or generate it from the specs. Do not edit it unless asked.
- A spec behaviour that is intended but contradicts an upstream document needs
  a documented exception from the user, not a silent edit. If it lives in code
  or in a lower level, use the `osf-violations` marker with the external
  statement as the rule.

## Rules

- Read-only by default: do not modify the external document or the specs
  while checking.
- Never treat a match in wording as proof of conformance, or a mismatch in
  wording as a contradiction: compare meaning.
- Quote the external statement briefly; do not reproduce the document.
- Say which version/date of the external document was checked (file
  modification time or document version), so the check can be repeated after
  updates.
