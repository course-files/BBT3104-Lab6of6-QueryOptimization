-- DBMS: MySQL
-- DATABASE: imdb
-- Create the database
CREATE DATABASE IF NOT EXISTS imdb_schema DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci;
USE imdb_schema;

-- Drop table

-- DROP TABLE imdb_schema.char_name;

CREATE TABLE imdb_schema.char_name (
	id int4 NOT NULL,
	name text NOT NULL,
	imdb_index varchar(12) NULL,
	imdb_id int4 NULL,
	name_pcode_nf varchar(5) NULL,
	surname_pcode varchar(5) NULL,
	md5sum varchar(32) NULL,
	CONSTRAINT char_name_pkey PRIMARY KEY (id)
);


-- imdb_schema.comp_cast_type definition

-- Drop table

-- DROP TABLE imdb_schema.comp_cast_type;

CREATE TABLE imdb_schema.comp_cast_type (
	id int4 NOT NULL,
	kind varchar(32) NOT NULL,
	CONSTRAINT comp_cast_type_pkey PRIMARY KEY (id)
);


-- imdb_schema.company_name definition

-- Drop table

-- DROP TABLE imdb_schema.company_name;

CREATE TABLE imdb_schema.company_name (
	id int4 NOT NULL,
	name text NOT NULL,
	country_code varchar(255) NULL,
	imdb_id int4 NULL,
	name_pcode_nf varchar(5) NULL,
	name_pcode_sf varchar(5) NULL,
	md5sum varchar(32) NULL,
	CONSTRAINT company_name_pkey PRIMARY KEY (id)
);


-- imdb_schema.company_type definition

-- Drop table

-- DROP TABLE imdb_schema.company_type;

CREATE TABLE imdb_schema.company_type (
	id int4 NOT NULL,
	kind varchar(32) NOT NULL,
	CONSTRAINT company_type_pkey PRIMARY KEY (id)
);


-- imdb_schema.info_type definition

-- Drop table

-- DROP TABLE imdb_schema.info_type;

CREATE TABLE imdb_schema.info_type (
	id int4 NOT NULL,
	info varchar(32) NOT NULL,
	CONSTRAINT info_type_pkey PRIMARY KEY (id)
);


-- imdb_schema.keyword definition

-- Drop table

-- DROP TABLE imdb_schema.keyword;

CREATE TABLE imdb_schema.keyword (
	id int4 NOT NULL,
	keyword text NOT NULL,
	phonetic_code varchar(5) NULL,
	CONSTRAINT keyword_pkey PRIMARY KEY (id)
);


-- imdb_schema.kind_type definition

-- Drop table

-- DROP TABLE imdb_schema.kind_type;

CREATE TABLE imdb_schema.kind_type (
	id int4 NOT NULL,
	kind varchar(15) NOT NULL,
	CONSTRAINT kind_type_pkey PRIMARY KEY (id)
);


-- imdb_schema.link_type definition

-- Drop table

-- DROP TABLE imdb_schema.link_type;

CREATE TABLE imdb_schema.link_type (
	id int4 NOT NULL,
	link varchar(32) NOT NULL,
	CONSTRAINT link_type_pkey PRIMARY KEY (id)
);


-- imdb_schema."name" definition

-- Drop table

-- DROP TABLE imdb_schema."name";

CREATE TABLE imdb_schema.name (
	id int4 NOT NULL,
	name text NOT NULL,
	imdb_index varchar(12) NULL,
	imdb_id int4 NULL,
	gender varchar(1) NULL,
	name_pcode_cf varchar(5) NULL,
	name_pcode_nf varchar(5) NULL,
	surname_pcode varchar(5) NULL,
	md5sum varchar(32) NULL,
	CONSTRAINT name_pkey PRIMARY KEY (id)
);


-- imdb_schema.role_type definition

-- Drop table

-- DROP TABLE imdb_schema.role_type;

CREATE TABLE imdb_schema.role_type (
	id int4 NOT NULL,
	role varchar(32) NOT NULL,
	CONSTRAINT role_type_pkey PRIMARY KEY (id)
);


-- imdb_schema.aka_name definition

-- Drop table

-- DROP TABLE imdb_schema.aka_name;

CREATE TABLE imdb_schema.aka_name (
	id int4 NOT NULL,
	person_id int4 NOT NULL,
	name text NOT NULL,
	imdb_index varchar(12) NULL,
	name_pcode_cf varchar(5) NULL,
	name_pcode_nf varchar(5) NULL,
	surname_pcode varchar(5) NULL,
	md5sum varchar(32) NULL,
	CONSTRAINT aka_name_pkey PRIMARY KEY (id),
	CONSTRAINT aka_name_name_fk FOREIGN KEY (person_id) REFERENCES imdb_schema.name(id) ON DELETE CASCADE ON UPDATE CASCADE
);
CREATE INDEX person_id_aka_name USING BTREE ON imdb_schema.aka_name (person_id);


