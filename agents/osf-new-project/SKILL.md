---
name: osf-new-project
description: >
  Start a new software project with OSF. Use when the user wants to create a
  new program/library/system and no L1–L6 structure exists yet. Builds the
  specification top-down (L1 → L5) with the user before writing code.
---

# OSF — new project

Load `osf` first for the core rules.

## Procedure

1. **Capture intent (L1).** Ask only what is missing: purpose, users, scope
   and exclusions, main capabilities, constraints, implementation language and
   environment. Write `L1-general/product_requirements_document.md`, plus
   `software_requirements_specification_part1.md` only for chapters the PRD
   does not cover (method §3.7). The language lives **only** in L1 (C-001).
2. **Stop and confirm L1** with the user in a short summary. Everything below
   depends on it; a wrong L1 is the costliest error.
3. **L2 functional.** `functional_requirements_document.md`: requirements
   with stable IDs (`<PROJECT>-<AREA>-F-nnn`), each verifiable (C-009).
   Include errors and acceptance criteria. Quality requirements, external
   interfaces and design constraints go to `software_requirements_specification_part2.md`, only if needed.
4. **L3 architectural.** `software_design_description_part1.md`:
   components, responsibilities, interfaces. PlantUML for diagrams. Only if
   the project warrants it (C-013).
5. **L4 detailed.** `software_design_description_part2.md`. Contracts, pseudocode, data, error catalogue, exact
   outputs (C-014). Reference the tests that verify each element.
6. **L5 tests** before code: Gherkin for L2, TSL for input spaces, pseudocode
   unit tests for L4. Each test references the IDs it verifies.
7. **L6 code.** Implement from L4/L5 in each required target. Run the tests.
   Create `open-specification-framework.yaml` (method §4.5) when anything differs from the defaults
   (source folder, several languages/platforms, level paths). Ask which
   targets are wanted; the required languages and platforms belong in L1,
   the paths and commands in `open-specification-framework.yaml`.
8. Apply `osf-sync-up` to anything the code forced you to decide that the spec
   does not say.

## Rules

- Start each level as **one document**; split into directories only when an
  area needs substantial detail (C-007, C-013). `index.md` only in a directory
  that has subdirectories.
- Keep an area's directory name identical across levels (C-006).
- Use the document template from method §6 (front matter: `id`, `name`,
  `level`, `status`, optional `origin`). New documents are `status: DRAFT`
  (`PENDING` once the user is asked to review).
- Ask for approval between levels when the user's request is vague; for a
  precise request, proceed through levels and ask once at the end.
- Do not invent requirements to fill sections: leave a section empty
  (not yet specified) or write `Not applicable` / `None` (method §6.1).
