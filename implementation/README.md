# lean4-reverse CLI

Translate one Lean 4 declaration into English using the translation framework in the parent directory. The CLI keeps original source spans and hashes the original source file. It exports editable Markdown, structured JSON, and a searchable PDF.

## Offline example

Run from the root of this bundle with Python 3.10 or later.

```sh
python implementation/lean_reverse.py benchmark/Accepted.lean --lines 5:8 \
  --from-json implementation/witness-reference.json \
  --output-json proof.json --markdown proof.md
```

Add `--pdf proof.pdf` for PDF. Install Pandoc, WeasyPrint, and DejaVu fonts. Keep output paths in an existing directory.

## One live benchmark case

Set `OPENAI_API_KEY` in the environment. This command sends the selected Lean excerpt and the English framework to the Responses API. It uses `gpt-6-luna` at low reasoning effort with up to 4,096 output tokens by default. Adjust these parameters before freezing settings for the benchmark.

```sh
python implementation/lean_reverse.py benchmark/StatusCases.lean --lines 7:8 \
  --context-lines 5:5 --raw-response raw.json --output-json proof.json \
  --markdown proof.md --pdf proof.pdf
```

`--context-lines` can be repeated for other declarations in the same file. Supply saved Lean goal or check evidence with `--trace` when your benchmark calls for it. For the source-only baseline, follow [`benchmark/README.md`](../benchmark/README.md).

The JSON report includes token usage reported by OpenAI and the supplied source ranges. A saved report can be imported again using the same source file, range, and context. The CLI validates JSON and span bounds. Run Lean separately and grade English fidelity against the original source.
