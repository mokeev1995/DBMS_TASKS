CREATE OR REPLACE FUNCTION get_professors_ids_with_winter_exams()
	RETURNS TABLE(professor_id INTEGER) AS $$
BEGIN
	DROP TABLE IF EXISTS temp_professors;
	CREATE TEMP TABLE temp_professors(professor_id INTEGER) ON COMMIT DROP;

	INSERT INTO temp_professors(professor_id) (
		SELECT
			*
		FROM
			curriculum
		WHERE
			mod(curriculum.semester, 2) = 1
	);

	RETURN QUERY SELECT DISTINCT * FROM temp_professors;
END;
$$ LANGUAGE plpgsql;

SELECT
	*
FROM
	get_professors_ids_with_winter_exams() AS data
		LEFT JOIN professor ON data.professor_id =  professor.id
		LEFT JOIN person ON professor.person = person.id;