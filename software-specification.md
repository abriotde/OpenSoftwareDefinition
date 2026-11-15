# OpenProduct Software Specification Method

## Working Draft — Version 0.1

**Status:** Working draft\
**Language:** English\
**Purpose:** Define a language-independent, hierarchical method for specifying software from high-level intent down to source-code implementation.

---

## 1. Purpose and motivation

Modern AI coding agents can produce large amounts of source code very quickly. This creates a review and maintenance problem: even when source code is publicly available, it may be impractical for humans to inspect and understand every implementation detail.

This method proposes making the software specification a first-class project artefact. Rather than relying on source code as the only authoritative description of a software system, the project maintains a structured specification that progressively refines the system from its general purpose to detailed behaviour and, finally, implementation.

The method is intended to support both:

- **Forward engineering:** deriving increasingly detailed specifications and implementation from high-level requirements.
- **Reverse engineering:** analysing an existing implementation and reconstructing a specification of its observed behaviour and structure.

A specification generated from existing code must not automatically be treated as a statement of intended behaviour. It must distinguish observed implementation behaviour from requirements and from assumptions.

## 2. Core principles

### C-001 — Language independence

Specifications at levels L1 to L4 shall describe the software independently of the programming language used for implementation, this only should be mentioned in L2.

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

The directory hierarchy shall be consistent across levels so that corresponding areas of the system can be found easily.

The hierarchy represents the logical decomposition of the software. It is not required to reproduce the source-code directory structure.

### C-007 — Flexible decomposition

The method shall support projects of very different sizes, from small applications to systems as large as the Linux kernel.

Each area may be subdivided into as many directories and documents as are useful.

A lower level may introduce a finer-grained decomposition while preserving its relationship to the parent area. The hierarchy therefore needs to be consistent, but not necessarily identical in depth at every level.

Every directory used to organise specifications shall contain an `index.md` file explaining the scope and organisation of that directory and, where applicable, its subdirectories.

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

The source-code implementation is the final level of the refinement chain.

The implementation may be written by humans, generated by AI agents, or produced through a combination of both.

The code shall conform to the applicable specifications at levels L1 to L4. A code change shall trigger a check that the relevant specifications remain accurate and consistent.

### C-011 — Used standars

* ISO/IEC/IEEE 29148 for Requirements engineering
* ISO/IEC/IEEE 42010 for Architecture description
* UML 2.5 for Architecture modelling in PlantUML preferred, XMI overwise.
* YAML for metadata definitions
* Object Constraint Language (OCL) for formal constraints
* Markdown for defaults documentation format.

---

## 3. Specification levels

The method defines five levels.

| Level | Name | Purpose |
| --- | --- | --- |
| L1 | General specification | Describe the system, its purpose, scope, context, main capabilities, constraints, and implementation environment. |
| L2 | Functional specification | Describe the functions and externally observable behaviours the system must provide. |
| L3 | Architectural specification | Describe the system's major components, responsibilities, boundaries, and interactions. |
| L4 | Detailed specification | Describe detailed behaviour, interfaces, data, algorithms, rules, error cases, and other implementation-independent details. |
| L5 | Implementation | Provide the actual source code and other implementation artefacts. |

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

L4 : Markdown + pseudocode + contrats
It can use Object Constraint Language (OCL) when applicable.

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

L4 should provide enough information for an implementer to understand the required behaviour without having to infer essential rules from the source code.

### 3.5 L5 — Implementation

L5 is the actual implementation, including source code and relevant implementation artefacts.

The implementation language and technologies are identified in L1. L5 contains the code itself; it is not another prose specification level.

---

## 4. Directory organisation

### 4.1 General layout

A project shall have one directory for each specification level. Each level shall contain an `index.md` at its root.

A typical layout is:

