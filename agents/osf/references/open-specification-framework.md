# Open Specification Framework — Specification Method

## Working Draft — Version 0.0.2

**Status:** Working draft
**Language:** English
**Purpose:** Define a language-independent, hierarchical method for specifying software from high-level intent down to source-code implementation.


## 1. Purpose and motivation

Modern AI coding agents can produce large amounts of source code very quickly. This creates a review and maintenance problem: even when source code is publicly available, it may be impractical for humans to inspect and understand every implementation detail.

This method proposes making the software specification a first-class project artefact. Rather than relying on source code as the only authoritative description of a software system, the project maintains a structured specification that progressively refines the system from its general purpose to detailed behaviour and, finally, implementation.

The method is intended to support both:

- **Forward engineering:** deriving increasingly detailed specifications and implementation from high-level requirements.

- **Reverse engineering:** analysing an existing implementation and reconstructing a specification of its observed behaviour and structure.

A specification generated from existing code must not automatically be treated as a statement of intended behaviour. It must distinguish observed implementation behaviour from requirements and from assumptions.

## 2. Core principles

### C-001 — Language independence

Specifications at levels L1 to L5 shall describe the software independently of the programming language used for implementation. The required language(s) and platform(s) are recorded only in L1; where and how each implementation is built is described by the project configuration (section 4.5).

The specification describes what the system is required to do, how its responsibilities are organised, and how its behaviour is defined. It should not unnecessarily prescribe language-specific constructs.

The implementation language and other implementation technologies may be recorded in the general project description (L1).

### C-002 — English convention

English is the conventional language for specification documents, identifiers, and standard terminology.

A project may contain additional translations, but they should not create competing authoritative definitions.

### C-003 — Single source of truth

Each piece of information shall have one authoritative definition.

Other specification elements may:

- reference that definition;

- refine it with additional detail;

- constrain it within their own scope; or

- explain its consequences.

They shall not silently redefine or duplicate it.

A summary or reminder may repeat information for readability, provided that the authoritative source is clearly referenced.

### C-004 — Progressive refinement

The specification is organised into successive levels of increasing precision.

Each level refines the decisions and descriptions established by the level above it. A lower-level element shall remain consistent with the higher-level elements from which it derives.

Refinement adds detail; it must not silently change the meaning of an approved higher-level requirement.

### C-005 — Traceability

Specification elements shall be identifiable and traceable across levels.

A specification element should be traceable to the higher-level elements that justify or constrain it. Where relevant, it should also identify lower-level elements that realise or refine it.

Identifiers shall be stable and shall not depend on the element's filesystem path.

### C-006 — Hierarchical organisation

The specification shall be organised into one directory per specification level.

Where an area is detailed in a directory at several levels, it shall keep the same name so that corresponding areas of the system can be found easily. Directories exist to detail parts of the application; a level does not need a directory for every area.

The hierarchy represents the logical decomposition of the software. It is not required to reproduce the source-code directory structure.

### C-007 — Flexible decomposition

The method shall support projects of very different sizes, from small applications to systems as large as the Linux kernel.

Each area may be subdivided into as many directories and documents as are useful.

A lower level may introduce a finer-grained decomposition while preserving its relationship to the parent area. The hierarchy therefore needs to be consistent, but not necessarily identical in depth at every level.

A directory that contains subdirectories shall contain an `index.md` file explaining the organisation of those subdirectories. A directory without subdirectories does not need an `index.md`.

A subdirectory exists to detail a part of the application. It shall not be created only to wrap a single document, and an area that needs no further detail at a given level does not need a directory at that level.

### C-008 — Standardised document structure

Specification documents shall use a common set of recognised sections and metadata.

The structure is standardised, but not every section must contain information in every document. A section may be:

- omitted when it is not relevant;

- present but empty when it has not yet been specified; or

- explicitly marked as not applicable when that is the intended meaning.

An empty section must not be interpreted as proof that no requirement, constraint, or behaviour exists.

### C-009 — Verifiability

