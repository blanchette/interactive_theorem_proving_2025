/- Copyright © 2018–2025 Anne Baanen, Alexander Bentkamp, Jasmin Blanchette,
Xavier Généreux, Johannes Hölzl, and Jannis Limperg. See `LICENSE.txt`. -/

import LoVe.LoVe03_BackwardProofs_ExerciseSheet


/- # LoVe Homework 4 (10 points): Forward Proofs

Replace the placeholders (e.g., `:= sorry`) with your solutions. -/


set_option autoImplicit false
set_option tactic.hygienic false

namespace LoVe


/- ## Question 1 (4 points): Logic Puzzles

Consider the following tactical proof: -/

theorem about_Impl :
    ∀a b : Prop, ¬ a ∨ b → a → b :=
  by
    intros a b hor ha
    apply Or.elim hor
    { intro hna
      apply False.elim
      apply hna
      exact ha }
    { intro hb
      exact hb }

/- 1.1 (2 points). Prove the same theorem again, this time by providing a proof
term.

Hint: There is an easy way. -/

theorem about_Impl_term :
    ∀a b : Prop, ¬ a ∨ b → a → b :=
  fun (a b : Prop) (hor : ¬ a ∨ b) (ha : a) ↦
    Or.elim hor (fun hna : ¬ a ↦ False.elim (hna ha)) (fun hb : b ↦ hb)

/- There are in fact two easy ways:

* Copy-paste the result of `#print about_Impl`.

* Simply enter `about_Impl` as the proof term for `about_Impl_term`. -/

/- 1.2 (2 points). Prove the same theorem again, this time by providing a
structured proof, with `fix`, `assume`, and `show`. -/

theorem about_Impl_struct :
    ∀a b : Prop, ¬ a ∨ b → a → b :=
  fix a b : Prop
  assume hor : ¬ a ∨ b
  assume ha : a
  show b from
    Or.elim hor
      (assume hna : ¬ a
       show b from
         False.elim (hna ha))
      (assume hb : b
       show b from
         hb)


/- ## Question 2 (6 points): Connectives and Quantifiers

2.1 (3 points). Supply a structured proof of the commutativity of `∨` under a
`∀` quantifier, using no other theorems than the introduction and elimination
rules for `∀`, `∨`, and `↔`. -/

theorem Or_comm_under_All {α : Type} (p q : α → Prop) :
    (∀x, p x ∨ q x) ↔ (∀x, q x ∨ p x) :=
  Iff.intro
    (assume hall : ∀x, p x ∨ q x
     fix a : α
     show q a ∨ p a from
       Or.elim (hall a)
         (assume hp : p a
          Or.inr hp)
         (assume hq : q a
          Or.inl hq))
    (assume hall : ∀x, q x ∨ p x
     fix a : α
     show p a ∨ q a from
       Or.elim (hall a)
         (assume hq : q a
          Or.inr hq)
         (assume hp : p a
          Or.inl hp))

/- 2.2 (3 points). We have proved or stated three of the six possible
implications between `ExcludedMiddle`, `Peirce`, and `DoubleNegation` in the
exercise of lecture 3. Prove the three missing implications using structured
proofs, exploiting the three theorems we already have. -/

namespace BackwardProofs

#check Peirce_of_EM
#check DN_of_Peirce
#check SorryTheorems.EM_of_DN

theorem Peirce_of_DN :
    DoubleNegation → Peirce :=
  assume h : DoubleNegation
  show Peirce from
    Peirce_of_EM (SorryTheorems.EM_of_DN h)

theorem EM_of_Peirce :
    Peirce → ExcludedMiddle :=
  assume h : Peirce
  show ExcludedMiddle from
    SorryTheorems.EM_of_DN (DN_of_Peirce h)

theorem dn_of_em :
    ExcludedMiddle → DoubleNegation :=
  assume h : ExcludedMiddle
  show DoubleNegation from
    DN_of_Peirce (Peirce_of_EM h)

end BackwardProofs

end LoVe
