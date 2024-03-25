\<^marker>\<open>creator "Linghan Fang"\<close>
\<^marker>\<open>creator "Kevin Kappelmann"\<close>
section \<open>Cardinals\<close>
theory Cardinals_Base
  imports
    Equipollence
    Ordinals_Base
begin

unbundle no_HOL_groups_syntax

paragraph \<open>Summary\<close>
text \<open>Translation of cardinality from HOL-Library and \<^cite>\<open>ZFC_in_HOL_AFP\<close>.

The cardinality of a set \<open>X\<close> is the smallest ordinal number \<open>\<alpha>\<close> such that there
exists a bijection between \<open>X\<close> and \<open>\<alpha>\<close>.
Further details can be found in \<^url>\<open>https://en.wikipedia.org/wiki/Cardinal_number\<close>.\<close>

definition "least_wrt_rel R P = (THE x. P x \<and> (\<forall>y. P y \<longrightarrow> R x y))"

lemma least_wrt_rel_cong:
  assumes "\<And>x y. R x y \<longleftrightarrow> R' x y"
  and "\<And>x. P x \<longleftrightarrow> P' x"
  shows "least_wrt_rel R P = least_wrt_rel R' P'"
  using assms unfolding least_wrt_rel_def by simp

text\<open>Cardinality is defined as in \<^cite>\<open>ZFC_in_HOL_AFP\<close>,
\<^url>\<open>https://foss.heptapod.net/isa-afp/afp-devel/-/blob/06458dfa40c7b4aaaeb855a37ae77993cb4c8c18/thys/ZFC_in_HOL/ZFC_Cardinals.thy#L1785\<close>.\<close>

definition "cardinality (X :: set) \<equiv> least_wrt_rel (\<subseteq>) (ordinal \<sqinter> ((\<approx>) X))"

bundle hotg_cardinality_syntax begin notation cardinality ("|_|") end
bundle no_hotg_cardinality_syntax begin no_notation cardinality ("|_|") end
unbundle hotg_cardinality_syntax

lemma cardinality_eq_if_equipollent:
  assumes "X \<approx> Y"
  shows "|X| = |Y|"
  unfolding cardinality_def using assms transitive_equipollent symmetric_equipollent
  by (intro least_wrt_rel_cong) (auto dest: symmetricD)

text\<open>The next lemma shows that \<open>X\<close> is equipollent with @{term "|X|"}
The proof requires order types, which are currently missing.
For a proof, see
\<^url>\<open>https://foss.heptapod.net/isa-afp/afp-devel/-/blob/06458dfa40c7b4aaaeb855a37ae77993cb4c8c18/thys/ZFC_in_HOL/ZFC_Cardinals.thy#L1829\<close>.\<close>

lemma cardinality_equipollent_self [iff]: "|X| \<approx> X"
  sorry

lemma cardinality_cardinality_eq_cardinality [simp]: "||X|| = |X|"
  by (intro cardinality_eq_if_equipollent cardinality_equipollent_self)


end