-- imdb_schema.person_info definition

-- Drop table

-- DROP TABLE imdb_schema.person_info;

CREATE TABLE imdb_schema.person_info (
	id int4 NOT NULL,
	person_id int4 NOT NULL,
	info_type_id int4 NOT NULL,
	info text NOT NULL,
	note text NULL,
	CONSTRAINT person_info_pkey PRIMARY KEY (id),
	CONSTRAINT person_info_info_type_fk FOREIGN KEY (info_type_id) REFERENCES imdb_schema.info_type(id) ON DELETE CASCADE ON UPDATE CASCADE,
	CONSTRAINT person_info_name_fk FOREIGN KEY (person_id) REFERENCES imdb_schema.name(id) ON DELETE CASCADE ON UPDATE CASCADE
);
CREATE INDEX info_type_id_person_info USING btree ON imdb_schema.person_info (info_type_id);
CREATE INDEX person_id_person_info USING btree ON imdb_schema.person_info (person_id);


-- imdb_schema.title definition

-- Drop table

-- DROP TABLE imdb_schema.title;

CREATE TABLE imdb_schema.title (
	id int4 NOT NULL,
	title text NOT NULL,
	imdb_index varchar(12) NULL,
	kind_id int4 NOT NULL,
	production_year int4 NULL,
	imdb_id int4 NULL,
	phonetic_code varchar(5) NULL,
	episode_of_id int4 NULL,
	season_nr int4 NULL,
	episode_nr int4 NULL,
	series_years varchar(49) NULL,
	md5sum varchar(32) NULL,
	CONSTRAINT title_pkey PRIMARY KEY (id),
	CONSTRAINT title_kind_type_fk FOREIGN KEY (kind_id) REFERENCES imdb_schema.kind_type(id) ON DELETE CASCADE ON UPDATE CASCADE
);
CREATE INDEX kind_id_title USING btree ON imdb_schema.title (kind_id);


-- NOTE: Additional insert into the "title" and "kind_type" relations.
-- This is required to create foreign keys correctly in the IMDb dataset used in Leis et al. (2018).
INSERT INTO imdb_schema.kind_type (id, kind) VALUES
	(7, 'episode');

INSERT INTO imdb_schema.title (id,title,imdb_index,kind_id,production_year,imdb_id,phonetic_code,episode_of_id,season_nr,episode_nr,series_years,md5sum) VALUES
	 (0,'*NOTE: Added to create Foreign Key in aka_title*',NULL,7,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL);

-- imdb_schema.aka_title definition

-- Drop table

-- DROP TABLE imdb_schema.aka_title;

CREATE TABLE imdb_schema.aka_title (
	id int4 NOT NULL,
	movie_id int4 NOT NULL,
	title text NOT NULL,
	imdb_index varchar(12) NULL,
	kind_id int4 NOT NULL,
	production_year int4 NULL,
	phonetic_code varchar(5) NULL,
	episode_of_id int4 NULL,
	season_nr int4 NULL,
	episode_nr int4 NULL,
	note text NULL,
	md5sum varchar(32) NULL,
	CONSTRAINT aka_title_pkey PRIMARY KEY (id),
	CONSTRAINT aka_title_title_fk FOREIGN KEY (movie_id) REFERENCES imdb_schema.title(id) ON DELETE CASCADE ON UPDATE CASCADE
);
CREATE INDEX kind_id_aka_title USING btree ON imdb_schema.aka_title (kind_id);
CREATE INDEX movie_id_aka_title USING btree ON imdb_schema.aka_title (movie_id);


-- imdb_schema.cast_info definition

-- Drop table

-- DROP TABLE imdb_schema.cast_info;

