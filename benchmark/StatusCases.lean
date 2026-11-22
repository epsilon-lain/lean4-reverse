import Lean

namespace LeanReverseBenchmark

axiom external_bound (n : Nat) : n ≤ n + 3

theorem axiom_wrapper (n : Nat) : n ≤ n + 3 :=
  external_bound n

theorem admitted_witness : ∃ n : Nat, n = 7 := by
  sorry

#print axioms axiom_wrapper
#print axioms admitted_witness

end LeanReverseBenchmark