Specifications should be written so that their statements can be checked objectively whenever possible.

A specification may identify a verification method, acceptance criterion, or related test. Verification information should be traceable to the specification element it checks.

### C-010 — Human review and approval

AI-generated specifications and proposed changes shall remain reviewable by humans.

Generation by an AI agent does not, by itself, make a specification correct or approved.

### C-011 — Implementation is the final level

The source-code implementation (L6) is the final level of the refinement chain.

The implementation may be written by humans, generated by AI agents, or produced through a combination of both.

The code shall conform to the applicable specifications at levels L1 to L5. A code change shall trigger a check that the relevant specifications remain accurate and consistent.

### C-012 — Used standards

- ISO/IEC/IEEE 29148 for Requirements engineering

- ISO/IEC/IEEE 42010 for Architecture description

- UML 2.5 for Architecture modelling in PlantUML preferred, XMI overwise.

- YAML for metadata definitions

- Object Constraint Language (OCL) for formal constraints

- Markdown for defaults documentation format.

### C-013 — Conciseness

A specification shall be as small as its content allows. Detail is added only when it carries information that is not already stated elsewhere.

- A level starts as a single document. It is split into subdirectories or several documents only when an area needs substantial detail (see 4.1).

- An area shall not get a document or directory at a level only to restate the level above.

- Standard sections that have nothing to say are omitted rather than written empty. Purpose, references and verification are given once per document, not once per element, unless an element differs from its document.

- Tables are preferred for lists of uniform items such as requirements, components and error messages.

### C-014 — Externally observable text and reference data

Information that a conforming implementation must reproduce exactly shall be specified verbatim at L4. This includes help and version output, error and diagnostic messages, file and output formats, and example outputs. Variable parts (such as terminal width or version number) shall be identified.

Reference data that is defined by an authoritative external source (standards, character tables, protocol constants) shall be referenced by a stable link, with the revision or version used, and with its licence when relevant. It need not be copied if the source is stable and freely available. The specification shall state which differences from the source apply, and what a verifier must compare.

Text or data generated by a third-party component whose content the project does not control may be specified by its required properties instead of verbatim, and this shall be said explicitly.


## 3. Specification levels

The method defines six levels.

| Level | Name | Purpose |
| - | - | - |
| L1 | General specification | Describe the system, its purpose, scope, context, main capabilities, constraints, and implementation environment. |
| L2 | Functional specification | Describe the functions and externally observable behaviours the system must provide. |
| L3 | Architectural specification | Describe the system's major components, responsibilities, boundaries, and interactions. |
| L4 | Detailed specification | Describe detailed behaviour, interfaces, data, algorithms, rules, error cases, and other implementation-independent details. |
| L5 | Test specification | Describe the tests that verify L2 to L4 and the errors they detect. |
| L6 | Implementation | Provide the actual source code and other implementation artefacts. |


**Unidirectional Refinement**

Each specification level shall refine and add precision to the level immediately above it. Refinement is strictly unidirectional: a lower-level specification may introduce implementation-independent or implementation-specific details, design choices, and constraints, but shall not modify or redefine the requirements or decisions established at a higher level.

A higher-level specification remains authoritative over all its lower-level refinements. Any change to a higher-level specification must be propagated to the affected lower levels.

Conversely, a lower-level specification may reveal inconsistencies, ambiguities, or missing information in a higher-level specification. Such findings may trigger a formal change proposal to the higher-level specification, but shall never modify it implicitly.

Each level may be decomposed into as many sub-levels as necessary to progressively refine the specification.

### 3.1 L1 — General specification

L1 provides an overview of the software that can be understood without reading its source code.

It is defined by ISO/IEC/IEEE 29148.

It may include:

- purpose and objectives;

- scope and exclusions;

- users and other actors;

- operating context;

- main capabilities;

- global constraints;

- external systems and dependencies;

- implementation environment, including programming language, frameworks, platforms, and major technologies.

Implementation technologies are recorded here as project context. They must not unnecessarily constrain the language-independent specifications in L2 to L4.

