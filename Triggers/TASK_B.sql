CREATE OR REPLACE FUNCTION next_course_for_students() RETURNS TRIGGER AS $$
DECLARE
	err_count INTEGER DEFAULT 0;
BEGIN
	WITH students AS (
		SELECT
			student.id
		FROM
			student
		WHERE
			student.students_group = new.id
	)
	SELECT
		count(*) INTO err_count
	FROM
		academicrecord
		LEFT JOIN sheet
			ON academicrecord.sheet = sheet.id
		LEFT JOIN students
			ON sheet.student = students.id;

	IF err_count > 0 THEN
		RAISE EXCEPTION 'CAN NOT INCREASE COURSE BECAUSE OF STUDENT WITH UNHEEDED EXAM';
	END IF;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER next_course_for_students_trigger
	AFTER UPDATE ON studentsgroup
	FOR EACH ROW
	EXECUTE PROCEDURE next_course_for_students();