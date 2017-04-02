CREATE OR REPLACE FUNCTION check_mark_before_add() RETURNS TRIGGER AS $$
BEGIN
	RAISE EXCEPTION 'wrong mark';
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER check_mark_before_add_trigger
	BEFORE INSERT ON examinationlist
	FOR EACH ROW
	WHEN (new.result < 2 OR new.result > 5)
	EXECUTE PROCEDURE check_mark_before_add();