### 3.2 L2 — Functional specification

L2 describes what the software must do, independently of how it is implemented.

It is defined by ISO/IEC/IEEE 29148.

It may include:

- functional requirements;

- use cases and user-visible capabilities;

- inputs and outputs at the functional boundary;

- expected behaviour;

- business rules;

- functional constraints;

- exceptional situations and expected outcomes;

- quality requirements (performance, security, usability, reliability, ...);

- acceptance criteria.

Requirements should be sufficiently precise to be reviewed and verified.

### 3.3 L3 — Architectural specification

L3 describes how the system is logically organised. It is defined by ISO/IEC/IEEE 42010 and should use UML 2.5 in PlantUML format or XMI when PlantUML is not applicable.

It may include:

- components and subsystems;

- responsibilities and boundaries;

- interfaces and interactions;

- communication and data flows;

- dependencies between components;

- relevant structural and behavioural models.

UML may be used where appropriate. UML is a modelling option within the method, not the complete specification format and not a mandatory representation for every element.

### 3.4 L4 — Detailed specification

L4 describes the detailed behaviour and contracts of the system's elements without prescribing programming-language-specific implementation details.

L4 : Markdown + pseudocode + contrats It can use Object Constraint Language (OCL) when applicable.

Depending on the element, it may include:

- interfaces;

- abstract data structures and data models;

- inputs and outputs;

- algorithms expressed in language-independent pseudocode;

- preconditions and postconditions;

- invariants;

- state and transition rules;

- error conditions and error handling requirements;

- concurrency and timing behaviour;

- constraints;

- verification criteria and test references.

At L4, algorithms, data models, error catalogues and exact output formats are specified. Each element should reference the tests that verify it and say when it is not covered.

L4 should provide enough information for an implementer to understand the required behaviour without having to infer essential rules from the source code.

### 3.5 L5 — Test specification

L5 describes the tests that verify the specification, independently of the test framework and programming language. In forward engineering, L5 is derived from L2 and L4 before the code exists. In reverse engineering, L5 describes the tests the implementation already has, and what they cover and do not cover.

L5 refines L4: it adds verification detail and shall not change requirements or behaviours defined at L1 to L4 (see Unidirectional Refinement).

Notations, chosen by kind of test:

| Kind of test | Notation |
| - | - |
| Functional, acceptance and end-to-end tests (L2) | Gherkin (`Feature`, `Scenario`, `Given`/`When`/`Then`) |
| Other tests: input-space partitioning, combinations, non-functional and configuration tests | Test Specification Language (TSL, category-partition method: parameters, categories, choices, constraints) |
| Unit tests (L4 elements) | Python-like pseudocode, language-independent: a test is a function with set-up, call, and assertions; no framework-specific constructs |


Each test or test group shall reference the specification elements it verifies (C-005, C-009). Where a notation does not fit, the document may use another and shall say which.

An L5 document may include:

- the test cases and their notation;

- the mapping from specification elements to tests, and the elements that no test covers;

- test data and expected results;

- the errors detected: for each failing test or defect found by testing, the test, the observed versus expected result, the affected specification element, and a status (see section 8.1 for findings).

### 3.6 L6 — Implementation

L6 is the actual implementation, including source code and relevant implementation artefacts.

The implementation language and technologies are identified in L1. L6 contains the code itself; it is not another prose specification level.

A project may have several L6 implementations, called **targets** (for example one per language or platform). Each target conforms independently to L1 to L5; none of them defines the specification. Targets are located and described in the project configuration (section 4.5).


### 3.7 Standard documents in the levels

Common industry documents are not separate artefacts: they are the specification documents of the levels, named after them and split by chapter. A project uses only the documents it needs (C-013), and the names are recommended, not mandatory.

