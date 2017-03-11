CREATE OR REPLACE FUNCTION get_average_hours(OUT average INTEGER)
	RETURNS INTEGER AS $$
BEGIN
	SELECT
		AVG(hours_amount) INTO average
	FROM
		curriculum;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION get_subjects_with_low_hours()
	RETURNS TABLE(subject_id INTEGER, hours INTEGER) AS $$
DECLARE
	average_hours_count INTEGER;
	curriculum_record RECORD;
BEGIN
	SELECT get_average_hours() INTO average_hours_count;

	DROP TABLE IF EXISTS temp_subjects;
	CREATE TEMP TABLE temp_subjects(subject_id INTEGER, hours INTEGER) ON COMMIT DROP;

	FOR curriculum_record IN SELECT subject, SUM(hours_amount) AS subj_hours FROM curriculum GROUP BY subject LOOP
		IF curriculum_record.subj_hours < average_hours_count THEN
			INSERT INTO temp_subjects VALUES (curriculum_record.subject, curriculum_record.subj_hours);
		END IF;
	END LOOP;

	RETURN QUERY SELECT DISTINCT * FROM temp_subjects;
END;
$$ LANGUAGE plpgsql;

SELECT * FROM get_subjects_with_low_hours();