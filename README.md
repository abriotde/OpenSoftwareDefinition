# OpenSoftwareDefinition

The purpose of this is to define a language-independent, hierarchical method for specifying software from high-level intent down to source-code implementation.


## 1. Purpose and motivation

Modern AI coding agents can produce large amounts of source code very quickly. This creates a review and maintenance problem: even when source code is publicly available, it may be impractical for humans to inspect and understand every implementation detail.

This method proposes making the software specification a first-class project artefact. Rather than relying on source code as the only authoritative description of a software system, the project maintains a structured specification that progressively refines the system from its general purpose to detailed behaviour and, finally, implementation.

The method is intended to support both:

- **Forward engineering:** deriving increasingly detailed specifications and implementation from high-level requirements.
- **Reverse engineering:** analysing an existing implementation and reconstructing a specification of its observed behaviour and structure.

A specification generated from existing code must not automatically be treated as a statement of intended behaviour. It must distinguish observed implementation behaviour from requirements and from assumptions.

## 2. What we imagine

We imagine, software defined in 5 level, each level precise the previous, the last will be the source-code.
With this software definitions, a human can read the first level to understand the general use of the software, and then he can goes down to understand the next level wich is important for him and in this level the part he want to analyze.
The fact is, he even can modify a part at the level he want, and with LLM, we can imagine it update/delete all the correspondant sub-levels. If needed, the AI agent can ask some choice to do. Then instead to read all the low level code, maybe it can just read the middle specifications it changes.