| File | Level | Chapters |
| - | - | - |
| `product_requirements_document.md` (PRD) | L1 | purpose and objectives, users and actors, scope and exclusions, main capabilities, success criteria, global constraints, implementation environment |
| `software_requirements_specification_part1.md` (SRS, part 1) | L1 | introduction and overall-description chapters of the SRS (ISO/IEC/IEEE 29148) not already covered by the PRD: product perspective and operating context, user characteristics, assumptions and dependencies, definitions, references |
| `functional_requirements_document.md` (FRD) | L2 | functional requirements, use cases, inputs and outputs, business rules, exceptional situations, acceptance criteria |
| `software_requirements_specification_part2.md` (SRS, part 2) | L2 | specific-requirements chapters not already covered by the FRD: external interface requirements, quality requirements, design constraints |
| `software_design_description_part1.md` (SDD, part 1) | L3 | IEEE 1016 viewpoints describing the organisation: context, composition, logical, dependency, interaction, patterns |
| `software_design_description_part2.md` (SDD, part 2) | L4 | IEEE 1016 viewpoints describing the details: interface, information, structure, state dynamics, algorithm, resource |

Rules:

- **A chapter is written once**, in the file of the level that owns it. A document that would repeat a chapter already covered by another file omits it (C-003). Where a standard requires the chapter to exist, a reference to the authoritative one replaces it.
- A document that spans levels has one file per level, named with a `_partN` suffix (N in level order) to avoid confusion, each carrying the metadata `document` (for example `SRS`) so that tools can reassemble it.
- The verification chapters of these standards are specified in L5, and are omitted from these documents.
- Large projects place these documents in area directories (C-006, C-007), for example `L2-functional/networking/functional_requirements_document.md`.
- Content outside the method, such as market analysis, roadmap and prioritisation, is not required. A project may keep it elsewhere.
- Chapter titles follow the standard when a project claims conformance to it. The lists above are indicative.

## 4. Directory organisation

### 4.1 General layout

A project shall have one directory for each specification level. A level directory contains its specification documents and, when the level needs it, subdirectories that detail parts of the application. A level directory contains an `index.md` only if it has subdirectories (see 4.2).

Levels are not required to share the same subdirectories: a small level may be a single document, while another level of the same project is split into many subdirectories.

A typical layout, for a project whose L1 is a single document and whose lower levels are split, is:

```
root/  
├── L1-general/  
│   └── overview.md  
│  
├── L2-functional/  
│   ├── index.md  
│   ├── core.md  
│   ├── filesystem.md  
│   └── networking/  
│       ├── index.md  
│       ├── ipv4.md  
│       └── ipv6.md  
│  
├── L3-architectural/  
│   ├── index.md  
│   ├── core.md  
│   ├── filesystem.md  
│   └── networking/  
│       ├── index.md  
│       ├── ipv4.md  
│       ├── ipv6.md  
│       └── routing.md  
│  
├── L4-detailed/  
│   ├── index.md  
│   ├── core.md  
│   └── networking/  
│       ├── index.md  
│       ├── ipv4/  
│       │   ├── index.md  
│       │   └── ...  
│       └── routing.md  
│  
├── L5-test/  
│   ├── functional.feature  
│   ├── categories.tsl  
│   └── unit.md  
│  
└── L6-code/
```

This is an illustrative layout, not a mandatory list of directories.

### 4.2 Index files

An `index.md` is required only in a directory that has subdirectories. Its role is to explain how those subdirectories divide the area (which part of the application each one details).

The index shall not describe the specification process, restate the method, or list the documents of the directory one by one when that adds nothing. It should not duplicate definitions that belong in other specification documents.

Directories without subdirectories have no `index.md`; their documents are self-describing through their metadata and titles.

### 4.3 Consistency across levels

When an area is detailed in a directory at several levels, it shall keep the same recognisable name at each of them.

For example, if a `networking` directory exists at L2 and at L3, it is the same logical area. An area is not required to have a directory at every level.

A lower level may split that area into more specific subdirectories. For example:

```
L2-functional/networking/  
L3-architectural/networking/  
L4-detailed/networking/  
    ├── index.md  
    ├── ipv4/  
    ├── ipv6/  
    └── routing/
```

