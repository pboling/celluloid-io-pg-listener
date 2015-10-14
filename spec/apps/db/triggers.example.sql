CREATE TRIGGER user_inserted BEFORE INSERT ON users
FOR EACH ROW EXECUTE PROCEDURE notify_on_users_insert_function();

CREATE TRIGGER user_updated BEFORE UPDATE ON users
FOR EACH ROW EXECUTE PROCEDURE notify_on_users_update_function();

CREATE TRIGGER user_deleted BEFORE DELETE ON users
FOR EACH ROW EXECUTE PROCEDURE notify_on_users_delete_function();