```
root/
├── L1-general/
│   ├── index.md
│   ├── core/
│   │   └── index.md
│   ├── drivers/
│   │   └── index.md
│   ├── filesystem/
│   │   └── index.md
│   └── networking/
│       └── index.md
│
├── L2-functional/
│   ├── index.md
│   ├── core/
│   │   └── index.md
│   ├── drivers/
│   │   └── index.md
│   ├── filesystem/
│   │   └── index.md
│   └── networking/
│       └── index.md
│
├── L3-architectural/
│   ├── index.md
│   ├── core/
│   │   └── index.md
│   ├── drivers/
│   │   └── index.md
│   ├── filesystem/
│   │   └── index.md
│   └── networking/
│       └── index.md
│
├── L4-detailed/
│   ├── index.md
│   ├── core/
│   │   └── index.md
│   ├── drivers/
│   │   └── index.md
│   ├── filesystem/
│   │   └── index.md
│   └── networking/
│       └── index.md
│
└── L5-code/
```

This is an illustrative layout, not a mandatory list of directories.

### 4.2 Index files

Every directory used to organise specification content shall contain an `index.md`.

The index shall explain, as appropriate:

- the scope of the directory;
- the concepts or responsibilities covered;
- the documents and subdirectories it contains;
- how its content relates to the parent area;
- relevant links to corresponding areas at other levels.

An index is an orientation and organisation document. It should not duplicate detailed definitions that belong in other specification documents.

### 4.3 Consistency across levels

The directory hierarchy shall preserve recognisable logical areas across levels.

For example, a `networking` area introduced at L1 should remain identifiable at L2, L3, and L4.

A lower level may split that area into more specific subdirectories. For example:

```
L1-general/networking/
L2-functional/networking/
L3-architectural/networking/
L4-detailed/networking/
    ├── ipv4/
    ├── ipv6/
    └── routing/
```

The hierarchy is a navigational and conceptual structure. It does not require a one-to-one correspondence between directories at every level.

### 4.4 Independence from source layout

The specification hierarchy shall describe the logical system, not merely mirror the source-code tree.

This distinction is important for large projects. For example, the logical specification of a subsystem may span several source directories, or a source directory may contain code belonging to several logical concerns.

---

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

---

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

# FUNC-001 — Calculate total power

## Purpose

## Description

## Inputs

## Outputs

## Preconditions

## Postconditions

## Invariants

## Behavior

## Error handling

## Dependencies

## Constraints

## Verification

## References
```

### 6.1 Empty, omitted, and not-applicable sections

These cases have distinct meanings:

| Representation | Meaning |
| --- | --- |
| Section omitted | The section is not included in this document. |
| Section present but empty | The section is recognised, but its content has not yet been specified. |
| `Not applicable` | The section has been considered and does not apply to this element. |
| `None` | The section applies, and it has been determined that there are no items to list. |

Projects and tools should preserve these distinctions.

### 6.2 Document metadata

The example metadata includes an identifier, name, level, and status.

The precise metadata schema, mandatory fields, allowed status values, and validation rules have not yet been finalised.

---

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
L5 — Implementation (source code)
```

Each level adds detail while remaining consistent with the levels above it.

### 7.2 Changes

A change to an element at one level may affect elements at lower levels.

The specification should make it possible to identify potentially affected elements through traceability relationships.

For example, a change to a functional requirement at L2 may require changes to architectural decisions at L3, detailed behaviour at L4, and implementation at L5.

A change to code does not automatically imply that the specification must change. The change may simply restore conformance with an existing specification.

### 7.3 Types of change

At least three situations must be distinguished:

1. **Implementation correction:** code is changed to conform to an unchanged specification.
2. **Behavioural change:** the intended behaviour changes, requiring the relevant specification levels to be reviewed and updated.
3. **Specification correction:** the specification itself is found to be incorrect or incomplete and must be corrected.

The detailed change-management procedure remains to be defined.

---

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

---

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

> The implementation at L5 shall conform to the applicable approved specifications at L1 to L4.

The precise conformance model, including how to handle implementation details that are intentionally left open by the specification, remains to be defined.

---

## 10. Perspectives

With this software definitions, we think, a human could read the first level to understand the general use of the software, and then he can goes down to understand the next level wich is important for him and in this level the part he want to analyze.
Then, he even can modify a part at the level he want, and with LLM, we can imagine it update/delete all the correspondant sub-levels. If needed, the AI agent can ask some choice to do. Then instead to read all the low level code, maybe it can just read the middle specifications it changes.


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