The hierarchy is a navigational and conceptual structure. It does not require a one-to-one correspondence between directories at every level.

### 4.4 Independence from source layout

The specification hierarchy shall describe the logical system, not merely mirror the source-code tree.

This distinction is important for large projects. For example, the logical specification of a subsystem may span several source directories, or a source directory may contain code belonging to several logical concerns.

### 4.5 Project configuration (`open-specification-framework.yaml`)

A project may contain an `open-specification-framework.yaml` file at its root. It locates and describes the parts of the project; it does not specify anything. Every key is optional. The directory containing `open-specification-framework.yaml` is the project root; without the file, the root is the nearest ancestor containing the level directories of section 4.1 and the defaults below apply.

```yaml
osf: 0.0.2                     # version of the method followed
project: OHEMS                 # prefix of element identifiers (5.1)
levels:                        # paths relative to this file
  L1: spec/L1-general          # default: L1-general
  L2: spec/L2-functional       # default: L2-functional
  L3: spec/L3-architectural    # default: L3-architectural
  L4: spec/L4-detailed         # default: L4-detailed
  L5: spec/L5-test             # default: L5-test
targets:                       # default: one target "main" at L6-code
  - id: python
    path: src                  # existing source folder, outside the spec tree
    exclude: [.venv, dist]     # not part of the implementation
    language: Python
    platforms: [linux, windows]
    build: uv build
    test: uv run pytest
  - id: rust
    path: rust
    language: Rust
    platforms: [linux]
    areas: [core]              # areas implemented; default: all
    test: cargo test
```

Rules:

- The configuration says **where** and **how**, never **what**. Requirements, including the required languages and platforms, are specified in L1 to L4 (C-003). A target that L1 does not allow, or a required target that is not configured, is a violation of L1.
- Each target shall conform to the same L1 to L5. A behaviour that differs between targets or platforms shall be specified at L2 to L4 as conditional on the platform or target. Without that, the difference is a violation in the deviating target.
- A target with `areas` implements only those areas (directory names, C-006). Unimplemented areas are not violations.
- L5 tests are language-independent; each target binds them to its own `test` command. Results are reported per target.
- The configuration shall not relax the rules of this method. Paths, commands and exclusions are overridable; principles, statuses and markers are not.
- A configured path that does not exist is reported to the human; it is not created silently.


## 5. Specification elements and identifiers

### 5.1 Stable identifiers

Each significant specification element shall have a unique, stable identifier.

Identifiers shall not be derived solely from filesystem paths, because documents and directories may be moved or reorganised.

Illustrative identifiers:

```
NET-001        Networking subsystem  
NET-IPV4-001   IPv4 subsystem  
NET-ROUTE-001  IPv4 routing
```

The exact identifier syntax and namespace rules remain to be defined.

### 5.2 References

Documents shall use identifiers to refer to other specification elements.

References should make the relationship clear, for example:

- refines;

- derived from;

- depends on;

- realises;

- verifies;

- constrains.

The exact controlled vocabulary and relationship model remain to be defined.

### 5.3 Single authoritative definition

When an element is referenced from several documents, its definition remains in one authoritative location.

Other documents may summarise it for readability, but should link to the authoritative definition and must not introduce conflicting definitions.


## 6. Standard document structure

Specification documents shall use a common structure where applicable.

The following is an initial proposed template. Sections are optional unless a later version of the method explicitly makes a particular field mandatory.

```
---  
id: FUNC-001  
name: Calculate total power  
level: L4  
status: DRAFT  
---  
  
\# FUNC-001 — Calculate total power  
  
\#\# Purpose  
  
\#\# Description  
  
\#\# Inputs  
  
\#\# Outputs  
  
\#\# Preconditions  
  
\#\# Postconditions  
  
\#\# Invariants  
  
\#\# Behavior  
  
\#\# Error handling  
  
\#\# Dependencies  
  
\#\# Constraints  
  
\#\# Verification  
  
\#\# References
```

### 6.1 Empty, omitted, and not-applicable sections

