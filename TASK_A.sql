CREATE VIEW TaskA AS (
	SELECT
		Subject.name
	FROM
		Specialty
			LEFT JOIN Curriculum
				ON specialty = Specialty.id
			LEFT JOIN Subject
				ON Curriculum.subject = Subject.id
	WHERE
		Specialty.name = 'ПМИ'
);

SELECT * FROM TaskA;