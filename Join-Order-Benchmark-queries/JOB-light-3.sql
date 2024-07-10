/*
Credit: 
Kipf, A., Kipf, T., Radke, B., Leis, V., Boncz, P., & Kemper, A. (2019).
Learned cardinalities: Estimating correlated joins with deep learning.
9th Biennial Conference on Innovative Data Systems Research (CIDR ‘19), CA, USA.
https://arxiv.org/abs/1809.00677

"JOB-light" contains 3 of the original 113 JOB queries.
As outlined by Kipf et al. (2019), JOB-light:
1. Does not contain any predicates on strings or disjunctions
2. Contains only queries with 1-4 joins
3. Has mostly equality predicates on dimension table attributes
4. The only range predicate is on production_year
*/

/* NOTE: These are simply the first 3 queries in 'JOB-light-70.sql'
   The queries are being used to test the computation of multiple q-error
   values.
*/
SELECT COUNT(*) FROM movie_companies mc,title t,movie_info_idx mi_idx WHERE t.id=mc.movie_id AND t.id=mi_idx.movie_id AND mi_idx.info_type_id=112 AND mc.company_type_id=2;
SELECT COUNT(*) FROM movie_companies mc,title t,movie_info_idx mi_idx WHERE t.id=mc.movie_id AND t.id=mi_idx.movie_id AND mi_idx.info_type_id=113 AND mc.company_type_id=2 AND t.production_year>2005 AND t.production_year<2010;
SELECT COUNT(*) FROM movie_companies mc,title t,movie_info_idx mi_idx WHERE t.id=mc.movie_id AND t.id=mi_idx.movie_id AND mi_idx.info_type_id=112 AND mc.company_type_id=2 AND t.production_year>2010;