These cases have distinct meanings:

| Representation | Meaning |
| - | - |
| Section omitted | The section is not included in this document. |
| Section present but empty | The section is recognised, but its content has not yet been specified. |
| `Not applicable` | The section has been considered and does not apply to this element. |
| `None` | The section applies, and it has been determined that there are no items to list. |


Projects and tools should preserve these distinctions.

### 6.2 Document metadata

The example metadata includes an identifier, name, level, and status.

Recommended optional metadata fields: `document` (the standard document the file belongs to, section 3.7), `origin` (`forward` or `reverse-engineered`), `status` (`DRAFT`, then values defined by the approval workflow).

Recommended identifier convention for elements: `\<PROJECT\>-\<AREA\>-\<KIND\>-\<nnn\>`, where KIND is `F` (functional requirement, L2), `C` (component, L3) or `D` (detailed element, L4). The convention is not mandatory (see section 11).

The precise metadata schema, mandatory fields, allowed status values, and validation rules have not yet been finalised.


## 7. Refinement and change propagation

### 7.1 Refinement chain

The intended refinement chain is:

```
L1 — General specification  
          |  
          v  
L2 — Functional specification  
          |  
          v  
L3 — Architectural specification  
          |  
          v  
L4 — Detailed specification  
          |  
          v  
L5 — Test specification  
          |  
          v  
L6 — Implementation (source code)
```

Each level adds detail while remaining consistent with the levels above it.

### 7.2 Changes

A change to an element at one level may affect elements at lower levels.

The specification should make it possible to identify potentially affected elements through traceability relationships.

For example, a change to a functional requirement at L2 may require changes to architectural decisions at L3, detailed behaviour at L4, tests at L5, and implementation at L6.

A change to code does not automatically imply that the specification must change. The change may simply restore conformance with an existing specification.

Modifications have possibles states:

| State	|	Meaning	|
|	-	|	-	|
| RUNNING | When it is edited currently or not complete	|
| COMPLIANT	|	Compliant with higher-levels	|
| VIOLATION	|	Contradiction identified	|
| PENDING	|	Change awaiting validation	|
| WAIVED	|	Exception explicitly accepted by a human	|
| DEPRECATED	|	Element kept for traceability but no longer part of the specification; removal requires explicit human authorisation	|

A state is recorded in the `status` metadata of a document or in the marker of a code location (section 7.3). `RUNNING` is transient: an element shall not be left `RUNNING` at the end of a task.


### 7.3 Violation and waiver markers

When a lower-level element contradicts a higher-level rule (status VIOLATION), or deviates from it with human approval (status WAIVED), a comment marker shall appear immediately above the smallest offending element (function, block, requirement, scenario). The marker uses the comment syntax of the host file (`#`, `//`, `--`, `<!-- -->`, ...) and shall not alter the behaviour or validity of the file.

Fields, in this order:

* Rule: the stable identifier and name of the higher-level rule offended (never a file path).
* Description: a short reminder of the rule.
* Violation: a short explanation of why it is offended.
* Comment: for WAIVED only, the human's justification for the exception.
* Status: VIOLATION or WAIVED.

There is one marker per rule per location.

Example, violation:
```
# OSF-VIOLATION:
#    Rule: L1-REQ-003 Data privacy
#    Description: All user data must remain private.
#    Violation: This specification allows public access.
#    Status: VIOLATION
```

Example, waiver:
```
# OSF-WAIVED:
#    Rule: L1-REQ-003 Data privacy
#    Description: All user data must remain private.
#    Violation: Public access is allowed on the demo instance.
#    Comment: Accepted by the project owner for the demo only.
#    Status: WAIVED
```

A marker shall never be removed or softened silently. A violation is resolved only by:

1. modifying the lower-level element to restore compliance;
2. changing the higher-level specification through the review process (section 7.2, then 7.4); or
3. an explicit human waiver, which turns the marker into `OSF-WAIVED`. An agent shall not waive on its own initiative.

