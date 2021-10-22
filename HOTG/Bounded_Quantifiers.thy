section \<open>Bounded Quantifiers\<close>

theory Bounded_Quantifiers
imports Basic
begin

definition ball :: \<open>set \<Rightarrow> (set \<Rightarrow> bool) \<Rightarrow> bool\<close>
  where "ball A P \<equiv> (\<forall>x. x \<in> A \<longrightarrow> P x)"

definition bex :: \<open>set \<Rightarrow> (set \<Rightarrow> bool) \<Rightarrow> bool\<close>
  where "bex A P \<equiv> \<exists>x. x \<in> A \<and> P x"

definition bex1 :: \<open>set \<Rightarrow> (set \<Rightarrow> bool) \<Rightarrow> bool\<close>
  where "bex1 A P \<equiv> \<exists>!x. x \<in> A \<and> P x"

(*TODO: localise*)
syntax
  "_ball"  :: \<open>[idts, set, bool] \<Rightarrow> bool\<close> ("(2\<forall>_ \<in> _./ _)" 10)
  "_ball2" :: \<open>[idts, set, bool] \<Rightarrow> bool\<close>
  "_bex"   :: \<open>[idts, set, bool] \<Rightarrow> bool\<close> ("(2\<exists>_ \<in> _./ _)" 10)
  "_bex2"  :: \<open>[idts, set, bool] \<Rightarrow> bool\<close>
  "_bex1"  :: \<open>[pttrn, set, bool] \<Rightarrow> bool\<close> ("(2\<exists>!_ \<in> _./ _)" 10)
translations
  "\<forall>x xs \<in> A. P" \<rightharpoonup> "CONST ball A (\<lambda>x. _ball2 xs A P)"
  "_ball2 x A P" \<rightharpoonup> "\<forall>x \<in> A. P"
  "\<forall>x \<in> A. P" \<rightleftharpoons> "CONST ball A (\<lambda>x. P)"

  "\<exists>x xs \<in> A. P" \<rightharpoonup> "CONST bex A (\<lambda>x. _bex2 xs A P)"
  "_bex2 x A P" \<rightharpoonup> "\<exists>x \<in> A. P"
  "\<exists>x \<in> A. P" \<rightleftharpoons> "CONST bex A (\<lambda>x. P)"

  "\<exists>!x \<in> A. P" \<rightleftharpoons> "CONST bex1 A (\<lambda>x. P)"


lemma ballI [intro!]: "\<lbrakk>\<And>x. x \<in> A \<Longrightarrow> P x\<rbrakk> \<Longrightarrow> \<forall>x \<in> A. P x"
  by (simp add: ball_def)

lemma ballD [dest?]: "\<lbrakk>\<forall>x \<in> A. P x; x \<in> A\<rbrakk> \<Longrightarrow> P x"
  by (simp add: ball_def)

lemma ballE: "\<lbrakk>\<forall>x \<in> A. P x; P x \<Longrightarrow> Q; x \<notin> A \<Longrightarrow> Q\<rbrakk> \<Longrightarrow> Q"
  unfolding ball_def by auto

corollary ballE' [elim]: "\<lbrakk>\<forall>x \<in> A. P x; x \<notin> A \<Longrightarrow> Q; P x \<Longrightarrow> Q\<rbrakk> \<Longrightarrow> Q"
  by (rule ballE)

(*LP: Trival rewrite rule: \<open>(\<forall>x \<in> A. P) \<longleftrightarrow> P\<close> holds only if A is nonempty!*)
lemma ball_triv [simp]: "(\<forall>x \<in> A. P) \<longleftrightarrow> ((\<exists>x. x \<in> A) \<longrightarrow> P)"
  by (simp add: ball_def)

lemma ball_cong [cong]:
  "\<lbrakk>A = A'; \<And>x. x \<in> A' \<Longrightarrow> P x \<longleftrightarrow> P' x\<rbrakk> \<Longrightarrow> (\<forall>x \<in> A. P x) \<longleftrightarrow> (\<forall>x \<in> A'. P' x)"
  by (simp add: ball_def)

lemma atomize_ball:
  "(\<And>x. x \<in> A \<Longrightarrow> P x) \<equiv> Trueprop (\<forall>x \<in> A. P x)"
  by (simp only: ball_def atomize_all atomize_imp)

declare atomize_ball[symmetric, rulify]
declare atomize_ball[symmetric, defn]

lemma bexI [intro]: "\<lbrakk>P x; x \<in> A\<rbrakk> \<Longrightarrow> \<exists>x \<in> A. P x"
  by (simp add: bex_def, blast)

(*LP: The best argument order when there is only one @{term "x \<in> A"}*)
corollary bexI': "\<lbrakk>x \<in> A; P x\<rbrakk> \<Longrightarrow> \<exists>x \<in> A. P x" ..

