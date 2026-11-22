import Lean

namespace LeanReverseBenchmark

theorem successor_witness : ∀ n : Nat, ∃ m : Nat, m = n + 1 ∧ n < m := by
  intro n
  refine ⟨n + 1, rfl, ?_⟩
  exact Nat.lt_succ_self n

theorem cast_after_nat_sub (a b : Nat) (h : a ≤ b) : ((a - b : Nat) : Int) = 0 := by
  have hzero : a - b = 0 := Nat.sub_eq_zero_of_le h
  exact congrArg (fun n : Nat => (n : Int)) hzero

theorem rewrite_backward (α β : Type) (f : α → β) (a b : α) (h : a = b) : f b = f a := by
  rw [← h]

theorem and_swap_direct (P Q : Prop) (h : P ∧ Q) : Q ∧ P :=
  And.intro h.right h.left

theorem and_swap_destruct (P Q : Prop) (h : P ∧ Q) : Q ∧ P := by
  cases h with
  | intro hp hq => exact ⟨hq, hp⟩

theorem zero_add_induction (n : Nat) : 0 + n = n := by
  induction n with
  | zero => rfl
  | succ k ih =>
    change Nat.succ (0 + k) = Nat.succ k
    exact congrArg Nat.succ ih

theorem omega_step (m n : Nat) (h : m < n) : m + 1 ≤ n := by
  omega

#print axioms successor_witness
#print axioms cast_after_nat_sub
#print axioms rewrite_backward
#print axioms and_swap_direct
#print axioms and_swap_destruct
#print axioms zero_add_induction
#print axioms omega_step

end LeanReverseBenchmark
