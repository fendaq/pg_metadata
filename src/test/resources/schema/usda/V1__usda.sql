CREATE TABLE data_src (
  datasrc_id character(6) NOT NULL,
  authors text,
  title text NOT NULL,
  "year" integer,
  journal text,
  vol_city text,
  issue_state text,
  start_page text,
  end_page text
);

CREATE TABLE datsrcln (
  ndb_no character(5) NOT NULL,
  nutr_no character(3) NOT NULL,
  datasrc_id character(6) NOT NULL
);

CREATE TABLE deriv_cd (
  deriv_cd text NOT NULL,
  derivcd_desc text NOT NULL
);

CREATE TABLE fd_group (
  fdgrp_cd character(4) NOT NULL,
  fddrp_desc text NOT NULL
);

CREATE TABLE food_des (
  ndb_no character(5) NOT NULL,
  fdgrp_cd character(4) NOT NULL,
  long_desc text NOT NULL,
  shrt_desc text NOT NULL,
  comname text,
  manufacname text,
  survey character(1),
  ref_desc text,
  refuse integer,
  sciname text,
  n_factor double precision,
  pro_factor double precision,
  fat_factor double precision,
  cho_factor double precision
);

CREATE TABLE footnote (
  ndb_no character(5) NOT NULL,
  footnt_no character(4) NOT NULL,
  footnt_typ character(1) NOT NULL,
  nutr_no character(3),
  footnt_txt text NOT NULL
);

CREATE TABLE nut_data (
  ndb_no character(5) NOT NULL,
  nutr_no character(3) NOT NULL,
  nutr_val double precision NOT NULL,
  num_data_pts double precision NOT NULL,
  std_error double precision,
  src_cd integer NOT NULL,
  deriv_cd text,
  ref_ndb_no character(5),
  add_nutr_mark character(1),
  num_studies integer,
  min double precision,
  max double precision,
  df integer,
  low_eb double precision,
  up_eb double precision,
  stat_cmt text,
  cc character(1)
);

CREATE TABLE nutr_def (
  nutr_no character(3) NOT NULL,
  units text NOT NULL,
  tagname text,
  nutrdesc text,
  num_dec smallint,
  sr_order integer
);

CREATE TABLE src_cd (
  src_cd integer NOT NULL,
  srccd_desc text NOT NULL
);

CREATE TABLE weight (
  ndb_no character(5) NOT NULL,
  seq character(2) NOT NULL,
  amount double precision NOT NULL,
  msre_desc text NOT NULL,
  gm_wgt double precision NOT NULL,
  num_data_pts integer,
  std_dev double precision
);

ALTER TABLE ONLY data_src
ADD CONSTRAINT data_src_pkey PRIMARY KEY (datasrc_id);

ALTER TABLE ONLY datsrcln
ADD CONSTRAINT datsrcln_pkey PRIMARY KEY (ndb_no, nutr_no, datasrc_id);

ALTER TABLE ONLY deriv_cd
ADD CONSTRAINT deriv_cd_pkey PRIMARY KEY (deriv_cd);

ALTER TABLE ONLY fd_group
ADD CONSTRAINT fd_group_pkey PRIMARY KEY (fdgrp_cd);

ALTER TABLE ONLY food_des
ADD CONSTRAINT food_des_pkey PRIMARY KEY (ndb_no);

ALTER TABLE ONLY nut_data
ADD CONSTRAINT nut_data_pkey PRIMARY KEY (ndb_no, nutr_no);

ALTER TABLE ONLY nutr_def
ADD CONSTRAINT nutr_def_pkey PRIMARY KEY (nutr_no);

ALTER TABLE ONLY src_cd
ADD CONSTRAINT src_cd_pkey PRIMARY KEY (src_cd);

ALTER TABLE ONLY weight
ADD CONSTRAINT weight_pkey PRIMARY KEY (ndb_no, seq);

CREATE INDEX datsrcln_datasrc_id_idx ON datsrcln USING btree (datasrc_id);
CREATE INDEX food_des_fdgrp_cd_idx ON food_des USING btree (fdgrp_cd);
CREATE INDEX footnote_ndb_no_idx ON footnote USING btree (ndb_no, nutr_no);
CREATE INDEX nut_data_deriv_cd_idx ON nut_data USING btree (deriv_cd);
CREATE INDEX nut_data_nutr_no_idx ON nut_data USING btree (nutr_no);
CREATE INDEX nut_data_src_cd_idx ON nut_data USING btree (src_cd);

ALTER TABLE ONLY datsrcln
ADD CONSTRAINT datsrcln_datasrc_id_fkey FOREIGN KEY (datasrc_id) REFERENCES data_src(datasrc_id);

ALTER TABLE ONLY datsrcln
ADD CONSTRAINT datsrcln_ndb_no_fkey FOREIGN KEY (ndb_no, nutr_no) REFERENCES nut_data(ndb_no, nutr_no);

ALTER TABLE ONLY food_des
ADD CONSTRAINT food_des_fdgrp_cd_fkey FOREIGN KEY (fdgrp_cd) REFERENCES fd_group(fdgrp_cd);

ALTER TABLE ONLY footnote
ADD CONSTRAINT footnote_ndb_no_fkey FOREIGN KEY (ndb_no) REFERENCES food_des(ndb_no);

ALTER TABLE ONLY footnote
ADD CONSTRAINT footnote_nutr_no_fkey FOREIGN KEY (nutr_no) REFERENCES nutr_def(nutr_no);

ALTER TABLE ONLY nut_data
ADD CONSTRAINT nut_data_deriv_cd_fkey FOREIGN KEY (deriv_cd) REFERENCES deriv_cd(deriv_cd);

ALTER TABLE ONLY nut_data
ADD CONSTRAINT nut_data_ndb_no_fkey FOREIGN KEY (ndb_no) REFERENCES food_des(ndb_no);

ALTER TABLE ONLY nut_data
ADD CONSTRAINT nut_data_nutr_no_fkey FOREIGN KEY (nutr_no) REFERENCES nutr_def(nutr_no);

ALTER TABLE ONLY nut_data
ADD CONSTRAINT nut_data_src_cd_fkey FOREIGN KEY (src_cd) REFERENCES src_cd(src_cd);

ALTER TABLE ONLY weight
ADD CONSTRAINT weight_ndb_no_fkey FOREIGN KEY (ndb_no) REFERENCES food_des(ndb_no);
