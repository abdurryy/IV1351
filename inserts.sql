INSERT INTO person (personnummer, first_name, last_name, phone_number, address)
VALUES
  ('850716-9541','Unity','Aline','050-954-2518','571-1803 Ut, Street'),
  ('690515-4305','Vincent','Ila','012-637-2222','Ap #443-5429 Libero St.'),
  ('040201-1234','Alexa','Jin','042-219-4453','5286 Aliquet Street'),
  ('760216-5552','Hayley','Eleanor','024-883-7724','140-8122 Euismod St.'),
  ('760216-5552','Marcus','Adams','071-284-5964','671 Non St.');

INSERT INTO job_title (job_title)
VALUES
  ('Library-management'),
  ('Principal'),
  ('Professor');

INSERT INTO department (department_name, person_id)
VALUES
  ('Department-of-Chemistry', 5),
  ('Department-of-Physics', 5),
  ('Department-of-Biology', 5),
  ('Department-of-IT', 5),
  ('Department-of-Math', 5);

INSERT INTO employee (person_id, salary, employee_id, supervisor_id, department_id, job_title)
VALUES
  (1, 34532, 1418, 1, 4, 'Library-management'),
  (2, 35194, 1656, 2, 5, 'Professor'),
  (3, 32338, 1835, 3, 1, 'Professor'),
  (4, 38639, 1296, 5, 2, 'Professor'),
  (5, 47559, 1588, NULL, 3, 'Principal');

INSERT INTO skill_set (person_id, skill)
VALUES
    (1, 'Communications'),
    (1, 'Administration'),

    (2, 'Mathematics'),
    (2, 'Programming'),

    (3, 'Physics'),
    (3, 'Lab Work'),

    (4, 'Chemistry'),
    (4, 'Safety'),

    (5, 'Leadership'),
    (5, 'Management'),
    (5, 'Budgeting'),
	(5, 'Communications');

INSERT INTO salary_history (person_id, salary, valid_from, valid_to)
VALUES
  (5, 20000, '2023-01-01', '2023-12-31'),
  (5, 22000, '2024-01-01', '2024-12-31'),
  (5, 25000, '2025-01-01', NULL);

INSERT INTO course_layout (course_code, course_name, min_student, max_student, hp, version_id)
VALUES
  ('SF3642','Topologi',50,80,7.5,1),
  ('SF3641','Matematisk-statistik',45,170,7.5,1),
  ('SF2621','Fourier-och-Laplace-transform',50,115,7.5,1),
  ('SF1626','Partiella-differentialekvationer',50,170,7.5,1),
  ('SF3646','Differentialekvationer',55,150,7.5, 1),
  ('SF3642', 'Topologi', 75, 100, 15, 2);
/* */

INSERT INTO course_instance (num_students, course_code, study_period, study_year, version_id)
VALUES
  (71,'SF3642','P1',2022,1),
  (161,'SF3642','P2',2022,2),
  (57,'SF2621','P1',2020,1),
  (69,'SF1626','P4',2023,1),
  (107,'SF3646','P3',2021,1);
/* */

INSERT INTO teaching_activity (activity_name, factor)
VALUES
  ('Workshop',3),
  ('Workshop',6),
  ('Lecture',6),
  ('Tutorial',2),
  ('Workshop',2);
/* */

INSERT INTO planned_activity (planned_hours, activity_id, course_instance_id)
VALUES
  (85, 1, 1),
  (102, 2, 2),
  (111, 3, 3),
  (98, 4, 4),
  (60, 5, 5);

INSERT INTO allocation VALUES (1, 1, 1, 10);
INSERT INTO allocation VALUES (2, 2, 1, 10);
INSERT INTO allocation VALUES (3, 3, 1, 10);
INSERT INTO allocation VALUES (4, 4, 2, 10);

SELECT
    a.course_instance_id,
    ci.course_code,
    ci.study_period,
    a.activity_id,
    ta.activity_name,
    a.person_id,
    p.first_name,
    p.last_name,
    a.allocation_hours
FROM allocation a
JOIN course_instance ci ON ci.id = a.course_instance_id
JOIN teaching_activity ta ON ta.id = a.activity_id
JOIN employee e ON e.person_id = a.person_id
JOIN person p ON p.id = e.person_id
ORDER BY a.course_instance_id, a.activity_id, a.person_id;
