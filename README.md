# Lean4 Reverse

**[Download the Riemann Hypothesis Lean 4 translation preview (PDF)](https://github.com/epsilon-lain/lean4-reverse/releases/download/rh-1of100-preview/riemann-lean-1of100-recovered-partial.pdf).** This AI-assisted English translation covers 1,886 of 2,065 batches in the planned 1% selection. Translation and formula errors may remain.

This bundle contains the task brief, English translation framework, first acceptance benchmark, and a runnable CLI prototype.

- `CODEX_TASK.md` gives Codex the implementation and pilot scope.
- `LEAN_TRANSLATION_FRAMEWORK.md` is the English translation contract loaded by the CLI.
- `benchmark/README.md` contains human scoring criteria. `benchmark/cases.json` records the exact source ranges. Keep the rubric outside live prompts.
- `implementation/README.md` gives instructions for offline replay and a live Luna call. The checked-in reference JSON is a hand-written fixture.

The benchmark has seven ordinary theorem cases and two proof-status cases. The fixtures were checked with Lean 4.33.1. A model run is a separate result and must be scored against the rubric.

## Attribution

The CLI incorporates code from [Protocol 17](https://github.com/epsilon-lain/Protocol-17). The upstream copyright and permission notice is in [LICENSES/Protocol-17-MIT.txt](LICENSES/Protocol-17-MIT.txt).
