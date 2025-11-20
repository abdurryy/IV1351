DROP TABLE IF EXISTS allocation;
DROP TABLE IF EXISTS planned_activity;
DROP TABLE IF EXISTS course_instance;
DROP TABLE IF EXISTS teaching_activity;
DROP TABLE IF EXISTS salary_history;
DROP TABLE IF EXISTS skill_set;
DROP TABLE IF EXISTS employee;
DROP TABLE IF EXISTS department;
DROP TABLE IF EXISTS course_layout;
DROP TABLE IF EXISTS job_title;
DROP TABLE IF EXISTS person;


/* instnance per period needs triggers so that an employee cant have more then */
CREATE TABLE person (
  id SERIAL PRIMARY KEY,
  personnummer CHAR(20) NOT NULL,
  first_name CHAR(20) NOT NULL,
  last_name CHAR(20) NOT NULL,
  phone_number CHAR(15),
  address CHAR(30)
);

CREATE TABLE job_title (
  job_title CHAR(40) NOT NULL PRIMARY KEY
);

CREATE TABLE department (
  department_id SERIAL NOT NULL PRIMARY KEY,
  department_name CHAR(40) NOT NULL,
  person_id INT NOT NULL REFERENCES person(id)
);

CREATE TABLE employee (
  person_id INT NOT NULL PRIMARY KEY REFERENCES person(id),
  salary INT NOT NULL,
  employee_id INT NOT NULL,
  supervisor_id INT REFERENCES person(id),
  department_id INT NOT NULL REFERENCES department(department_id),
  job_title CHAR(40) NOT NULL REFERENCES job_title(job_title)
);

CREATE TABLE skill_set (
	skill CHAR(15) NOT NULL,
	person_id INT NOT NULL REFERENCES employee(person_id),
	PRIMARY KEY (skill , person_id)
);

CREATE TABLE salary_history (
 person_id INT NOT NULL REFERENCES employee(person_id),
 salary INT NOT NULL, 
 valid_from DATE NOT NULL,
 valid_to DATE,
 PRIMARY KEY (person_id, valid_from)
);

CREATE TABLE course_layout (
  course_code CHAR(10) NOT NULL,
  version_id INT NOT NULL,
  course_name CHAR(50) NOT NULL,
  min_student INT NOT NULL,
  hp DECIMAL(3,1) NOT NULL,
  max_student INT NOT NULL,
  PRIMARY KEY (course_code, version_id)
);

CREATE TABLE course_instance (
  id           SERIAL PRIMARY KEY,
  num_students INT NOT NULL,
  study_period CHAR(10) NOT NULL,
  study_year   INT NOT NULL,
  course_code  CHAR(10) NOT NULL,
  version_id   INT NOT NULL,
  FOREIGN KEY (course_code, version_id)
    REFERENCES course_layout(course_code, version_id)
);

CREATE TABLE teaching_activity (
  id            SERIAL NOT NULL PRIMARY KEY,
  activity_name CHAR(40) NOT NULL,
  factor        INTEGER NOT NULL
);

CREATE TABLE planned_activity (
  activity_id        INTEGER NOT NULL REFERENCES teaching_activity(id),
  course_instance_id INTEGER NOT NULL REFERENCES course_instance(id),
  planned_hours      INT NOT NULL,
  PRIMARY KEY (activity_id, course_instance_id)
);

CREATE TABLE allocation (
   activity_id        INT NOT NULL REFERENCES teaching_activity(id),
   course_instance_id INT NOT NULL REFERENCES course_instance(id),
   person_id          INT NOT NULL REFERENCES employee(person_id),
   allocation_hours   INT NOT NULL,
   PRIMARY KEY (activity_id, course_instance_id, person_id)
);


CREATE OR REPLACE FUNCTION checkemployeelimit()
RETURNS TRIGGER AS $$
DECLARE
    instance_count INT;
BEGIN
    SELECT COUNT(DISTINCT course_instance_id)
    INTO instance_count
    FROM allocation
    WHERE person_id = NEW.person_id;
    IF instance_count >= 4 THEN
        RAISE EXCEPTION 'Teacher % cannot be asigned to more instances', NEW.person_id;
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER alt
BEFORE INSERT ON allocation
FOR EACH ROW
EXECUTE FUNCTION checkemployeelimit();
