-- metadata schema
DROP SCHEMA IF EXISTS metadata CASCADE;
CREATE SCHEMA metadata
  AUTHORIZATION "%db_admin%";

GRANT ALL ON SCHEMA metadata TO "%db_admin%";
GRANT USAGE ON SCHEMA metadata TO "%db_read%";
ALTER DEFAULT PRIVILEGES IN SCHEMA metadata GRANT SELECT ON TABLES TO "%db_read%";

-- metadata table
CREATE TABLE metadata.metadata
(
  id_metadata serial NOT NULL,
  identifier text,
  persistent_identifier text,
  title text,
  contacts_and_roles text,
  subject text,
  description text,
  date text,
format text,
language text,
relation text,
spatial_coverage text,
temporal_coverage text,
rights text,
source text,
lineage text,
supplemental_information text,
dataset_type text,
sql_query_dataset_extraction text,
database_table_name text,
database_view_name text,
  CONSTRAINT metadata_pkey PRIMARY KEY (id_metadata),
  CONSTRAINT unique_identifier UNIQUE (identifier)
);

ALTER TABLE metadata.metadata
  OWNER TO "%db_admin%";
GRANT ALL ON TABLE metadata.metadata TO "%db_admin%";
COMMENT ON TABLE metadata.metadata IS 'Table containing the metadata on all the datasets available in the database';

-- metadata_mapping table
CREATE TABLE metadata.metadata_mapping
(
  metadata_mapping_id_from integer NOT NULL,
  metadata_mapping_id_to integer NOT NULL,
  metadata_mapping_relation_type character varying(40),
  metadata_mapping_description text,
  CONSTRAINT metadata_mapping_pkey PRIMARY KEY (metadata_mapping_id_from, metadata_mapping_id_to),
  CONSTRAINT metadata_mapping_metadata_mapping_id_from_fkey FOREIGN KEY (metadata_mapping_id_from)
      REFERENCES metadata.metadata (id_metadata) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE CASCADE,
  CONSTRAINT metadata_mapping_metadata_mapping_id_to_fkey FOREIGN KEY (metadata_mapping_id_to)
      REFERENCES metadata.metadata (id_metadata) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE CASCADE
);

ALTER TABLE metadata.metadata_mapping
  OWNER TO "%db_admin%";
GRANT ALL ON TABLE metadata.metadata_mapping TO "%db_admin%";
COMMENT ON TABLE metadata.metadata_mapping IS 'Table containing the genealogy of the datasets, i.e. the list of datasets used as input of each dataset available in the database';
COMMENT ON COLUMN metadata.metadata_mapping.metadata_mapping_id_from IS '"metadata_mapping_id_from" identifier of the dataset which is the Subject of the relationship';
COMMENT ON COLUMN metadata.metadata_mapping.metadata_mapping_id_to IS '"metadata_mapping_id_to" identifier of the dataset which is the Predicate of the relationship';
COMMENT ON COLUMN metadata.metadata_mapping.metadata_mapping_relation_type IS '"metadata_mapping_relation_type" the kind of relationship between these two datasets: is made of, is source of.. ';
COMMENT ON COLUMN metadata.metadata_mapping.metadata_mapping_description IS '"metadata_mapping_description" details of the relationship';

-- fact table schema
DROP SCHEMA IF EXISTS fact_tables CASCADE;
CREATE SCHEMA fact_tables
  AUTHORIZATION "%db_admin%";

GRANT ALL ON SCHEMA fact_tables TO "%db_admin%";
GRANT USAGE ON SCHEMA fact_tables TO "%db_read%";
ALTER DEFAULT PRIVILEGES IN SCHEMA fact_tables GRANT SELECT ON TABLES TO "%db_read%";

COMMENT ON SCHEMA fact_tables IS 'Schema containing the time series datasets stored as integer values';
COMMENT ON SCHEMA metadata IS 'Schema containing the metadata on all the datasets available in the database';
