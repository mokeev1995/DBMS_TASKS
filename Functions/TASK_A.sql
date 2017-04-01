CREATE OR REPLACE FUNCTION get_subjects_count_for_prof(prof_name TEXT, prof_surname TEXT, prof_middlename TEXT)
	RETURNS INTEGER AS $$
DECLARE
	found_professor_id INTEGER;
	subjects_count INTEGER;
BEGIN
	found_professor_id := -1;
	subjects_count := 0;

	SELECT
		professor.id INTO found_professor_id
	FROM
		person LEFT JOIN professor
			ON person.id = professor.person
	WHERE
		person.name = prof_name AND
		person.surname = prof_surname AND
		person.middlename = prof_middlename;

	IF found_professor_id = -1 THEN
		RAISE EXCEPTION 'Professor was not found.';
	END IF;

	SELECT
		COUNT(*) INTO subjects_count
	FROM
		curriculum
	WHERE
		curriculum.professor_id = found_professor_id;

	RETURN subjects_count;

END;
$$ LANGUAGE plpgsql;

SELECT
	*,
	get_subjects_count_for_prof(public.person.name, public.person.surname, public.person.middlename)
FROM
	professor LEFT JOIN person
		ON professor.person = person.id