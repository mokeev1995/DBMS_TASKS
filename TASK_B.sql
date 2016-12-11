CREATE VIEW TaskB AS (
	WITH hours AS (
		SELECT
			professor_id,
			CASE WHEN Curriculum.has_exam = TRUE
				THEN Curriculum.hours_amount
			ELSE 0
			END AS exam_hours,
			CASE WHEN Curriculum.has_exam = FALSE
				THEN Curriculum.hours_amount
			ELSE 0
			END AS academic_hours
		FROM
			Curriculum
	), data AS (
		SELECT
			professor_id,
			SUM(exam_hours)     AS sum_exam_hours,
			SUM(academic_hours) AS sum_academic_hours
		FROM
			hours
		GROUP BY
			professor_id
	)
	SELECT
		Person.name,
		Person.surname,
		Person.middlename,
		Department.name AS department,
		sum_exam_hours,
		sum_academic_hours
	FROM
		data
		JOIN Professor
			ON data.professor_id = Professor.id
		JOIN Person
			ON Person.id = Professor.id
		JOIN Department
			ON Department.id = Professor.department
);

SELECT * FROM TaskB;