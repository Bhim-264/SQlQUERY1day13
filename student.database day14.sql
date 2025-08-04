use collegeDB;
-- Create Students table
CREATE TABLE Students (
    student_id INT PRIMARY KEY,
    student_name VARCHAR(50),
    email VARCHAR(50),
    major VARCHAR(50),
    enrollment_year INT
);

-- Create Courses table
CREATE TABLE Courses (
    course_id INT PRIMARY KEY,
    course_name VARCHAR(50),
    credit_hours INT,
    department VARCHAR(50)
);

-- Create StudentCourses table for enrollment
CREATE TABLE StudentCourses (
    enrollment_id INT PRIMARY KEY,
    student_id INT,
    course_id INT,
    semester VARCHAR(20),
    grade CHAR(2),
    FOREIGN KEY (student_id) REFERENCES Students(student_id),
    FOREIGN KEY (course_id) REFERENCES Courses(course_id)
);


-- Insert sample data
INSERT INTO Students VALUES 
(1, 'Bhim Debnath', 'john@example.com', 'Computer Science', 2025),
(2, 'Jane Smith', 'jane@example.com', 'Mathematics', 2021),
(3, 'Mike Johnson', 'mike@example.com', 'Physics', 2020);

INSERT INTO Courses VALUES
(101, 'Database Systems', 3, 'CS'),
(102, 'Calculus II', 4, 'MATH'),
(103, 'Quantum Physics', 4, 'PHYSICS');

INSERT INTO StudentCourses VALUES
(1, 1, 101, 'Fall 2023', 'A'),
(2, 1, 102, 'Spring 2024', 'B'),
(3, 2, 102, 'Fall 2023', 'A'),
(4, 3, 103, 'Spring 2024', 'B+');


 Select * From Students , Courses , Studentcourses;

 --simple view
  CREATE VIEW CS_Students AS
  Select student_id , student_name,email
  FROM Students
  Where major = 'computer science';


  Select * From CS_Students;

  --complex view(from multiple table joins)
  --Create VIEW dbo.StudentEnrollments AS
  --SELECT s.student_name,c.course_name,sc.semester,sc.grade
  --FROM dbo.Students s
  --Inner Join dbo.Studentcourse sc on s.student_id = sc.student_id
  --INNER JOIN dbo.Course c ON sc.course_id = c.course_id;

  CREATE VIEW dbo.StudentEnrollments AS
SELECT s.student_name, c.course_name,sc.semester,sc.grade  
FROM Students s
INNER JOIN StudentCourses sc ON s.student_id = sc.student_id
INNER JOIN Courses c ON sc.course_id = c.course_id;

--inner join and join are exactly same
  

  UPDATE StudentCourses
SET grade = 'B'
WHERE student_id = 3 AND course_id = 103;

select * from CS_Students;

SELECT * FROM dbo.StudentEnrollments;
SELECT TOP 2 * FROM dbo.StudentEnrollments;

BEGIN Transaction;
Update dbo.CS_Students
SET Email='bhimdebnath@gmail.com'
WHERE student_id=1;
SELECT * From dbo.CS_Students WHERE student_id=1;
--ROLLBACK TRANSACTION --Undoing Changes

BEGIN TRY
BEGIN Transaction;
UPDATE Studentnrollments
SET grade = 'A+'
WHERE student_name = 'John Doe' AND course_name = 'Database Systems';
COMMIT TRANSACTION;
END TRY
BEGIN CATCH
       ROLLBACK TRANSACTION;
       PRINT 'ERROR occured!!!!!!!' + ERROR_MESSAGE();
END CATCH

IF EXISTS (SELECT * FROM sys.views WHERE name = 'CS_Students' AND schema_ID = SCHEMA_ID('dbo'))
DROP VIEW dbo.CS_Students;


CREATE VIEW CS_Students_New AS
  Select student_id , student_name,email
  FROM Students
  Where major = 'computer science';


  Select * From CS_Students_New;

  -- View Metadata in MS SQL 
-- Get view defination 
 SELECT OBJECT_DEFINITION(OBJECT_ID('dbo.CS_Students_New')) AS ViewDefinition;

 -- List all view in the database 

 SELECT name AS ViewName, create_Date, modify_date 
 FROM sys.views
 WHERE is_ms_shipped = 0
 ORDER BY name;

 --indexing on above table for faster look up 
 CREate NONCLUSTERED INDEX IX_STUDENT_EMAIL on Students(email);--student email
 CREate NONCLUSTERED INDEX IXStudentMajor_Year on Students(major,enrollment_year);

 CREate UNIQUE INDEX UQ_Students_Email ON students(email) WHERE email IS NOT NULL;


 CREate NONCLUSTERED INDEX IXStudentCourses_Grade on StudentCourses(semester,grade);


 SELECT
       t.name AS TableName,
       i.name AS IndexName,
       i.type_desc AS IndexType,
       i.is_unique AS IsUnique
FROM sys.indexes i
INNER Join sys.tables t ON i.object_id = t.object_id
WHERE i.name IS NOT NULL;

 SELECT * FROM Students WHERE email = 'bhimdebnath@gmail.com';

 SELECT * FROM sys.tables;

 SELECT * FROM sys.schemas;
