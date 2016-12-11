INSERT INTO Subject(name) VALUES
	('Дискретная математика'),
	('Алгебра'),
	('Теория вероятностей'),
	('Сети и системы передачи информации'),
	('Аналитическая геометрия'),
	('Схемотехника и электроника'),
	('СУБД'),
	('Основы ИБ'),
	('Математический анализ');

INSERT INTO Department(name) VALUES
	('Кафедра математического анализа'),
	('Кафедра компьютерной безопасности');

INSERT INTO Person(name, surname, middlename) VALUES
	('Имя1', 'Фамилия1', 'Отчество1'),
	('Имя2', 'Фамилия2', 'Отчество2'),
	('Имя3', 'Фамилия3', 'Отчество3'),
	('Имя4', 'Фамилия4', 'Отчество4'),
	('Имя5', 'Фамилия5', 'Отчество5'),
	('Имя6', 'Фамилия6', 'Отчество6'),
	('Имя7', 'Фамилия7', 'Отчество7');

INSERT INTO Specialty(name) VALUES
	('ПМИ'),
	('КБ'),
	('МКН'),
	('ИБ');

INSERT INTO Professor(person, department)
	SELECT
		Person.id AS person_id,
		Department.id as department_id
	FROM
		Person,
		Department
	WHERE
		Person.name = 'Имя1'
			AND
		Department.name = 'Кафедра компьютерной безопасности'
	LIMIT 1;
INSERT INTO Professor(person, department)
	SELECT
		Person.id AS person_id,
		Department.id as department_id
	FROM
		Person,
		Department
	WHERE
		Person.name = 'Имя2'
			AND
		Department.name = 'Кафедра математического анализа'
	LIMIT 1;

INSERT INTO StudentsGroup(name, date_start, date_finish, specialty, course)
	SELECT 'ПМИ-2016', '2013-09-01', '2017-05-31', id, 1 FROM Specialty WHERE name = 'ПМИ' LIMIT 1;
INSERT INTO StudentsGroup(name, date_start, date_finish, specialty, course)
	SELECT 'КБ-2013', '2013-09-01', '2019-03-31', id, 4 FROM Specialty WHERE name = 'КБ' LIMIT 1;
INSERT INTO StudentsGroup(name, date_start, date_finish, specialty, course)
	SELECT 'МКН-2016', '2013-09-01', '2017-05-31', id, 1 FROM Specialty WHERE name = 'МКН' LIMIT 1;

INSERT INTO Student(person, students_group)
	SELECT
		Person.id AS person,
		StudentsGroup.id AS students_group
	FROM
		Person,
		StudentsGroup
	WHERE
		Person.name = 'Имя3'
			AND
		StudentsGroup.name = 'КБ-2013'
	LIMIT 1;
INSERT INTO Student(person, students_group)
	SELECT
		Person.id AS person,
		StudentsGroup.id AS students_group
	FROM
		Person,
		StudentsGroup
	WHERE
		Person.name = 'Имя4'
			AND
		StudentsGroup.name = 'КБ-2013'
	LIMIT 1;
INSERT INTO Student(person, students_group)
	SELECT
		Person.id AS person,
		StudentsGroup.id AS students_group
	FROM
		Person,
		StudentsGroup
	WHERE
		Person.name = 'Имя5'
			AND
		StudentsGroup.name = 'КБ-2013'
	LIMIT 1;
INSERT INTO Student(person, students_group)
	SELECT
		Person.id AS person,
		StudentsGroup.id AS students_group
	FROM
		Person,
		StudentsGroup
	WHERE
		Person.name = 'Имя6'
			AND
		StudentsGroup.name = 'ПМИ-2016'
	LIMIT 1;
INSERT INTO Student(person, students_group)
	SELECT
		Person.id AS person,
		StudentsGroup.id AS students_group
	FROM
		Person,
		StudentsGroup
	WHERE
		Person.name = 'Имя7'
			AND
		StudentsGroup.name = 'МКН-2016'
	LIMIT 1;

INSERT INTO Curriculum(subject, semester, course, specialty, hours_amount, professor_id, has_exam)
	SELECT
		Subject.id AS subject,
		1 AS semester,
		1 AS course,
		Specialty.id AS speciality,
		140 AS hours_amount,
		Professor.id AS professor_id,
		TRUE AS has_exam
	FROM
		Subject,
		Specialty,
		Professor JOIN Person
			ON Person.id = Professor.person
	WHERE
		Subject.name = 'Алгебра'
			AND
		Specialty.name = 'ПМИ'
			AND
		Person.name = 'Имя1'
	LIMIT 1;
INSERT INTO Curriculum(subject, semester, course, specialty, hours_amount, professor_id, has_exam)
	SELECT
		Subject.id AS subject,
		1,
		1,
		Specialty.id AS speciality,
		72,
		Professor.id AS professor_id,
		FALSE AS has_exam
	FROM
		Subject,
		Specialty,
		Professor JOIN Person
			ON Person.id = Professor.person
	WHERE
		Subject.name = 'Математический анализ'
			AND
		Specialty.name = 'ПМИ'
			AND
		Person.name = 'Имя2'
	LIMIT 1;
