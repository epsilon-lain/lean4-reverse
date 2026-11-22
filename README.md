# Lean4 Reverse

This bundle contains the task brief, English translation framework, first acceptance benchmark, and a runnable CLI prototype.

- `CODEX_TASK.md` gives Codex the implementation and pilot scope.
- `LEAN_TRANSLATION_FRAMEWORK.md` is the English translation contract loaded by the CLI.
- `benchmark/README.md` contains human scoring criteria. `benchmark/cases.json` records the exact source ranges. Keep the rubric outside live prompts.
- `implementation/README.md` gives instructions for offline replay and a live Luna call. The checked-in reference JSON is a hand-written fixture.

The benchmark has seven ordinary theorem cases and two proof-status cases. The fixtures were checked with Lean 4.33.1. A model run is a separate result and must be scored against the rubric.

## Attribution

The CLI incorporates code from [Protocol 17](https://github.com/epsilon-lain/Protocol-17). The upstream copyright and permission notice is in [LICENSES/Protocol-17-MIT.txt](LICENSES/Protocol-17-MIT.txt).
