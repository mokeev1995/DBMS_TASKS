CREATE OR REPLACE FUNCTION get_results_for_subjects(specialty_name TEXT, course INTEGER)
	RETURNS TABLE(subject_id INTEGER, a_marks_count INTEGER, b_marks_count INTEGER, f_marks_count INTEGER) AS $$
DECLARE
	speciality_id INTEGER DEFAULT -1;
	a_marks_count INTEGER;
	b_marks_count INTEGER;
	f_marks_count INTEGER;
	curriculum_record RECORD;
BEGIN
	DROP TABLE IF EXISTS temp_curriculums;
	CREATE TEMP TABLE temp_curriculums(subject_id INTEGER, curriculum_id INTEGER) ON COMMIT DROP;


	DROP TABLE IF EXISTS temp_marks_counts;
	CREATE TEMP TABLE temp_marks_counts(subject_id INTEGER, a_marks_count INTEGER, b_marks_count INTEGER, f_marks_count INTEGER) ON COMMIT DROP;

	SELECT
		id INTO speciality_id
	FROM
		specialty
	WHERE
		specialty.name = specialty_name;

	IF speciality_id = -1 THEN
		RAISE EXCEPTION 'There is no speciality with name "' + specialty_name + '"';
	END IF;

	-- собираем данные по специальности
	INSERT INTO temp_curriculums
		 SELECT
			 curriculum.subject,
			 curriculum.id
		 FROM
			 curriculum
		 WHERE
			 curriculum.specialty = speciality_id
			 AND curriculum.course = course
			 AND mod(curriculum.semester, 2) = 1
			 AND curriculum.has_exam = TRUE;

	FOR curriculum_record IN SELECT * FROM temp_curriculums LOOP
		a_marks_count := 0;
		b_marks_count := 0;
		f_marks_count := 0;

		SELECT
			COUNT(*) INTO a_marks_count
		FROM
			sheet LEFT JOIN examinationlist ON sheet.id = examinationlist.sheet
		WHERE
			sheet.curriculum = curriculum_record.curriculum_id
			AND examinationlist.result = 5;

		SELECT
			COUNT(*) INTO b_marks_count
		FROM
			sheet LEFT JOIN examinationlist ON sheet.id = examinationlist.sheet
		WHERE
			sheet.curriculum = curriculum_record.curriculum_id
			AND examinationlist.result = 4;

		SELECT
			COUNT(*) INTO f_marks_count
		FROM
			sheet LEFT JOIN examinationlist ON sheet.id = examinationlist.sheet
		WHERE
			sheet.curriculum = curriculum_record.curriculum_id
			AND examinationlist.result = 2;

		INSERT INTO temp_marks_counts(subject_id, a_marks_count, b_marks_count, f_marks_count) VALUES
			(curriculum_record.subject_id, a_marks_count, b_marks_count, f_marks_count);
	END LOOP;

	RETURN QUERY SELECT * FROM temp_marks_counts;

END;
$$ LANGUAGE plpgsql;