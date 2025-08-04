
-- Drop tables if they already exist (for repeat testing)
DROP TABLE IF EXISTS Enrollment, Course, Student, Instructor;

-- Student Table
CREATE TABLE Student (
    StudentId INT PRIMARY KEY,
    FullName VARCHAR(100),
    Age INT,
    Email VARCHAR(100) UNIQUE
);

-- Instructor Table
CREATE TABLE Instructor (
    InstructorID INT PRIMARY KEY,
    FullName VARCHAR(100),
    Email VARCHAR(100) UNIQUE
);

-- Course Table (now references InstructorID instead of email)
CREATE TABLE Course (
    CourseID INT PRIMARY KEY,
    CourseName VARCHAR(100),
    InstructorID INT,
    FOREIGN KEY (InstructorID) REFERENCES Instructor(InstructorID)
);

-- Enrollment Table
CREATE TABLE Enrollment (
    EnrollmentID INT PRIMARY KEY,
    StudentID INT,
    CourseID INT,
    EnrollmentDate DATE DEFAULT GETDATE(),
    FOREIGN KEY (StudentID) REFERENCES Student(StudentID),
    FOREIGN KEY (CourseID) REFERENCES Course(CourseID)
);
-- Instructors
INSERT INTO Instructor VALUES (1, 'Dr. Smith', 'smith@gmail.com');
INSERT INTO Instructor VALUES (2, 'Prof. Rajesh', 'rajesh@gmail.com');

-- Courses
INSERT INTO Course VALUES (101, 'Data Science', 1);
INSERT INTO Course VALUES (102, 'AI and ML', 2);

-- Students
INSERT INTO Student VALUES (1001, 'Alice Johnson', 21, 'alice@gmail.com');
INSERT INTO Student VALUES (1002, 'Bob Kumar', 22, 'bobkumar@gmail.com');

-- Enrollments
INSERT INTO Enrollment VALUES (1, 1001, 101, GETDATE());
INSERT INTO Enrollment VALUES (2, 1002, 102, GETDATE());
Select * FROM Student;

--Grant and Revoke
GRANT SELECT ON Student to auditor;
GRANT SELECT ON Enrollment to auditor;

--for above work we have to create user
CREATE Login auditor with Password = 'StrongPassword123';
Create User auditor FOR LOGIN auditor;

Revoke SELECT ON Student FROM Auditor;

BEGIN TRANSACTION;
INSERT INTO Student VALUES(3,'Alex','Alex@HWD.edu',20);
INSERT INTO Enrollment VALUES(1003,3,101,GETDATE());
COMMIT;

--ROll back
INSERT INTO Student VALUES(3,'BHIM','bhimdebnath89@gmail.com',20);
INSERT INTO Enrollment VALUES(1004,4,101,GETDATE());
COMMIT ;
SELECT * FROM Student;
SELECT * FROM Enrollment;
SELECT * FROM Course;
SELECT * FROM Instructor;

