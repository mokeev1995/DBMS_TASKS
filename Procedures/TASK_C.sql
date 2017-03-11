CREATE OR REPLACE FUNCTION get_hours(prof_name TEXT, prof_surname TEXT, prof_middlename TEXT)
	RETURNS INTEGER AS $$
DECLARE
	found_professor_id INTEGER;
	hours_count INTEGER;
BEGIN

	found_professor_id := -1;
	hours_count := 0;

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
		RAISE 'Professor was not found.';
	END IF;

	SELECT
		SUM(curriculum.hours_amount) INTO hours_count
	FROM
		curriculum
	WHERE
		curriculum.professor_id = found_professor_id;

	RETURN hours_count;
END;
$$ LANGUAGE plpgsql;

SELECT
	*,
	get_hours(public.person.name, public.person.surname, public.person.middlename)
FROM
	professor LEFT JOIN person
		ON professor.person = person.id