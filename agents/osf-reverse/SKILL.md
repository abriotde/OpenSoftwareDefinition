---
name: osf-reverse
description: >
  Reconstruct OSF specifications (L1–L5) from an existing implementation.
  Use when the user has code but no or outdated specs, wants to adopt OSF on
  an existing project, or asks to document what the software does.
---

# OSF — reverse engineering

Load `osf` first. Rules from method §8.1. Specs produced here are **not
approved** (C-010) and observed behaviour is **not** requirement.

## Procedure

1. **Survey:** user docs, README, man pages, tests, public interface, build
   files. Language and environment go to L1.
2. **Write L1 and L2 from documentation first**, then confirm against code.
3. **L3/L4 from code:** components, algorithms, formats, messages. Capture
   exact outputs (help, errors, formats) **by running the program** whenever
   possible (C-014).
4. **L5 from existing tests:** describe what they cover and what they don't;
   mark uncovered elements.
5. **Origin tag on every requirement:**
   - `DOCUMENTED`: in user documentation and confirmed in code.
   - `OBSERVED`: only read from code/tests.
   - `ASSUMPTION`: interpretation awaiting confirmation.
6. **Findings register** (one document, e.g. `L4-detailed/findings.md`):
   anomalies, doc-vs-code contradictions, probable bugs; each with a stable
   ID, evidence, where the spec handles it, and decision `OPEN`. Do not turn
   them into requirements. When the spec must describe such behaviour, write
   it as *current behaviour* and cite the finding.
7. Mark every document `origin: reverse-engineered`, `status: DRAFT`.
8. **Completeness check (§8.2):** ask yourself whether an implementer with
   only L1–L4 could pass the L5 tests; record gaps as findings.
9. Put reference to the original source in L6 (it may be a separate
   directory); do not copy third-party code into specs.

End with the final report and the list of `OPEN` findings and `ASSUMPTION`s
for the user to decide.
