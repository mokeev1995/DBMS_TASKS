-- get_student_marks из task d

CREATE OR REPLACE FUNCTION get_students_with_only_5() RETURNS TABLE(id INTEGER) AS $$
DECLARE
	student_record RECORD;
	student_bad_marks_count INTEGER;
BEGIN
	DROP TABLE IF EXISTS students;
	DROP TABLE IF EXISTS student_marks;

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
			mark < 5;

		IF student_bad_marks_count = 0 THEN
			INSERT INTO students(id) VALUES (student_record.id);
		END IF;

		TRUNCATE student_marks;
	END LOOP;

	RETURN QUERY SELECT students.id FROM students;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION get_students_with_only_2() RETURNS TABLE(id INTEGER) AS $$
DECLARE
	student_record RECORD;
	student_good_marks_count INTEGER;
BEGIN
	DROP TABLE IF EXISTS students;
	DROP TABLE IF EXISTS student_marks;

	CREATE TEMP TABLE students(id INTEGER) ON COMMIT DROP;
	CREATE TEMP TABLE student_marks(mark INTEGER) ON COMMIT DROP;

	FOR student_record IN SELECT * FROM student LOOP
		INSERT INTO student_marks(mark)
			SELECT get_student_marks.mark
			FROM get_student_marks(student_record.id);

		SELECT
			count(mark) INTO student_good_marks_count
		FROM
			student_marks
		WHERE
			mark > 2;

		IF student_good_marks_count = 0 THEN
			INSERT INTO students(id) VALUES (student_record.id);
		END IF;

		TRUNCATE student_marks;
	END LOOP;

	RETURN QUERY SELECT students.id FROM students;
END;
$$ LANGUAGE plpgsql;

WITH bad AS (
	SELECT
		name,
		COUNT(student.id) AS bad_marks
	FROM
		get_students_with_only_2()
		LEFT JOIN student
			ON get_students_with_only_2.id = student.id
		LEFT JOIN studentsgroup
			ON student.students_group = studentsgroup.id
	GROUP BY
		name
), good AS (
	SELECT
		name,
		COUNT(student.id) AS good_marks
	FROM
		get_students_with_only_5()
		LEFT JOIN student
			ON get_students_with_only_5.id = student.id
		LEFT JOIN studentsgroup
			ON student.students_group = studentsgroup.id
	GROUP BY
		name
)
SELECT
	good.name,
	CASE WHEN good_marks IS NOT NULL
		THEN good_marks
		ELSE 0
	END AS with_good_marks,
	CASE WHEN bad_marks IS NOT NULL
		THEN bad_marks
		ELSE 0
	END AS with_bad_marks
FROM
	bad FUll JOIN good
		ON bad.name = good.name;