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
		72 AS hours_amount,
		Professor.id AS professor_id,
		FALSE AS has_exam
	FROM
		Subject,
		Specialty,
		Professor JOIN Person ON Person.id = Professor.person
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
		FALSE
	FROM
		Subject,
		Specialty,
		Professor JOIN Person ON Person.id = Professor.person
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
		TRUE
	FROM
		Subject,
		Specialty,
		Professor JOIN Person ON Person.id = Professor.person
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
		1,
		1,
		Specialty.id AS speciality,
		140,
		Professor.id AS professor_id,
		TRUE
	FROM
		Subject,
		Specialty,
		Professor JOIN Person ON Person.id = Professor.person
	WHERE
		Subject.name = 'СУБД'
			AND
		Specialty.name = 'КБ'
			AND
		Person.name = 'Имя2'
	LIMIT 1;