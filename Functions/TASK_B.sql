CREATE OR REPLACE FUNCTION get_bad_counts()
	RETURNS TABLE(curriculum_id INTEGER, course INTEGER, speciality INTEGER) AS $$
BEGIN
	RETURN QUERY (
	SELECT
		curriculum.id AS curriculum_id,
		curriculum.course,
		curriculum.specialty
	FROM
		examinationlist
		LEFT JOIN sheet
			ON examinationlist.sheet = sheet.id
		LEFT JOIN curriculum
			ON sheet.curriculum = curriculum.id
	WHERE
		examinationlist.result = '2'
	GROUP BY
		curriculum.id,
		curriculum.course,
		curriculum.specialty
	);

END;
$$ LANGUAGE plpgsql;

SELECT * FROM get_bad_counts();