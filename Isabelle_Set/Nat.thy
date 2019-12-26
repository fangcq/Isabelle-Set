chapter \<open>Natural numbers\<close>

theory Nat
imports Ordinal Function

begin

text \<open>The basic results have already been shown for \<nat> = \<omega>.\<close>

definition nat ("\<nat>") where "\<nat> = \<omega>"

notation emptyset ("0")

lemmas
  nat_unfold = omega_unfold[folded nat_def] and
  zero_nat [simp] = empty_in_omega[folded nat_def] and
  succ_nat [simp] = succ_omega[folded nat_def] and
  nat_cases = omega_cases[folded nat_def] and
  nat_induct [case_names 0 induct, induct set: nat] = omega_induct[folded nat_def] and
  nat_elems = omega_elems[folded nat_def] and
  pred_nat [simp] = pred_omega[folded nat_def] and
  pred_0 = pred_empty and
  pred_succ [simp] = Ordinal.pred_succ[folded nat_def] and
  succ_pred [simp] = Ordinal.succ_pred[folded nat_def]


section \<open>\<nat> as a type\<close>

abbreviation "Nat \<equiv> element \<nat>"

lemmas Nat_induct = nat_induct
  [ simplified element_type_iff,
    case_names base induct,
    induct pred: Nat ]

lemmas Nat_cases = nat_cases[simplified element_type_iff]

lemma Nat_Ord [derive]: "x : Nat \<Longrightarrow> x : Ord"
  by (induct x rule: Nat_induct) (auto intro: succ_Ord)

lemma
  zero_type [type]: "0 : Nat" and
  succ_type [type]: "succ : Nat \<Rightarrow> Nat" and
  pred_type [type]: "pred : Nat \<Rightarrow> Nat"
  by unfold_types auto


section \<open>The \<open><\<close> and \<open>\<le>\<close> orders on Nat\<close>

definition lt (infix "<" 60) where "m < n = (m \<in> n)"

lemmas
  lt_succ [simp] = succ_mem[folded lt_def] and
  lt_succ_cases = succ_cases[folded lt_def]

lemma lt_monotone [intro]:
  "\<lbrakk>n: Nat; m: Nat; m < n\<rbrakk> \<Longrightarrow> succ m < succ n"
  unfolding lt_def by (induction n rule: Nat_induct) (auto simp: succ_def)

lemma lt_trichotomy:
  "\<lbrakk>m: Nat; n: Nat\<rbrakk> \<Longrightarrow> m < n \<or> m = n \<or> n < m"
  unfolding lt_def using Ord_trichotomy by auto
  \<comment>\<open>Good *EXAMPLE* of type derivation helpfulness!\<close>

lemma lt_trichotomyE:
  assumes major: "m: Nat" "n: Nat"
      and case1: "m < n \<Longrightarrow> P"
      and case2: "m = n \<Longrightarrow> P"
      and case3: "n < m \<Longrightarrow> P"
  shows P
  using assms lt_trichotomy unfolding lt_def by auto

definition le (infix "\<le>" 60) where "m \<le> n = (m < n \<or> m = n)"

lemma lt_imp_le: "m < n \<Longrightarrow> m \<le> n"
  unfolding le_def ..

lemma le_monotone [intro]:
  "\<lbrakk>n: Nat; m: Nat; m \<le> n\<rbrakk> \<Longrightarrow> succ m \<le> succ n"
  unfolding le_def using lt_monotone by auto

lemma lt_0 [simp]: "n : Nat \<Longrightarrow> 0 < succ n"
  unfolding lt_def nat_def by unfold_types (fact omega_empty_in_succ)

lemma zero_ltE [elim]: "n < 0 \<Longrightarrow> P"
  unfolding lt_def by auto

lemma le_0 [simp]: "n \<le> 0 \<Longrightarrow> n = 0"
  unfolding le_def by auto

lemma lt_imp_Nat [elim]: "n: Nat \<Longrightarrow> m < n \<Longrightarrow> m: Nat"
  unfolding nat_def lt_def by unfold_types (fact omega_mem_transitive)

(*Case splits*)
lemma le_cases:
  assumes "n: Nat"
      and "m \<le> n"
      and "\<And>m. m < n \<Longrightarrow> P m"
      and "P n"
  shows "P m"
  using assms unfolding le_def by auto