INSERT INTO Curriculum(subject, semester, course, specialty, hours_amount, professor_id, has_exam)
	SELECT
		Subject.id AS subject,
		1,
		1,
		Specialty.id AS speciality,
		140,
		Professor.id AS professor_id,
		FALSE AS has_exam
	FROM
		Subject,
		Specialty,
		Professor JOIN Person
			ON Person.id = Professor.person
	WHERE
		Subject.name = 'Дискретная математика'
			AND
		Specialty.name = 'КБ'
			AND
		Person.name = 'Имя2'
	LIMIT 1;
INSERT INTO Curriculum(subject, semester, course, specialty, hours_amount, professor_id, has_exam)
	SELECT
		Subject.id AS subject,
		1 AS semester,
		4 AS course,
		Specialty.id AS speciality,
		140 AS hours_amount,
		Professor.id AS professor_id,
		FALSE AS has_exam
	FROM
		Subject,
		Specialty,
		Professor JOIN Person
			ON Person.id = Professor.person
	WHERE
		Subject.name = 'СУБД'
			AND
		Specialty.name = 'КБ'
			AND
		Person.name = 'Имя2'
	LIMIT 1;

INSERT INTO Sheet(student, curriculum, date)
	SELECT
		Student.id AS student,
		Curriculum.id AS curriculumm,
		'2016-12-31' AS date
	FROM
		Student LEFT JOIN Person
			ON Student.person = Person.id,
		Curriculum LEFT JOIN subject
			ON Curriculum.subject = Subject.id
	WHERE
		Person.name = 'Имя3'
			AND
		Subject.name = 'СУБД'
			AND
		curriculum.course = 4
			AND
		curriculum.semester = 1
	LIMIT 1;
INSERT INTO Sheet(student, curriculum, date)
	SELECT
		Student.id AS student,
		Curriculum.id AS curriculumm,
		'2016-12-31' AS date
	FROM
		Student LEFT JOIN Person
			ON Student.person = Person.id,
		Curriculum LEFT JOIN subject
			ON Curriculum.subject = Subject.id
	WHERE
		Person.name = 'Имя4'
			AND
		Subject.name = 'СУБД'
			AND
		curriculum.course = 4
			AND
		curriculum.semester = 1
	LIMIT 1;
INSERT INTO Sheet(student, curriculum, date)
	SELECT
		Student.id AS student,
		Curriculum.id AS curriculumm,
		'2016-12-31' AS date
	FROM
		Student LEFT JOIN Person
			ON Student.person = Person.id,
		Curriculum LEFT JOIN subject
			ON Curriculum.subject = Subject.id
	WHERE
		Person.name = 'Имя5'
			AND
		Subject.name = 'СУБД'
			AND
		curriculum.course = 4
			AND
		curriculum.semester = 1
	LIMIT 1;
INSERT INTO Sheet(student, curriculum, date)
	SELECT
		Student.id AS student,
		Curriculum.id AS curriculumm,
		'2016-12-31' AS date
	FROM
		Student LEFT JOIN Person
			ON Student.person = Person.id,
		Curriculum LEFT JOIN subject
			ON Curriculum.subject = Subject.id
	WHERE
		Person.name = 'Имя6'
			AND
		Subject.name = 'Алгебра'
			AND
		curriculum.course = 1
			AND
		curriculum.semester = 1
	LIMIT 1;
INSERT INTO Sheet(student, curriculum, date)
	SELECT
		Student.id AS student,
		Curriculum.id AS curriculumm,
		'2016-12-31' AS date
	FROM
		Student LEFT JOIN Person
			ON Student.person = Person.id,
		Curriculum LEFT JOIN subject
			ON Curriculum.subject = Subject.id
	WHERE
		Person.name = 'Имя7'
			AND
		Subject.name = 'Алгебра'
			AND
		curriculum.course = 1
			AND
		curriculum.semester = 1
	LIMIT 1;

INSERT INTO examinationlist (sheet, result, date)
	SELECT
		sheet.id AS sheet,
		5 AS result,
		'2016-12-20' AS date
	FROM
		sheet LEFT JOIN curriculum
			ON sheet.curriculum = curriculum.id
		LEFT JOIN subject
			ON curriculum.subject = subject.id
		LEFT JOIN student
			ON sheet.student = student.id
		LEFT JOIN person
			ON student.person = person.id
	WHERE
		subject.name = 'Алгебра'
			AND
		person.name = 'Имя6'
	LIMIT 1;
INSERT INTO examinationlist (sheet, result, date)
	SELECT
		sheet.id AS sheet,
		4 AS result,
		'2016-12-20' AS date
	FROM
		sheet LEFT JOIN curriculum
			ON sheet.curriculum = curriculum.id
		LEFT JOIN subject
			ON curriculum.subject = subject.id
		LEFT JOIN student
			ON sheet.student = student.id
		LEFT JOIN person
			ON student.person = person.id
	WHERE
		subject.name = 'Алгебра'
			AND
		person.name = 'Имя7'
	LIMIT 1;

INSERT INTO academicrecord (sheet, result, date)
	SELECT
		sheet.id AS sheet,
		TRUE AS result,
		'2016-12-21' AS date
	FROM
		sheet LEFT JOIN curriculum
			ON sheet.curriculum = curriculum.id
		LEFT JOIN subject
			ON curriculum.subject = subject.id
		LEFT JOIN student
			ON sheet.student = student.id
		LEFT JOIN person
			ON student.person = person.id
	WHERE
		subject.name = 'СУБД'
			AND
		person.name = 'Имя4'
	LIMIT 1;