A waived marker remains as documentation and is re-evaluated when the rule it deviates from changes. At the end of a task, an agent shall report to the user every violation that is new, still open, resolved or waived.

### 7.4 Change workflows

Two directions of change are distinguished (see Unidirectional Refinement, section 3).

**Top-down (a request to add, change or remove behaviour, or to start a project).**

1. Analyse the impact: find the highest level the request affects, the elements that refine or depend on it, and any higher-level element it contradicts.
2. Update that highest level first, and only the authoritative definition. The request is the approval for the higher-level change it implies and nothing more; ambiguities and side effects are submitted to the human. These edits stay `PENDING` for human review (C-010).
3. Propagate level by level (L2, L3, L4, L5, L6), checking each against the level above. If a lower level cannot comply, stop and ask instead of changing the higher level.
4. Write or update tests before the code, implement in **every** configured target that covers the affected area, and run each target's tests.

For a new project, the same order applies from an empty L1: the general specification is confirmed by the human before lower levels are derived.

**Bottom-up (an edit of code, tests or detailed specifications).**

1. Map each change to the specification elements it implements or verifies.
2. Classify it: conformance (no specification change), refinement (detail left open by the higher level, recorded at the lowest level that owns it), contradiction, or unspecified behaviour (not assumed to be intended).
3. Update the levels the change owns, and check it against all applicable higher levels. With several targets, a change that alters behaviour specified at L2 to L4 is a top-down change (the other targets must follow); a change that stays within what the specification leaves open, or within one platform, does not touch the others.
4. On contradiction, restore compliance if possible. Otherwise insert a marker (section 7.3). The higher-level specification is never modified implicitly; a desirable lower-level behaviour is proposed as a top-down change.

**Audit.** On request or before a release, a read-only check verifies structure, metadata, top-down and bottom-up consistency, single source of truth, traceability, test coverage, implementation compliance of each target, agreement between targets, configuration (section 4.5) against L1, markers and statuses awaiting a human. Findings are reported by severity.

**External check.** On request, or after updates, a read-only comparison verifies the specifications against a document stored outside the specification tree (for example a customer PRD or a published design document). Each statement of the external document is placed at the level that owns it (section 3.7) and classified as covered, partial, missing, contradicted or ambiguous; specification elements not mentioned externally are listed too. The external document is either upstream (the specifications must satisfy it) or downstream (it must reflect the specifications). Differences are decided by a human and resolved through the top-down workflow or by updating the external document; neither is modified implicitly.

**Reverse engineering** follows section 8.1.

The reference agent skills implementing these workflows are in `agents/` (`osf`, `osf-new-project`, `osf-change`, `osf-sync-up`, `osf-violations`, `osf-audit`, `osf-check-external`, `osf-reverse`). The method is authoritative if they differ.



## 8. AI-assisted use

The method is intended to be usable by AI agents as well as human contributors.

AI agents may be used to:

- derive lower-level specifications from higher-level ones;

- analyse existing code and propose a reverse-engineered specification;

- identify missing information and inconsistencies;

- propose changes and identify potentially affected elements;

- generate or modify implementation code from approved specifications;

- propose verification criteria and tests.

AI-generated content must remain reviewable. Its origin does not establish its correctness.

When reverse-engineering an existing implementation, the resulting documents should distinguish:

- behaviour directly observed in the implementation;

- intended or required behaviour established by requirements;

- assumptions or interpretations that still need confirmation.

A bug or accidental behaviour discovered in the code must not silently become an approved requirement.


### 8.1 Reverse-engineering rules

When a specification is derived from an implementation:

1. Each requirement shall carry an origin: `DOCUMENTED` (stated in user-facing documentation and confirmed in the implementation), `OBSERVED` (read from the implementation or its tests), or `ASSUMPTION` (an interpretation awaiting human confirmation).

2. Anomalies, contradictions between documentation and behaviour, and probable bugs shall be recorded in a findings register (one document, stable identifiers, each with evidence, the place where the specification handles it, and a decision status such as `OPEN`). They shall not be turned into requirements until a human decides.

