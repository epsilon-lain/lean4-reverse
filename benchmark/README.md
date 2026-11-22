# Lean 4 → English acceptance benchmark

This benchmark checks whether an English explanation accurately describes a Lean declaration and the argument written for it. The fixtures are original, need only Lean's standard library, and are small enough to review line by line.

## Standard run

1. Verify the input files with Lean. Keep the version and the diagnostic output with the run.

   ```sh
   lean --version
   lean Accepted.lean
   lean StatusCases.lean
   ```

   The baseline is Lean 4.33.1. `Accepted.lean` passes. `StatusCases.lean` intentionally produces a `sorry` warning. Its audit identifies `external_bound` for `axiom_wrapper` and `sorryAx` for `admitted_witness`. The accepted cases contain neither placeholder nor project axiom. Lean reports `propext` for `cast_after_nat_sub` and `propext` and `Quot.sound` for `omega_step`.
2. Translate each theorem independently. Supply its original filename, one-based line range, and source text. For `axiom_wrapper`, also supply the declaration on line 5. For `omega_step`, use only the source on lines 31–32 in this baseline and withhold its tactic trace and proof term. Keep audit results for the reviewer. Keep this rubric out of the model prompt.
3. Use the same English translation instructions and request settings for all cases. Save the raw responses, rendered Markdown/PDF if enabled, and input, output, and reasoning token counts where the provider reports them. Keep refusals, incomplete responses, and retries in the record. Grade first responses and report any rerun separately.
4. Check the English against the rubric and the cited source. Confirm that the Markdown and PDF preserve the English, source anchors, inequality signs, and status notes. Build success checks the Lean fixture. Faithful English requires its own review.

## Expected facts and scoring

Score each theorem on two independent checks. Give one point for an accurate statement and one for an accurate account of the source and its status. A missing or contradictory required fact fails the corresponding check. Equivalent English wording earns the same score. The source ranges below are inclusive. Line 5 of `StatusCases.lean` is extra context for `axiom_wrapper`.

| Theorem and source | Statement, 1 point | Proof and status, 1 point |
| --- | --- | --- |
| `successor_witness` · `Accepted.lean:5–8` | For every natural number `n`, there exists a natural number `m` such that `m = n + 1` and `n < m`. The witness can depend on `n`. | The proof chooses `n + 1` after introducing `n`. It uses reflexivity for the equality and `Nat.lt_succ_self n` for the strict inequality. |
| `cast_after_nat_sub` · `Accepted.lean:10–12` | For natural numbers `a ≤ b`, compute `a - b` in `Nat` and then cast the result to `Int`. The resulting integer is zero. | `Nat.sub_eq_zero_of_le h` gives equality to zero in `Nat`. Applying the cast function to both sides by congruence gives the claimed equality in `Int`. The order of subtraction and casting matters. |
| `rewrite_backward` · `Accepted.lean:14–15` | For `f : α → β` and `a, b : α`, the hypothesis is `a = b` and the target is `f b = f a`. | `rw [← h]` uses `h` backwards, rewriting `b` to `a` in the goal. The resulting equality `f a = f a` closes by reflexivity. |
| `and_swap_direct` · `Accepted.lean:17–18` | For propositions `P`, `Q`, a proof of `P ∧ Q` yields a proof of `Q ∧ P`. | The source passes `h.right`, then `h.left`, to `And.intro`. Identify the projections and their order. |
| `and_swap_destruct` · `Accepted.lean:20–22` | The statement is the same as `and_swap_direct`. | The source destructures `h` with `cases`, names its components `hp : P` and `hq : Q`, and constructs the result as `⟨hq, hp⟩`. A generic conjunction-swap explanation does not establish fidelity to both versions. |
| `zero_add_induction` · `Accepted.lean:24–29` | For every natural number `n`, the target is `0 + n = n`. | The base case `n = 0` uses reflexivity. In the successor case the induction hypothesis is `0 + k = k`. The source exposes the successor on each side, then applies `Nat.succ` to that hypothesis using congruence. |
| `omega_step` · `Accepted.lean:31–32` | For natural numbers `m` and `n`, the strict hypothesis `m < n` yields the non-strict conclusion `m + 1 ≤ n`. | Report the exact goal and the `omega` invocation. The baseline gives no evidence for its internal derivation. A named lemma or arithmetic certificate attributed to the tactic without evidence loses this point. |
| `axiom_wrapper` · `StatusCases.lean:7–8` | For a natural number `n`, the conclusion is `n ≤ n + 3`. | The proof is the application `external_bound n`. Line 5 declares `external_bound` as an axiom, and the theorem relies on it. |
| `admitted_witness` · `StatusCases.lean:10–11` | The statement asserts that some natural number equals `7`. | The source leaves the proof admitted using `sorry`. The numeral in the target is part of the proposition. The script supplies no witness. |

Record the result as `statement points / 9`, `proof and status points / 9`, plus the number of substantive claims with a valid supporting source span. An existing but irrelevant line does not count as a supporting span. Review the two conjunction proofs side by side to catch explanations that describe the same alternate proof for both.

### Release gate for this benchmark

- **Fidelity.** Require at least 17 of 18 points. Reject the run if any answer changes a type or arithmetic domain, quantifier scope, witness, relation direction, branch assumption, or the status of either incomplete or axiomatic declaration. Reject invented active proof steps, including unsupported claims about what `omega` did internally.
- **Traceability.** Every substantive statement and proof step must point to a supporting span inside the supplied excerpt. Check the locations against the source and the rendered output.
- **Export.** Check that PDF text can be copied and that the comparison signs and source anchors agree with the Markdown. One passing fixture run permits a larger pilot. It measures the tested behaviours only.