CREATE TABLE imdb_schema.cast_info (
	id int4 NOT NULL,
	person_id int4 NOT NULL,
	movie_id int4 NOT NULL,
	person_role_id int4 NULL,
	note text NULL,
	nr_order int4 NULL,
	role_id int4 NOT NULL,
	CONSTRAINT cast_info_pkey PRIMARY KEY (id),
	CONSTRAINT cast_info_char_name_fk FOREIGN KEY (person_role_id) REFERENCES imdb_schema.char_name(id) ON DELETE CASCADE ON UPDATE CASCADE,
	CONSTRAINT cast_info_name_fk FOREIGN KEY (person_id) REFERENCES imdb_schema.name(id) ON DELETE CASCADE ON UPDATE CASCADE,
	CONSTRAINT cast_info_role_type_fk FOREIGN KEY (role_id) REFERENCES imdb_schema.role_type(id) ON DELETE CASCADE ON UPDATE CASCADE,
	CONSTRAINT cast_info_title_fk FOREIGN KEY (movie_id) REFERENCES imdb_schema.title(id) ON DELETE CASCADE ON UPDATE CASCADE
);
CREATE INDEX movie_id_cast_info USING btree ON imdb_schema.cast_info (movie_id);
CREATE INDEX person_id_cast_info USING btree ON imdb_schema.cast_info (person_id);
CREATE INDEX person_role_id_cast_info USING btree ON imdb_schema.cast_info (person_role_id);
CREATE INDEX role_id_cast_info USING btree ON imdb_schema.cast_info (role_id);


-- imdb_schema.complete_cast definition

-- Drop table

-- DROP TABLE imdb_schema.complete_cast;

CREATE TABLE imdb_schema.complete_cast (
	id int4 NOT NULL,
	movie_id int4 NULL,
	subject_id int4 NOT NULL,
	status_id int4 NOT NULL,
	CONSTRAINT complete_cast_pkey PRIMARY KEY (id),
	CONSTRAINT complete_cast_comp_cast_type_fk FOREIGN KEY (subject_id) REFERENCES imdb_schema.comp_cast_type(id) ON DELETE CASCADE ON UPDATE CASCADE,
	CONSTRAINT complete_cast_status_id_comp_cast_type_fk FOREIGN KEY (status_id) REFERENCES imdb_schema.comp_cast_type(id) ON DELETE CASCADE ON UPDATE CASCADE,
	CONSTRAINT complete_cast_title_fk FOREIGN KEY (movie_id) REFERENCES imdb_schema.title(id) ON DELETE CASCADE ON UPDATE CASCADE
);
CREATE INDEX movie_id_complete_cast USING btree ON imdb_schema.complete_cast (movie_id);


-- imdb_schema.movie_companies definition

-- Drop table

-- DROP TABLE imdb_schema.movie_companies;

CREATE TABLE imdb_schema.movie_companies (
	id int4 NOT NULL,
	movie_id int4 NOT NULL,
	company_id int4 NOT NULL,
	company_type_id int4 NOT NULL,
	note text NULL,
	CONSTRAINT movie_companies_pkey PRIMARY KEY (id),
	CONSTRAINT movie_companies_company_name_fk FOREIGN KEY (company_id) REFERENCES imdb_schema.company_name(id) ON DELETE CASCADE ON UPDATE CASCADE,
	CONSTRAINT movie_companies_company_type_fk FOREIGN KEY (company_type_id) REFERENCES imdb_schema.company_type(id) ON DELETE CASCADE ON UPDATE CASCADE,
	CONSTRAINT movie_companies_title_fk FOREIGN KEY (movie_id) REFERENCES imdb_schema.title(id) ON DELETE CASCADE ON UPDATE CASCADE
);
CREATE INDEX company_id_movie_companies USING btree ON imdb_schema.movie_companies (company_id);
CREATE INDEX company_type_id_movie_companies USING btree ON imdb_schema.movie_companies (company_type_id);
CREATE INDEX movie_id_movie_companies USING btree ON imdb_schema.movie_companies (movie_id);


-- imdb_schema.movie_info definition

-- Drop table

-- DROP TABLE imdb_schema.movie_info;

CREATE TABLE imdb_schema.movie_info (
	id int4 NOT NULL,
	movie_id int4 NOT NULL,
	info_type_id int4 NOT NULL,
	info text NOT NULL,
	note text NULL,
	CONSTRAINT movie_info_pkey PRIMARY KEY (id),
	CONSTRAINT movie_info_info_type_fk FOREIGN KEY (info_type_id) REFERENCES imdb_schema.info_type(id) ON DELETE CASCADE ON UPDATE CASCADE,
	CONSTRAINT movie_info_title_fk FOREIGN KEY (movie_id) REFERENCES imdb_schema.title(id) ON DELETE CASCADE ON UPDATE CASCADE
);
CREATE INDEX info_type_id_movie_info USING btree ON imdb_schema.movie_info (info_type_id);
CREATE INDEX movie_id_movie_info USING btree ON imdb_schema.movie_info (movie_id);


-- imdb_schema.movie_info_idx definition

-- Drop table

-- DROP TABLE imdb_schema.movie_info_idx;

