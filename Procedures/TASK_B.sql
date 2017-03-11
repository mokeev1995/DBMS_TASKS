CREATE OR REPLACE FUNCTION get_subjects_with_exam_or_test(speciality_id INTEGER, course_number INTEGER, semester_numer INTEGER)
	RETURNS TABLE(subject_id INTEGER) AS $$
BEGIN
	DROP TABLE IF EXISTS temp_subjects;
	CREATE TEMP TABLE temp_subjects(subject_id INTEGER) ON COMMIT DROP;

	INSERT INTO temp_subjects (subject_id) (
		SELECT
			subject as subject_id
		FROM
			curriculum
		WHERE
			curriculum.specialty = speciality_id AND
			curriculum.semester = semester_numer AND
			curriculum.course = course_number
	);

	RETURN QUERY SELECT DISTINCT * FROM temp_subjects;
END;
$$ LANGUAGE plpgsql;

SELECT subject.name FROM get_subjects_with_exam_or_test(2, 4, 1) LEFT JOIN subject ON subject_id = subject.id;