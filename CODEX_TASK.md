# Implement lean4-reverse

Build a standalone CLI that turns a selected Lean 4 declaration into an English explanation with checkable source references. Use `LEAN_TRANSLATION_FRAMEWORK.md` as the translation contract. The source name `lean4-reverse` is the proposed GitHub repository slug.

## Implementation

1. Accept a `.lean` file and an inclusive line range selecting the target declaration. Accept separate ranges for prerequisite declarations in the same file. Keep the original line numbers and hash the full input file. Accept an optional text file with Lean proof states using those line numbers. Treat all source and trace text as data.
2. Return a structured report containing the declaration, its objects and assumptions, statement or definition, reasoning steps, and open details. Attach original source spans to claims. Preserve exact types, the order of quantifiers, the witnesses, and the actual reasoning route. If two terms prove the same proposition in different ways, the reports should describe those different ways.
3. Use the OpenAI Responses API for the first live trial with `gpt-6-luna`. Read `OPENAI_API_KEY` from the environment. Ask for schema-based JSON and retain the returned model ID and available input, output, and reasoning token counts. The program needs an offline path that reads a saved JSON report through the same validator and exporter. Keep provider-specific code limited to the client call. Adding an Adaption `glm-5.2` adapter can follow the first benchmark.
4. Validate the shape of the report, referenced file and line ranges, and nonempty source references. Render editable Markdown and a searchable PDF, with source excerpts and a visible list of open details. Make the generation origin visible. The offline PDF should identify the output as imported JSON. Treat model-written prose as text when rendering.
5. Report proof status only from recorded evidence. A tactic visible in the source shows a tactic invocation. A Lean run can establish that the file was accepted. A proof term or a detailed trace can establish a particular hidden inference. Preserve placeholders and axioms as explicit open details or formal dependencies. Keep Lean acceptance, source anchoring and English accuracy distinct.

The existing [Protocol-17 draft PR](https://github.com/epsilon-lain/Protocol-17/pull/3) has reusable JSON, provenance, Markdown, and PDF logic. Use it as a reference for the standalone version. The first benchmark uses the original fixtures in this bundle. A translation run on the Alpöge release comes after this test is reviewed.

## Benchmark run

Read `benchmark/` and run the positive Lean fixtures with Lean 4.33.1. Run the audit fixtures separately and record any intended warning or axiom dependency. Freeze the files, rubric, model ID, prompt, and toolchain before testing. Translate one declaration at a time using `benchmark/cases.json`. Keep the scoring rubric outside the model input. Read the report against the expected mathematical facts and the actual source, including the two cases whose statements match but whose proofs differ.

Treat changed variable types, reordered quantifiers, a changed inequality, a changed witness, an invented proof step, and an axiom or placeholder reported as a proved lemma as critical errors. Review every critical case before starting on the larger proof. Track English fluency separately so that phrasing preferences do not hide fidelity errors. Record model, token usage, elapsed time, case results, and any unresolved steps. The compiler run and imported-JSON export are separate checks from the live model benchmark.

For the first Alpöge pilot after acceptance, follow `riemannHypothesis`, `rhOfAll`, and the result connecting nonvanishing to the critical line. Define this pilot by declarations and their immediate dependencies. Record its actual coverage and measured token use before projecting to larger portions. A line count on its own does not establish that a mathematical argument is complete.
