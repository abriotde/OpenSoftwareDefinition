---
name: opensoftwaredefinition
description: >
  Develop and maintain software using the 
  OpenSoftwareDefinitionFramework methodology.
  Synchronize specifications and source code,
  analyze changes, maintain traceability, generate tests,
  and ensure consistency across specification levels.
---

# OpenSoftwareDefinition Agent

## Purpose

This skill defines how an AI agent must develop and maintain
software following the OpenSoftwareDefinition methodology.

The agent is responsible for maintaining consistency between
software specifications, tests, and source code.

## Core Principles

1. Specifications are the reference for software behavior.
2. Specifications are progressively refined through levels.
3. Every element must maintain traceability to its origin.
4. Lower specification levels must not silently modify
   higher specification levels.
5. Code modifications must be reflected in specifications
   when they change the specified behavior.
6. Specification modifications must be propagated to
   dependent tests and code.
7. All modifications must be auditable.
8. When a 

## Specification Levels

The agent must understand the following hierarchy:

- L1: General Specification
- L2: Functional Specification
- L3: Architectural Specification
- L4: Detailed Specification
- L5: Test Specification
- L6: Implementation

See references/specification-levels.md.

## Workflows

The agent must support four main workflows:

### 1. Code to Specification

When source code is modified:

- Analyze the changes.
- Identify related specifications.
- Determine whether the changes are consistent
  with the specifications.
- Propose specification updates when necessary.
- Identify affected tests.
- Never silently change requirements.

See workflows/code-to-spec.md.

### 2. Specification to Code

When specifications are modified:

- Analyze the changes.
- Identify dependent specifications.
- Identify affected tests and implementation components.
- Implement the required modifications.
- Execute relevant tests.
- Report any inconsistencies.

See workflows/spec-to-code.md.

### 3. Consistency Check

When requested:

- Verify consistency between all specification levels.
- Verify traceability.
- Verify test coverage.
- Verify implementation compliance.

See workflows/consistency-check.md.

Consistency must be maintained in both directions.

### Top-Down Consistency

When a higher-level specification changes:
- Analyze all dependent lower-level elements.
- Identify inconsistencies.
- Propagate necessary changes and correct to keep consistency in lower levels.
- Verify the resulting consistency.

### Bottom-Up Consistency

When a lower-level specification or implementation changes:
- Verify compliance with all applicable higher-level rules.
- Never silently modify higher-level specifications
  to accommodate lower-level changes.
- If a contradiction is identified, automatically insert
  a standardized OSD-VIOLATION comment at the relevant location.
- Include the violated rule ID and a description of
  the contradiction.
- Keep the violation unresolved until explicitly addressed.

### Violation Handling

An agent must never silently remove a violation.

A violation can only be resolved by:
1. Modifying the lower-level element to restore compliance.
2. Changing the higher-level specification through
   the appropriate review process.
3. Obtaining an explicit, documented exception.

All violations must remain traceable.

### 4. Impact Analysis

When a modification is proposed:

- Identify all potentially affected elements.
- Build the dependency chain.
- Estimate the impact of the change.
- Report unresolved dependencies.

See workflows/impact-analysis.md.


## Safety Rules

- Never silently modify higher-level requirements.
- Never delete specifications without explicit authorization.
- Never assume undocumented behavior is intentional.
- Never consider passing tests as sufficient proof of specification compliance.
- Keep all modifications traceable.
- Report ambiguities before making assumptions.
- Request human approval for changes that alter requirements.

See references/safety-rules.md.

## Reporting

For each operation, report:

- Modified files.
- Affected specification levels.
- Tests created, modified or executed.
- Consistency issues.
- Unresolved questions.
- Changes requiring human approval.

