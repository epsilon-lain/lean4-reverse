# Lean 4 to English translation framework

Translate one selected Lean declaration into readable mathematical English. Preserve the types, assumptions, conclusion, and argument used by the source. Combine routine steps when the resulting sentence still describes the same inference. Give every substantive claim a source location.

## 1. Read the source in three passes

1. **Read the declaration.** Identify its kind, name, parameters, type, statement or definition body, and relevant imports. Resolve notation, coercions, and implicit arguments when they affect the mathematics. Keep the fully qualified name for any library fact that carries a substantive inference.
2. **Read the argument.** In a term proof, follow the function applications, witnesses, and constructors. In a tactic proof, follow the local hypotheses and goals across each relevant tactic. Track each branch separately. Record what changes and what evidence supports the change.
3. **Write the English.** Start with the objects, assumptions, and conclusion. Explain the proof in its dependency order. Keep the witnesses, case conditions, induction hypotheses, and crucial lemmas. Put mechanics that need more evidence under **Open details**.

The minimum input is the selected declaration with source line numbers. Useful additions include the Lean and Mathlib versions, resolved declaration types, definitions of imported symbols, proof states before and after tactics, and a recorded Lean or axiom check. Each kind of evidence supports a different claim. For example, a tactic trace can show that a goal disappeared. A proof term or rewrite trace can show which inference closed it.

## 2. Describe the objects and the statement

| Lean form | English template and what to preserve |
| --- | --- |
| `import`, `namespace`, `open`, `section` | “This declaration uses [library or qualified name].” Report the setup where it determines the meaning of a symbol, a theorem name, or an inherited parameter. |
| `variable`, explicit parameters, `{…}`, `[…]`, dependent types | “Let [object] be of type [type]. Assume [structure or property].” Introduce objects in dependency order. Retain an implicit parameter or typeclass assumption if it affects the theorem. |
| `def`, `abbrev`, a local `let` | “Define [name] by [expression].” For a function, state its input and result types and then its rule. For a local name, say “Write [name] for [expression].” |
| `opaque` or a constant whose implementation is unavailable | “The declaration provides [name] of type [type]. Its implementation is outside the available evidence.” Describe the implementation when the source or proof evidence exposes it and it matters. |
| `structure`, `class`, `instance` | “A [name] consists of [data] satisfying [properties].” An instance can be phrased as “Equip [type] with [structure], using [operations or proof].” Retain field dependencies and laws. |
| `inductive`, constructors, `match` | “An element is built by one of the following constructors.” List the constructor inputs that affect the reasoning. For indexed families, state which index each constructor produces. For `match`, give the actual rule in each branch. |
| Recursive definition, recursive call | “In the base case, [value]. In the recursive case, compute [value] from [recursive call].” Record the decreasing argument or measure when established and relevant. |
| `theorem`, `lemma`, `example`, `axiom` | “Assume [hypotheses]. Then [conclusion].” If the declaration is an axiom, say “Assume [proposition] as an axiom.” Account for the actual declaration kind and its proof status. |
| `∀`, `∃`, `∃!`, implication, equivalence | “For every…”, “There exists…”, “There exists a unique…”, “If… then…”, and “if and only if.” Preserve order and scope. In particular, translate `∀ x, ∃ y` as “For every x there exists a y.” |
| Equality, inequality, membership, and set operations | Use the relation that the code states. Preserve strictness, negation, the order of operands, endpoint inclusion, and all side conditions. |
| Arithmetic, casts, and overloaded notation | “View [term] as an element of [target type]” for a mathematically relevant cast. Identify the actual operation from the operand types and the elaborated expression. For example, subtraction on `Nat` truncates at zero. |
| Tuples, projections, function application, `if` | “Take the [field] of [object]”, “Evaluate [function] at [argument]”, or “If [condition], use [first branch]. Otherwise, use [second branch].” Follow product order, parameter order, and the scope of branch hypotheses. |

## 3. Describe how the proof proceeds

| Evidence in Lean | English template and the evidence it needs |
| --- | --- |
| Proof term such as `L h₁ h₂`, or `exact`, `apply` | “Apply [named lemma] to [premises] to obtain [conclusion].” If the application leaves goals, continue with “It remains to show [actual goals].” |
| `intro`, a function abstraction, `specialize` | “Let [object] be arbitrary”, “Assume [hypothesis]”, or “Specialize [statement] at [argument].” Choose the form from the binder type or goal. |
| `have`, `suffices`, `show`, `refine` | “First establish [intermediate claim]”, “It suffices to prove [claim]”, or “Use [partial construction]. It remains to establish [goals].” Preserve the role of each intermediate statement. |
| `exists` or `use`, existential proof terms, witness extraction | “Take [term] as a witness and show [property].” For extraction, say “Choose [witness] with [property] by [existing hypothesis or theorem].” Keep witness construction and witness extraction distinct. |
| `constructor`, `⟨…⟩`, projections, `left`, `right` | “Prove both components”, “Prove the two directions”, “Take the [specified] disjunct”, or “Use [fields] to construct [object].” Select the template using the target type and the actual constructor. |
| `rw`, `rewrite`, `calc`, `subst` | “Rewrite [expression] using [equality] in [direction]”, “Combine the following relations”, or “Substitute [term] for [variable] using [equality].” State the side or occurrence if it affects the proof. |
| `rfl`, a definitional conversion, `change` | “Both sides reduce to [term]” when that reduction is known. Otherwise, identify the verified reflexivity step. For `change`, say “Express the same goal as [new goal]” when the conversion is established. |
| `cases`, `rcases`, `by_cases`, `split` | “Separate into [cases]” or “Unpack [hypothesis] into [components].” State each actual branch condition or constructor and which facts are local to that branch. |
| `induction`, a recursor | “Proceed by induction on [object]. In the base case, [argument]. In the step, assume [induction hypothesis] and show [step goal].” Include generalized parameters when the induction hypothesis depends on them. |
| Contradiction, `exfalso`, `by_contra`, an impossible constructor case | “Under [actual assumptions], derive a contradiction from [facts].” For proof by contradiction, record the exact assumption introduced by Lean. |
| `simp`, `simp only`, `simp?`, `norm_num`, `ring`, `omega`, `linarith`, `aesop`, `decide` | “Lean [simplifies or closes] [specific goal] using `[tactic]`.” Describe the observed input and outcome. Name a specific rewrite or arithmetic certificate only when the source, trace, or proof term establishes its use. A lemma listed as available to `simp` may simply remain available. |
| `;`, `<;>`, `first`, `try`, `repeat`, `all_goals`, or a custom tactic | Describe the branches and transitions from the observed result. For alternatives or repetition, treat the script as potential actions until a trace identifies the actions actually taken. |

