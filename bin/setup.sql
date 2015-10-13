DO
$body$
BEGIN
  IF NOT EXISTS (
      SELECT *
      FROM   pg_catalog.pg_user
      WHERE  usename = 'foss') THEN

    CREATE ROLE foss WITH CREATEDB LOGIN;
  END IF;
END
$body$
