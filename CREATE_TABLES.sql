CREATE TABLE IF NOT EXISTS public.Specialty
(
	id				SERIAL	NOT NULL	PRIMARY KEY,
	name			TEXT	NOT NULl	UNIQUE
);

CREATE TABLE IF NOT EXISTS public.Subject
(
	id				SERIAL	NOT NULL	PRIMARY KEY,
	name			TEXT	NOT NULL
);

CREATE TABLE IF NOT EXISTS public.Person
(
	id				SERIAL	NOT NULL	PRIMARY KEY,
	name			TEXT	NOT NULL,
	surname			TEXT	NOT NULL,
	middlename		TEXT
);

CREATE TABLE IF NOT EXISTS public.StudentsGroup
(
	id				SERIAL	NOT NULL	PRIMARY KEY,
	name			TEXT	NOT NULL	UNIQUE,
	date_start		DATE	NOT NULL,
	date_finish		DATE	NOT NULL,
	specialty		INTEGER	NOT NULL	REFERENCES public.Specialty (id)		ON UPDATE CASCADE 	ON DELETE CASCADE,
	course			INTEGER	NOT NULL

);

CREATE TABLE IF NOT EXISTS public.Student
(
	id				SERIAL	NOT NULL	PRIMARY KEY,
	person			INTEGER	NOT NULL	REFERENCES public.Person (id)			ON UPDATE CASCADE	ON DELETE CASCADE,
	students_group	INTEGER	NOT NULL	REFERENCES public.StudentsGroup (id)	ON UPDATE CASCADE	ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS public.Department
(
	id				SERIAL	NOT NULL	PRIMARY KEY,
	name			TEXT	NOT NULL
);

CREATE TABLE IF NOT EXISTS public.Professor
(
	id				SERIAL	NOT NULL	PRIMARY KEY,
	person			INTEGER	NOT NULL	REFERENCES public.Person (id)			ON UPDATE CASCADE	ON DELETE CASCADE,
	department		INTEGER	NOT NULL	REFERENCES public.Department (id)		ON UPDATE CASCADE	ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS public.Curriculum
(
	id				SERIAL	NOT NULL	PRIMARY KEY,
	subject			INTEGER	NOT NULL	REFERENCES public.Subject (id)			ON UPDATE CASCADE	ON DELETE CASCADE,
	semester		INTEGER	NOT NULL	CHECK (semester IN (1,2)),
	course			INTEGER	NOT NULL	CHECK (course > 0 AND course < 7),
	specialty		INTEGER	NOT NULL	REFERENCES public.Specialty (id)		ON UPDATE CASCADE	ON DELETE CASCADE,
	hours_amount	INTEGER	NOT NULL	CHECK (hours_amount > 0),
	professor_id	INTEGER	NOT NULL	REFERENCES public.Professor (id)		ON UPDATE CASCADE	ON DELETE CASCADE,
	has_exam		BOOLEAN NOT NULL	DEFAULT FALSE
);

CREATE TABLE IF NOT EXISTS public.Sheet
(
	id				SERIAL	NOT NULL 	PRIMARY KEY,
	student			INTEGER	NOT NULL	REFERENCES public.Student (id)			ON UPDATE CASCADE	ON DELETE CASCADE,
	curriculum		INTEGER	NOT NULL	REFERENCES public.Curriculum (id)		ON UPDATE CASCADE	ON DELETE CASCADE,
	date			DATE	NOT NULL
);

CREATE TABLE IF NOT EXISTS public.AcademicRecord
(
	id				SERIAL	NOT NULL	PRIMARY KEY,
	sheet			INTEGER	NOT NULL	REFERENCES public.Sheet (id)			ON UPDATE CASCADE	ON DELETE CASCADE,
	result			BOOLEAN	NOT NULL,
	date			DATE	NOT NULL	DEFAULT CURRENT_DATE
);

CREATE TABLE IF NOT EXISTS public.ExaminationList
(
	id				SERIAL	NOT NULL	PRIMARY KEY,
	sheet			INTEGER	NOT NULL	REFERENCES public.Sheet (id)			ON UPDATE CASCADE	ON DELETE CASCADE,
	result			INTEGER	NOT NULL	CHECK (result > 0 AND result < 6),
	date			DATE	NOT NULL	DEFAULT CURRENT_DATE
);

CREATE TABLE IF NOT EXISTS public.ProfessorSubject
(
	id				SERIAL 	NOT NULL 	PRIMARY KEY,
	professor		INTEGER	NOT NULL	REFERENCES public.Professor (id)		ON UPDATE CASCADE 	ON DELETE CASCADE,
	subject			INTEGER	NOT NULL	REFERENCES public.Subject (id)			ON UPDATE CASCADE 	ON DELETE CASCADE
);