CREATE TABLE imdb_schema.movie_info_idx (
	id int4 NOT NULL,
	movie_id int4 NOT NULL,
	info_type_id int4 NOT NULL,
	info text NOT NULL,
	note text NULL,
	CONSTRAINT movie_info_idx_pkey PRIMARY KEY (id),
	CONSTRAINT movie_info_idx_info_type_fk FOREIGN KEY (info_type_id) REFERENCES imdb_schema.info_type(id) ON DELETE CASCADE ON UPDATE CASCADE,
	CONSTRAINT movie_info_idx_title_fk FOREIGN KEY (movie_id) REFERENCES imdb_schema.title(id) ON DELETE CASCADE ON UPDATE CASCADE
);
CREATE INDEX info_type_id_movie_info_idx USING btree ON imdb_schema.movie_info_idx (info_type_id);
CREATE INDEX movie_id_movie_info_idx USING btree ON imdb_schema.movie_info_idx (movie_id);

-- imdb_schema.movie_keyword definition

-- Drop table

-- DROP TABLE imdb_schema.movie_keyword;

CREATE TABLE imdb_schema.movie_keyword (
	id int4 NOT NULL,
	movie_id int4 NOT NULL,
	keyword_id int4 NOT NULL,
	CONSTRAINT movie_keyword_pkey PRIMARY KEY (id),
	CONSTRAINT movie_keyword_keyword_fk FOREIGN KEY (keyword_id) REFERENCES imdb_schema.keyword(id) ON DELETE CASCADE ON UPDATE CASCADE,
	CONSTRAINT movie_keyword_title_fk FOREIGN KEY (movie_id) REFERENCES imdb_schema.title(id) ON DELETE CASCADE ON UPDATE CASCADE
);
CREATE INDEX keyword_id_movie_keyword USING btree ON imdb_schema.movie_keyword (keyword_id);
CREATE INDEX movie_id_movie_keyword USING btree ON imdb_schema.movie_keyword (movie_id);


-- imdb_schema.movie_link definition

-- Drop table

-- DROP TABLE imdb_schema.movie_link;

CREATE TABLE imdb_schema.movie_link (
	id int4 NOT NULL,
	movie_id int4 NOT NULL,
	linked_movie_id int4 NOT NULL,
	link_type_id int4 NOT NULL,
	CONSTRAINT movie_link_pkey PRIMARY KEY (id),
	CONSTRAINT movie_link_link_type_fk FOREIGN KEY (link_type_id) REFERENCES imdb_schema.link_type(id) ON DELETE CASCADE ON UPDATE CASCADE,
	CONSTRAINT movie_link_linked_movie_id_title_fk FOREIGN KEY (linked_movie_id) REFERENCES imdb_schema.title(id) ON DELETE CASCADE ON UPDATE CASCADE,
	CONSTRAINT movie_link_title_fk FOREIGN KEY (movie_id) REFERENCES imdb_schema.title(id) ON DELETE CASCADE ON UPDATE CASCADE
);
CREATE INDEX link_type_id_movie_link USING btree ON imdb_schema.movie_link (link_type_id);
CREATE INDEX linked_movie_id_movie_link USING btree ON imdb_schema.movie_link (linked_movie_id);
CREATE INDEX movie_id_movie_link USING btree ON imdb_schema.movie_link (movie_id);

-- Data import

-- Recommended order of importing the CSV data, one-by-one,
-- to avoid referential integrity constraint errors:

-- company_name (234,997 rows)
-- company_type (4 rows)
-- keyword (134,170 rows)
-- info_type (113 rows)
-- role_type (12 rows)
-- name (4,167,491 rows)
-- kind_type (7 rows)
-- person_info (2,963,664 rows)
-- link_type (18 rows)
-- comp_cast_type (4 rows)
-- char_name (3,140,339 rows)
-- aka_name (901,343 rows) *To continue from here
-- title (2,528,313 rows)
-- movie_keyword (4,523,930 rows)
-- movie_info_idx (1,380,035 rows)
-- aka_title (361,472 rows)
-- complete_cast (135,086 rows)
-- movie_link (29,997 rows)
-- movie_companies (2,609,129 rows)
-- movie_info (14,835,720 rows)
-- cast_info (36,244,344 rows)

-- Used to record the training data from the query workload
CREATE TABLE query_log (
	id INT auto_increment NOT NULL,
	query_text TEXT NULL,
	qep TEXT NULL,
	actual_rows bigint NULL,
	estimated_rows bigint NULL,
	q_error decimal NULL,
	timestamp timestamp DEFAULT CURRENT_TIMESTAMP NULL,
	table_set TEXT NULL,
	table_alias_set TEXT NULL,
	join_set TEXT NULL,
	predicate_set TEXT NULL,
	CONSTRAINT query_log_pk PRIMARY KEY (id)
);