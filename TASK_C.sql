CREATE OR REPLACE FUNCTION get_mark_for_sheet(sheet_id INTEGER) RETURNS TABLE(id INTEGER, mark INTEGER) AS $$
DECLARE
	mark INTEGER;
BEGIN
	SELECT
		CASE WHEN result = TRUE
			THEN 5
			ELSE 2
		END INTO mark
	FROM
		sheet RIGHT JOIN academicrecord
			ON sheet.id = academicrecord.sheet
	WHERE
		sheet.id = $1
	LIMIT 1;

	IF mark IS NULL THEN
		SELECT
			result INTO mark
		FROM
			sheet RIGHT JOIN examinationlist
				ON sheet.id = examinationlist.sheet
		WHERE
			sheet.id = $1
		LIMIT 1;
	END IF;

	IF mark IS NULL THEN
		RETURN QUERY SELECT $1 AS id, 2 AS mark;
	ELSE
		RETURN QUERY SELECT  $1 AS id, mark AS mark;
	END IF;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION iterate_sheets() RETURNS TABLE(id INTEGER, mark INTEGER) AS $iteration$
DECLARE
	sheet_data RECORD;
BEGIN
	CREATE TEMP TABLE result_items(id INTEGER, mark INTEGER) ON COMMIT DROP;

	FOR sheet_data IN SELECT * FROM sheet
	LOOP
		INSERT INTO result_items(id, mark)
			SELECT
				item.id,
				item.mark
			FROM
				get_mark_for_sheet(sheet_data.id) AS item;
	END LOOP;

	RETURN QUERY
		SELECT
			result_items.id,
			result_items.mark
		FROM
			result_items;
END;
$iteration$ LANGUAGE plpgsql;

WITH data AS (
	SELECT
		iterate_sheets.id as sheet_id,
		subject.name AS subject,
		mark
	FROM
		iterate_sheets()
		LEFT JOIN sheet
			ON iterate_sheets.id = sheet.id
		LEFT JOIN curriculum
			ON sheet.curriculum = curriculum.id
		LEFT JOIN subject
			ON curriculum.subject = subject.id
)
SELECT
	subject,
	AVG(mark) AS average_mark
FROM
	data
GROUP BY
	subject
HAVING
	AVG(mark) > 4

UNION

SELECT
	subject,
	AVG(mark) AS average_mark
FROM
	data
GROUP BY
	subject
HAVING
	AVG(mark) < 3.2;