lemma bexE [elim!]: "\<lbrakk>\<exists>x \<in> A. P x; \<And>x. \<lbrakk>x \<in> A; P x\<rbrakk> \<Longrightarrow> Q\<rbrakk> \<Longrightarrow> Q"
  by (simp add: bex_def, blast)

(*LP: We do not even have @{term "(\<exists>x \<in> A. True) \<longleftrightarrow> True"} unless @{term "A"} is
  nonempty.*)
lemma bex_triv [simp]: "(\<exists>x \<in> A. P) \<longleftrightarrow> ((\<exists>x. x \<in> A) \<and> P)"
  by (simp add: bex_def)

lemma bex_cong [cong]:
  "\<lbrakk>A = A'; \<And>x. x \<in> A' \<Longrightarrow> P x \<longleftrightarrow> P' x\<rbrakk> \<Longrightarrow> (\<exists>x \<in> A. P x) \<longleftrightarrow> (\<exists>x \<in> A'. P' x)"
  by (simp add: bex_def cong: conj_cong)

lemma bex1I [intro]: "\<lbrakk>P x; x \<in> A; \<And>z. \<lbrakk>P z; z \<in> A\<rbrakk> \<Longrightarrow> z = x\<rbrakk> \<Longrightarrow> \<exists>!x \<in> A. P x"
  by (simp add: bex1_def, blast)

lemma bex1I': "\<lbrakk>x \<in> A; P x; \<And>z. \<lbrakk>P z; z \<in> A\<rbrakk> \<Longrightarrow> z = x\<rbrakk> \<Longrightarrow> \<exists>!x \<in> A. P x"
  by blast

lemma bex1E [elim!]: "\<lbrakk>\<exists>!x \<in> A. P x; \<And>x. \<lbrakk>x \<in> A; P x\<rbrakk> \<Longrightarrow> Q\<rbrakk> \<Longrightarrow> Q"
  by (simp add: bex1_def, blast)

lemma bex1_triv [simp]: "(\<exists>!x \<in> A. P) \<longleftrightarrow> ((\<exists>!x. x \<in> A) \<and> P)"
  by (auto simp add: bex1_def)

lemma bex1_iff: "(\<exists>!x \<in> A. P x) \<longleftrightarrow> (\<exists>!x. x \<in> A \<and> P x)"
  by (auto simp add: bex1_def)

lemma bex1_cong [cong]:
  "\<lbrakk>A = A'; \<And>x. x \<in> A' \<Longrightarrow> P x \<longleftrightarrow> P' x\<rbrakk> \<Longrightarrow> (\<exists>!x \<in> A. P x) \<longleftrightarrow> (\<exists>!x \<in> A'. P' x)"
  by (simp add: bex1_def cong: conj_cong)

lemma bex_if_bex1: "\<exists>!x \<in> A. P x \<Longrightarrow> \<exists>x \<in> A. P x"
  by auto

lemma ball_conj_distrib: "(\<forall>x \<in> A. P x \<and> Q x) \<longleftrightarrow> (\<forall>x \<in> A. P x) \<and> (\<forall>x \<in> A. Q x)"
  by auto


section \<open>Bounded definite description\<close>

definition bthe :: "set \<Rightarrow> (set \<Rightarrow> bool) \<Rightarrow> set"
  where "bthe A P \<equiv> The (\<lambda>x. x \<in> A \<and> P x)"

(*TODO: localise*)
syntax "_bthe" :: "[pttrn, set, bool] \<Rightarrow> set" ("(3THE _ \<in> _./ _)" [0, 0, 10] 10)
translations "THE x \<in> A. P" \<rightleftharpoons> "CONST bthe A (\<lambda>x. P)"

lemma bthe_eqI [intro]:
  assumes "P a"
  and "a \<in> A"
  and "\<And>x. \<lbrakk>x \<in> A; P x\<rbrakk> \<Longrightarrow> x = a"
  shows "(THE x \<in> A. P x) = a"
  unfolding bthe_def by (auto intro: assms)

lemma
  bthe_memI: "\<exists>!x \<in> A. P x \<Longrightarrow> (THE x \<in> A. P x) \<in> A" and
  btheI: "\<exists>!x \<in> A. P x \<Longrightarrow> P (THE x \<in> A. P x)"
  unfolding bex1_def bthe_def by (auto simp: theI'[of "\<lambda>x. x \<in> A \<and> P x"])

simproc_setup defined_bex ("\<exists>x \<in> A. P x \<and> Q x") =
  \<open>fn _ => Quantifier1.rearrange_Bex
    (fn ctxt =>
      unfold_tac ctxt @{thms bex_def})\<close>

simproc_setup defined_ball ("\<forall>x \<in> A. P x \<longrightarrow> Q x") =
  \<open>fn _ => Quantifier1.rearrange_Ball
    (fn ctxt =>
      unfold_tac ctxt @{thms ball_def})\<close>


end