## 4. Handle missing evidence and verification

| Situation | What to write |
| --- | --- |
| A new or unfamiliar surface form | Inspect its elaborated term, resolved declaration, or before-and-after proof state. Translate what that evidence establishes. If none is available, quote the smallest relevant span and identify the precise open detail. |
| An imported theorem is called and its declaration is available | State the relevant part of the theorem, show how the current arguments match it, and cite its qualified name and source location. Expand its proof only when the input includes evidence for that proof. |
| An imported theorem, cast, or notation is unresolved | Preserve the identifier or expression. State what information is missing, such as a definition, type, body, or coercion. |
| A script shows automation and there is no trace or checked result | Where the goal can be read, say “The source invokes [tactic] on [goal]. Its result and internal proof are unverified in the supplied material.” |
| A trace shows the goal was solved | Report that recorded result. Keep the internal inference open when the trace only contains goal states. |
| `sorry`, `admit`, a failed check, or an unfinished proof | State the affected goal and where the evidence ends. Keep the original theorem statement visible and mark its verification status separately. |
| Lean compiled the file, or an axiom audit was supplied | Report the recorded toolchain and outcome. For an axiom audit, report the listed dependencies. Use separate language for the formal check and for review of the English translation. |

This fallback is part of the translation framework. Lean can grow new notation, macros, and tactics. Their surface forms can be handled through the same rule of following the available evidence and recording what remains unresolved.

## 5. Request this output from the model

> Translate the selected Lean 4 declaration into concise English using the supplied source and evidence. Include **Declaration**, **Objects and assumptions**, **Statement or definition**, **Proof or computation**, and **Open details** where applicable. Use ordinary mathematical English, with Lean identifiers in backticks when they help the reader find the relevant evidence. Attach a source span to every substantive definition, assumption, or proof step. Keep each proof branch under its own assumptions. Distinguish a term written in the source, an inference confirmed by a trace, and an unresolved mechanism. Preserve all conditions, types, quantifier scopes, and the direction of relations.

Use `file:start–end` for a source span when a filename is available, or `lines start–end` for a single pasted excerpt. Summarize routine operations together when the combined sentence remains checkable. Keep enough detail for a reader to compare the English with the original proof.

### Worked example

```lean
theorem nat_add_le (a b c d : Nat) (hab : a ≤ b) (hcd : c ≤ d) :
    a + c ≤ b + d := by
  have left : a + c ≤ b + c := Nat.add_le_add_right hab c
  have right : b + c ≤ b + d := by omega
  exact Nat.le_trans left right
```

**Statement.** Let `a`, `b`, `c`, and `d` be natural numbers. If `a ≤ b` and `c ≤ d`, then `a + c ≤ b + d`. [Lines 1–2]

**Proof.** Adding `c` to both sides of `a ≤ b` gives `a + c ≤ b + c` by `Nat.add_le_add_right`. [Line 3] The source invokes `omega` on the goal `b + c ≤ b + d`. [Line 4] The last line combines the two intermediate inequalities using `Nat.le_trans`. [Line 5]

**Open details.** This excerpt omits the trace and proof term for `omega`. Its internal arithmetic derivation is therefore outside the translation. A check log can separately record whether Lean accepted the whole file.

**Review.** Compare the objects, hypotheses, and goal against the declaration. Then check witnesses, branch scope, lemma arguments, inequality directions, and references against the proof. Mark each unresolved imported definition or automated inference where it matters to the explanation.

## References

- [Lean Language Reference: Tactic Proofs](https://lean-lang.org/doc/reference/latest/Tactic-Proofs/)
- [Lean Language Reference: Simplification vs Rewriting](https://lean-lang.org/doc/reference/latest/The-Simplifier/Simplification-vs-Rewriting/)
- [Lean Language Reference: Coercion Insertion](https://lean-lang.org/doc/reference/latest/Coercions/Coercion-Insertion/)
- [Lean Language Reference: Axioms](https://lean-lang.org/doc/reference/latest/Axioms/)
