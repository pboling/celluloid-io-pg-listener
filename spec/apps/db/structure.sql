--
-- PostgreSQL database dump
--

SET statement_timeout = 0;
-- The following was commented out by rake db:structure:fix_plpgsql
-- SET lock_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;

--
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: -
--

-- The following was commented out by rake db:structure:fix_plpgsql
-- CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: -
--

-- The following was commented out by rake db:structure:fix_plpgsql
-- COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


SET search_path = public, pg_catalog;

--
-- Name: notify_on_users_delete_function(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION notify_on_users_delete_function() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
  RAISE NOTICE 'DELETE TRIGGER called on %', TG_TABLE_NAME;
  PERFORM pg_notify('users_delete', json_build_object('table', TG_TABLE_NAME,
                                                      'id', OLD.id,
                                                      'name', OLD.name,
                                                      'type', TG_OP)::text);
  RETURN NEW;
END;
$$;


--
-- Name: notify_on_users_insert_function(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION notify_on_users_insert_function() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
  RAISE NOTICE 'INSERT TRIGGER called on %', TG_TABLE_NAME;
  PERFORM pg_notify('users_insert', json_build_object('table', TG_TABLE_NAME,
                                                      'id', NEW.id,
                                                      'name', NEW.name,
                                                      'type', TG_OP)::text);
  RETURN NEW;
END;
$$;


--
-- Name: notify_on_users_update_function(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION notify_on_users_update_function() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
  RAISE NOTICE 'UPDATE TRIGGER called on %', TG_TABLE_NAME;
  PERFORM pg_notify('users_update', json_build_object('table', TG_TABLE_NAME,
                                                      'id', NEW.id,
                                                      'new_name', NEW.name,
                                                      'old_name', OLD.name,
                                                      'type', TG_OP)::text);
  RETURN NEW;
END;
$$;


SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: schema_migrations; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE schema_migrations (
    version character varying NOT NULL
);


--
-- Name: users; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE users (
    id integer NOT NULL,
    name character varying
);


--
-- Name: users_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE users_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE users_id_seq OWNED BY users.id;


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY users ALTER COLUMN id SET DEFAULT nextval('users_id_seq'::regclass);


--
-- Name: users_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: unique_schema_migrations; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX unique_schema_migrations ON schema_migrations USING btree (version);


--
-- Name: user_deleted; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER user_deleted BEFORE DELETE ON users FOR EACH ROW EXECUTE PROCEDURE notify_on_users_delete_function();


--
-- Name: user_inserted; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER user_inserted BEFORE INSERT ON users FOR EACH ROW EXECUTE PROCEDURE notify_on_users_insert_function();


--
-- Name: user_updated; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER user_updated BEFORE UPDATE ON users FOR EACH ROW EXECUTE PROCEDURE notify_on_users_update_function();


--
-- PostgreSQL database dump complete
--

SET search_path TO "$user",public;



