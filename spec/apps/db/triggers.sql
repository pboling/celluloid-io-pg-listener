CREATE OR REPLACE FUNCTION notify_on_users_insert_function()
  RETURNS trigger AS
$BODY$
BEGIN
  RAISE NOTICE 'INSERT TRIGGER called on %', TG_TABLE_NAME;
  PERFORM pg_notify('users_insert', json_build_object('table', TG_TABLE_NAME, 'id', NEW.id, 'name', NEW.name, 'type', TG_OP)::text);
  RETURN NEW;
END;
$BODY$
LANGUAGE plpgsql VOLATILE
COST 100;

CREATE OR REPLACE FUNCTION notify_on_users_update_function()
  RETURNS trigger AS
$BODY$
BEGIN
  RAISE NOTICE 'UPDATE TRIGGER called on %', TG_TABLE_NAME;
  PERFORM pg_notify('users_update', json_build_object('table', TG_TABLE_NAME, 'id', NEW.id, 'name', NEW.name, 'type', TG_OP)::text);
  RETURN NEW;
END;
$BODY$
LANGUAGE plpgsql VOLATILE
COST 100;

CREATE OR REPLACE FUNCTION notify_on_users_delete_function()
  RETURNS trigger AS
$BODY$
BEGIN
  RAISE NOTICE 'DELETE TRIGGER called on %', TG_TABLE_NAME;
  PERFORM pg_notify('users_delete', json_build_object('table', TG_TABLE_NAME, 'id', OLD.id, 'name', OLD.name, 'type', TG_OP)::text);
  RETURN NEW;
END;
$BODY$
LANGUAGE plpgsql VOLATILE
COST 100;
