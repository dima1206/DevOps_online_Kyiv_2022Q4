-- 4. Create database

CREATE DATABASE uni; USE uni;


-- 5. Create tables

CREATE TABLE teachers (
	teacher_id INT NOT NULL,
	first_name VARCHAR(255) NOT NULL,
	last_name VARCHAR(255) NOT NULL,
	birthday DATE,
	PRIMARY KEY (teacher_id)
);

CREATE TABLE subjects (
	subject_id INT NOT NULL,
	title VARCHAR(255) NOT NULL,
	teacher_id INT NOT NULL,
	PRIMARY KEY (subject_id),
	FOREIGN KEY (teacher_id) REFERENCES teachers(teacher_id)
);

CREATE TABLE students (
	student_id INT NOT NULL,
	first_name VARCHAR(255) NOT NULL,
	last_name VARCHAR(255) NOT NULL,
	birthday DATE,
	PRIMARY KEY (student_id)
);

CREATE TABLE scores (
	student_id INT NOT NULL,
	subject_id INT NOT NULL,
	score INT CHECK (score >= 0 AND score <= 100),
	PRIMARY KEY (student_id, subject_id),
	FOREIGN KEY (student_id) REFERENCES students(student_id),
	FOREIGN KEY (subject_id) REFERENCES subjects(subject_id)
);


-- 5. Fill in tables

INSERT INTO teachers (teacher_id, first_name, last_name, birthday)
VALUES
(1, 'Ivan', 'Ivanov', '1990-1-1'),
(2, 'Petro', 'Petrov', '1985-5-6');

INSERT INTO subjects (subject_id, title, teacher_id)
VALUES
(1, 'Databases', 2),
(2, 'AWS', 1),
(3, 'Linux', 2);

INSERT INTO students (student_id, first_name, last_name, birthday)
VALUES
(1, 'Vasya', 'Pupkin', '2001-3-1'),
(2, 'Ivan', 'Sidorov', '2002-4-6');

INSERT INTO scores (student_id, subject_id, score)
VALUES
(1, 1, 100),
(1, 2, 96),
(1, 3, 94),
(2, 1, 60),
(2, 2, 0);


-- 6. Complex select

SELECT student_id, SUM(score) AS total
FROM scores
WHERE student_id < 10
GROUP BY student_id
ORDER BY total DESC;


-- 7. Different types of queries

-- DDL
ALTER TABLE subjects
ADD (note VARCHAR(255));

-- DML
UPDATE subjects
SET note = 'Amazon Web Services'
WHERE subject_id = 1;

-- DQL
SELECT * FROM subjects;

-- DDL
CREATE USER 'user'@'localhost' IDENTIFIED BY 'fpA&4!N88';

-- DCL
GRANT ALL PRIVILEGES ON uni.* TO 'user'@'localhost';

FLUSH PRIVILEGES;


-- 8. Users and privileges

-- Create users and grant perms
CREATE USER 'ro'@'localhost' IDENTIFIED BY '4Y$%TT96h';
CREATE USER 'scores'@'localhost' IDENTIFIED BY '5Y01TgC*&';
GRANT SELECT ON uni.* TO 'ro'@'localhost';
GRANT SELECT ON uni.* TO 'scores'@'localhost';
GRANT DELETE,INSERT,UPDATE ON uni.scores to 'scores'@'localhost';
FLUSH PRIVILEGES;

-- Check perms under ro user
SELECT * FROM scores;  -- works
UPDATE scores SET score = 100 WHERE student_id = 2; -- fails

-- Check perms under scores user
DROP TABLE scores;  -- fails
UPDATE scores SET score = 61 WHERE student_id = 2 AND subject_id = 2; -- works
SELECT * FROM scores;  -- works


-- 9. Select from main db
SELECT host,db,user FROM mysql.db;
