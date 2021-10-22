section \<open>Set Equality\<close>

theory Equality
imports Subset
begin

lemma eqI: "(\<And>x. x \<in> A \<Longrightarrow> x \<in> B) \<Longrightarrow> (\<And>x. x \<in> B \<Longrightarrow> x \<in> A) \<Longrightarrow> A = B"
  by (rule eq_if_subset_if_subset) auto

lemma eqI': "(\<And>x. x \<in> A \<longleftrightarrow> x \<in> B) \<Longrightarrow> A = B" by (rule eqI) auto

lemma eqE: "\<lbrakk>A = B; \<lbrakk>A \<subseteq> B ; B \<subseteq> A\<rbrakk> \<Longrightarrow> P\<rbrakk> \<Longrightarrow> P" by blast

lemma eqD: "A = B \<Longrightarrow> (\<And>x. x \<in> A \<longleftrightarrow> x \<in> B)" by auto

lemma ne_if_ex_mem_not_mem: "\<exists>x. x \<in> A \<and> x \<notin> B \<Longrightarrow> A \<noteq> B" by auto

end