3. Where an anomalous behaviour is described to make the specification complete, it shall be described as the current behaviour and reference its finding.

4. Whenever an implementation can be run, outputs required by C-014 should be captured from it rather than written from reading the code.

5. Existing tests are used as verification references and as examples. Behaviours not covered by tests are marked as such.

6. The document metadata shall state that the specification is reverse-engineered and has not been approved (C-010).

### 8.2 Completeness check

A specification is complete enough when an independent implementer, given only L1 to L4, can produce an implementation that passes the tests specified at L5. Failures of such an attempt identify missing information and shall be recorded as findings or specification corrections.

## 9. Verification and conformance

Specifications should be verifiable whenever practical.

A specification element may reference one or more verification activities, such as:

- review;

- analysis;

- simulation;

- test;

- formal verification.

Tests and verification artefacts should be traceable to the specification elements they check.

The general conformance principle is:

> The implementation at L6 shall conform to the applicable approved specifications at L1 to L5.

A test specified at L5 shall be traceable to the L2 to L4 elements it verifies, and passing it is evidence of conformance to them.

The precise conformance model, including how to handle implementation details that are intentionally left open by the specification, remains to be defined.


## 10. Use cases

### 1. For Humans

With these software definitions, we believe that humans can navigate the software from a high-level overview down to the details that matter to them.

They can start by reading the first level to understand the software's overall purpose and functionality. They can then progressively explore lower levels to understand specific components or areas they want to analyze.

Furthermore, a human can modify a component at any level. With the help of an LLM, we can imagine automatically updating or removing all corresponding sub-levels to maintain consistency throughout the hierarchy. If necessary, the AI agent can ask the human to make decisions or clarify certain points.

Instead of having to review all the low-level source code, a human could therefore focus primarily on reviewing the intermediate specifications affected by the changes.

### 2. For Artificial Intelligence

This framework helps AI structure its software development process. It encourages AI agents to think progressively, moving from the big picture down to the smallest implementation details.

It also explicitly defines the boundaries and scope of changes, helping prevent unintended modifications to unrelated parts of the software.

Furthermore, this hierarchical approach could reduce token consumption and memory requirements. When starting a new project or working on an existing one, an AI agent could initially load only the high-level specifications, progressively retrieving lower-level details when needed. This allows it to retain the essential concepts without having to process the entire codebase at once.

### 3. For Safety and Resilience

This framework could also be considered a safety and resilience mechanism against data loss or obsolecence.

For example, if the source code (L6) is lost, it could potentially be regenerated from the higher-level specifications (L1–L5). Conversely, if the specifications are lost but the source code remains available, they could potentially be reconstructed through reverse engineering.

Usually, source code is considered the primary asset of a software project. Now the specifications, particularly the higher-level ones, could become the project's most valuable long-term asset. It will be easier to change language or OS just changing one spec with garantee not losing functionnalities.

## 11. Status of this draft

This document records the principles and structural decisions discussed so far. It is a working draft, not a published or complete standard.

The following topics remain open for discussion and specification:

1. **Refinement and alternatives:** whether a lower level may present several alternative solutions, and how one is selected and approved.

2. **Approval workflow:** exact status values and the conditions for moving an element from draft to approved.

3. **Identifier syntax:** namespaces, uniqueness scope, and identifier lifecycle.

4. **Relationship vocabulary:** the complete set of traceability and refinement relationships.

5. **Change propagation:** rules for impact analysis and synchronisation between levels.

6. **Versioning:** how specification versions relate to software releases and source-control history.

7. **Conformance:** how to assess whether implementation conforms to specifications, especially where the specification leaves implementation choices open.

8. **Formal notation:** when to use UML, pseudocode, contracts, OCL, or other formal methods.

9. **Machine-readable schema:** whether to define a JSON or YAML schema in addition to Markdown.

10. **Granularity:** guidance for deciding when an element should become a separate document or subdirectory.

These topics should be resolved before treating the method as stable.