section \<open>More rewriting on \<open><\<close>\<close>

lemma succ_lt: "\<lbrakk>m: Nat; n: Nat; succ m < n\<rbrakk> \<Longrightarrow> m < n"
  unfolding succ_def lt_def nat_def
  by unfold_types (auto dest: omega_elem_Ord Ord_mem_transitive')


section \<open>Ranges\<close>

definition upto ("{0, ..., _}") where "{0, ..., n} = {i \<in> \<nat> | i \<le> n}"

lemma succ_eq_upto: "n: Nat \<Longrightarrow> succ n = {0, ..., n}"
  unfolding succ_def upto_def le_def lt_def
  by unfold_types (auto intro: equalityI omega_mem_transitive simp: nat_def)

lemmas upto_eq_succ = succ_eq_upto[symmetric]

lemma uptoI: "n: Nat \<Longrightarrow> m \<le> n \<Longrightarrow> m \<in> {0, ..., n}"
  by unfold_types (auto simp: upto_eq_succ le_def lt_def)

lemma uptoE1: "m \<in> {0, ..., n} \<Longrightarrow> m: Nat"
  unfolding upto_def by auto

lemmas [derive] = uptoE1[simplified element_type_iff]

lemma uptoE2: "m \<in> {0, ..., n} \<Longrightarrow> m \<le> n"
  unfolding upto_def by auto

lemma le_iff_upto: "n: Nat \<Longrightarrow> m \<le> n = (m \<in> {0, ..., n})"
  by (auto intro: uptoI elim: uptoE2)

lemmas upto_iff_le = le_iff_upto[symmetric]

lemma [derive]: "n: Nat \<Longrightarrow> 0: element {0, ..., n}"
  by
    (simp add: upto_eq_succ nat_def, unfold_types)
    (auto intro: omega_empty_in_succ)

lemma
  [derive]: "n: Nat \<Longrightarrow> n: element {0, ..., n}" and
  [derive]: "n: Nat \<Longrightarrow> m: element n \<Longrightarrow> m: element {0, ..., n}"
  by unfold_types (auto simp: upto_eq_succ)

lemma le_induct_raw [rule_format]:
  "n: Nat \<Longrightarrow> P 0 \<Longrightarrow> (\<forall>m. m < n \<longrightarrow> P m \<longrightarrow> P (succ m)) \<longrightarrow> (\<forall>m. m \<le> n \<longrightarrow> P m)"

text \<open>Proof sketch: case n = 0 is easy, case n > 0 is by induction.\<close>

proof (cases n rule: Nat_cases, assumption; rule impI)
  assume "P 0"
  then show "\<forall>m. m \<le> 0 \<longrightarrow> P m" by (auto dest: le_0)
next
  fix n assume assms:
    "n: Nat"
    "P 0"
    "(\<forall>m. m < succ n \<longrightarrow> P m \<longrightarrow> P (succ m))"
  show "\<forall>m. m \<le> succ n \<longrightarrow> P m"
  proof clarify
    have *: "succ n: Nat" using assms by auto

    { fix m have "m: Nat \<Longrightarrow> m < succ n \<Longrightarrow> P m"
      proof (induction m rule: Nat_induct)
        show "P 0" by (fact assms)
      next
        fix k assume assms': "k: Nat" "k < succ n \<Longrightarrow> P k" "succ k < succ n"
        then have "k < succ n" by (auto intro: succ_lt)
        moreover have "P k" using assms' by auto
        ultimately show "P (succ k)" using assms(3) by auto
      qed
      hence "m < succ n \<Longrightarrow> P m" using lt_imp_Nat[OF *] by auto
    }
    hence 1: "\<And>m. m < succ n \<Longrightarrow> P m" by auto
    hence 2: "P (succ n)" using assms(3) by auto

    fix m show "m \<le> succ n \<Longrightarrow> P m" using 1 2 by (auto elim: le_cases[OF *])
  qed
qed

lemma le_induct:
  assumes "n: Nat"
      and "m \<le> n"
      and "P 0"
      and "\<And>m. m < n \<Longrightarrow> P m \<Longrightarrow> P (succ m)"
  shows "P m"
  using le_induct_raw assms by auto

lemma cons_upto_FunctionI [intro]:
  assumes "n: Nat"
      and "f \<in> {0, ..., n} \<rightarrow> X"
      and "x \<in> X"
  shows "cons \<langle>succ n, x\<rangle> f \<in> {0, ..., succ n} \<rightarrow> X"
  by
    (simp only: upto_eq_succ, subst (2) succ_def)
    (auto intro: assms cons_FunctionI' simp: succ_eq_upto mem_irrefl)


section \<open>Recursion\<close>

text \<open>Well-founded recursion on Nat\<close>

lemma Nat_recursion:
  assumes "f : element X \<Rightarrow> element X"
      and "x\<^sub>0 : element X"
  obtains F where
    "F : Nat \<Rightarrow> element X"
    "F 0 = x\<^sub>0"
    "\<And>n. n: Nat \<Longrightarrow> F (succ n) = f (F n)"

proof

fix n

text \<open>
  First construct partial functions that satisfy the recursion rule on their
  domain of definition.
\<close>

have partial_existence:
  "n: Nat \<Longrightarrow> \<exists>F.
    F \<in> {0, ..., succ n} \<rightarrow> X \<and>
    F `0 = x\<^sub>0 \<and>
    (\<forall>m. m < n \<longrightarrow> F `(succ m) = f (F `m)) \<and>
    F `(succ n) = f (F `n)"

  proof (induction n rule: Nat_induct)
    case base
    let ?F = "{\<langle>0, x\<^sub>0\<rangle>, \<langle>succ 0, f x\<^sub>0\<rangle>}"
    have "{0, ..., succ 0} = {succ 0} \<union> {0}"
      by (simp only: upto_eq_succ) (auto intro: equalityI simp: succ_def)
    hence "?F \<in> {0, ..., succ 0} \<rightarrow> X"
      by (force intro: cons_FunctionI' assms)
    thus
      "\<exists>F. F \<in> {0, ..., succ 0} \<rightarrow> X \<and> F `0 = x\<^sub>0 \<and>
      (\<forall>m. m < 0 \<longrightarrow> F `(succ m) = f (F `m)) \<and> F `(succ 0) = f (F `0)"
      by auto

    case (induct n)
    obtain F where IH:
      "F \<in> {0, ..., succ n} \<rightarrow> X"
      "F `0 = x\<^sub>0"
      "\<forall>m. m < n \<longrightarrow> F `(succ m) = f (F `m)"
      "F `(succ n) = f (F `n)"
      using induct.IH by auto

    let ?F = "cons \<langle>succ (succ n), f (F `(succ n))\<rangle> F"

    have 1: "?F \<in> {0, ..., succ (succ n)} \<rightarrow> X"
      by (fastforce intro: IH simp: [[type_derivation_depth=4]])
      \<comment>\<open>*EXAMPLE*: needs derivation depth 4\<close>

    have 2: "?F `0 = x\<^sub>0"
      using IH(2) by auto

    have 3: "\<forall>m. m < succ n \<longrightarrow> ?F `(succ m) = f (?F `m)"
      using IH by (auto elim: succ_cases simp: lt_def)

    have 4: "?F `(succ (succ n)) = f (?F `(succ n))"
      by (simp add: IH(1) mem_irrefl)

    show "\<exists>F.
      F \<in> {0, ..., succ (succ n)} \<rightarrow> X \<and>
      F `0 = x\<^sub>0 \<and>
      (\<forall>m. m < succ n \<longrightarrow> F `(succ m) = f (F `m)) \<and>
      F `(succ (succ n)) = f (F `(succ n))"
      using 1 2 3 4 by blast
  qed

text \<open>Next show that these partial functions are unique for each n.\<close>

let ?P = "\<lambda>F.
  F \<in> {0, ..., succ n} \<rightarrow> X \<and>
  F `0 = x\<^sub>0 \<and>
  (\<forall>m. m < n \<longrightarrow> F `(succ m) = f (F `m)) \<and>
  F `(succ n) = f (F `n)"

assume "n: Nat"

have partial_uniqueness:
  "\<And>F G. ?P F \<Longrightarrow> ?P G \<Longrightarrow> F = G"

  proof -
    have succ_n: "succ n: Nat" by auto

    fix F G assume F: "?P F" and G: "?P G" show "F = G"
    proof (rule funext)
      show "F \<in> {0, ..., succ n} \<rightarrow> X" and "G \<in> {0, ..., succ n} \<rightarrow> X"
        using F G by fast+

      fix m show "m \<in> {0, ..., succ n} \<Longrightarrow> F `m = G `m"
      proof (simp only: upto_iff_le, elim le_induct[OF succ_n])
        show "F `0 = G `0" using F G by auto
      next
        fix k have "k < succ n \<Longrightarrow> F `k = G `k \<longrightarrow> F `(succ k) = G `(succ k)"
        proof (elim lt_succ_cases; clarify)
          fix x assume x: "x < n" "F `x = G `x"
          have "F `(succ x) = f (F `x)" using F by auto
          also have "f (F `x) = f (G `x)" using x by auto
          also have "f (G `x) = G `(succ x)" using G by auto
          finally show "F `(succ x) = G `(succ x)" .

          next show "F `n = G `n \<Longrightarrow> F `(succ n) = G `(succ n)" using F G by auto
        qed
        thus "k < succ n \<Longrightarrow> F `k = G `k \<Longrightarrow> F `(succ k) = G `(succ k)" ..
      qed
    qed
  qed

oops


section \<open>Primitive recursion\<close>

definition "nat_case \<equiv> \<lambda>n\<^sub>0\<in> \<nat>. \<lambda>f\<in> \<nat> \<rightarrow> \<nat>. \<lambda>n\<in> \<nat>.
  if n = 0 then n\<^sub>0 else f `(pred n)"

text \<open>
  Lift set-theoretic notion to HOL by reflecting the argument HOL function f to
  the set theory.

  Maybe this can be automated with syntax phase translations in the future?
\<close>

definition "natcase n\<^sub>0 f n = nat_case `n\<^sub>0 `(\<lambda>n\<in> \<nat>. f n) `n"

lemma natcase_type [type]:
  "natcase: Nat \<Rightarrow> (Nat \<Rightarrow> Nat) \<Rightarrow> Nat \<Rightarrow> Nat"
  unfolding natcase_def nat_case_def
  apply unfold_types
  text \<open>Reasoning with set-theoretic function is still quite manual\<close>
  apply (rule FunctionE)+
  apply (rule FunctionI)+
  by auto

lemma natcase_0 [simp]:
  assumes "n\<^sub>0 : Nat"
      and "f : Nat \<Rightarrow> Nat"
  shows "natcase n\<^sub>0 f 0 = n\<^sub>0"
  unfolding natcase_def nat_case_def
  using assms by unfold_types fastforce

lemma natcase_succ [simp]:
  assumes "n\<^sub>0 : Nat"
      and "f : Nat \<Rightarrow> Nat"
      and "n : Nat"
  shows "natcase n\<^sub>0 f (succ n) = f n"
  unfolding natcase_def nat_case_def
  using assms by unfold_types fastforce

(*THIS DEFINITION IS WRONG: it needs the well-founded recursion operator*)
definition "natrec n\<^sub>0 f n = natcase n\<^sub>0 (\<lambda>x. f (natcase n\<^sub>0 f x)) n"

text \<open>
  The next proof is a nontrivial *EXAMPLE* of where type derivation is doing
  some nontrivial simplification of a proof! :) :) :)
  (The derivation depth needs to be increased in order to derive the required
  type of the inner function \<open>\<lambda>x. f (natcase n\<^sub>0 f (pred x))\<close>.
\<close>

lemma natrec_0 [simp]:
  assumes "n\<^sub>0 : Nat"
      and "f : Nat \<Rightarrow> Nat"
  shows "natrec n\<^sub>0 f 0 = n\<^sub>0"
  unfolding natrec_def
  using assms [[type_derivation_depth=3]] by auto

lemma natrec_succ:
  assumes "n\<^sub>0 : Nat"
      and "f : Nat \<Rightarrow> Nat"
      and "n : Nat"
  shows "natrec n\<^sub>0 f (succ n) = f (natrec n\<^sub>0 f n)"
oops


section \<open>Addition\<close>

(*
  We might consider implementing set-theoretic lambdas for set-sized soft types
  if we want to conform to usual type-theoretic notation. (Do we?)
  This ventures a little into Mizar-like "sethood" territory...
*)

text \<open>This definition is rather low-level for now:\<close>

(* definition "natural_add = \<lambda>m n\<in> \<nat>. if m = 0 then n else succ *)


section \<open>Monoid properties\<close>




end