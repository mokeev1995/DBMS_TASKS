CREATE OR REPLACE FUNCTION get_student_marks(student_id INTEGER) RETURNS TABLE(id INTEGER, mark INTEGER) AS $$
DECLARE
	sheet_record RECORD;

BEGIN
	DROP TABLE IF EXISTS marks;
	CREATE TEMP TABLE marks(id INTEGER, mark INTEGER) ON COMMIT DROP;

	FOR sheet_record IN
			SELECT
				sheet.id AS sheet,
				result
			FROM academicrecord
				RIGHT JOIN sheet
					ON academicrecord.sheet = sheet.id
				LEFT JOIN curriculum
					ON sheet.curriculum = curriculum.id
			WHERE
				has_exam = FALSE
					AND
				sheet.student = student_id
	LOOP
		INSERT INTO marks(id, mark) VALUES (sheet_record.sheet, CASE WHEN sheet_record.result = TRUE THEN 5 ELSE 2 END);
	END LOOP;

	FOR sheet_record IN
			SELECT
				sheet.id AS sheet,
				result
			FROM examinationlist
				RIGHT JOIN sheet
					ON examinationlist.sheet = sheet.id
				LEFT JOIN curriculum
					ON sheet.curriculum = curriculum.id
			WHERE
				has_exam = TRUE
					AND
				sheet.student = student_id
	LOOP
		INSERT INTO marks(id, mark) VALUES (sheet_record.sheet, CASE WHEN sheet_record.result IS NOT NULL THEN sheet_record.result ELSE 2 END);
	END LOOP;


	RETURN QUERY SELECT * FROM marks;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION get_students_without_bad_marks() RETURNS TABLE(id INTEGER) AS $$
DECLARE
	student_record RECORD;
	student_bad_marks_count INTEGER;
BEGIN
	CREATE TEMP TABLE students(id INTEGER) ON COMMIT DROP;
	CREATE TEMP TABLE student_marks(mark INTEGER) ON COMMIT DROP;

	FOR student_record IN SELECT * FROM student LOOP
		INSERT INTO student_marks(mark)
			SELECT get_student_marks.mark
			FROM get_student_marks(student_record.id);

		SELECT
			count(mark) INTO student_bad_marks_count
		FROM
			student_marks
		WHERE
			mark = 2
				OR
			mark = 3;

		IF student_bad_marks_count = 0 THEN
			INSERT INTO students(id) VALUES (student_record.id);
		END IF;

		TRUNCATE student_marks;
	END LOOP;

	RETURN QUERY SELECT students.id FROM students;
END;
$$ LANGUAGE plpgsql;

SELECT
	name,
	COUNT(student.id)
FROM
	get_students_without_bad_marks()
	LEFT JOIN student
		ON get_students_without_bad_marks.id = student.id
	LEFT JOIN studentsgroup
		ON student.students_group = studentsgroup.id
GROUP BY name;