use subqueries;

INSERT INTO students(student_Id,name,class)
VALUES
(1,'Ananya',12),
(2,'Siri',10),
(3,'Dhruv',12),
(4,'Sam',8);

INSERT INTO marks(student_Id,subject,marks)
VALUES
(1,'Math',90),
(1,'Hindi',72),
(2,'English',94),
(3,'Math',65),
(4,'English',89),
(5,'Math',40),
(3,'English',97);

Select * from students as s;
Select * from marks as m;

-- Calculating each student's average marks
Select s.student_Id,
s.name,
s.class,
	(Select avg(m.marks)
	from marks m
	where s.student_Id=m.student_Id) as avg_marks
From students s;

-- Find students who scored more than the overall average
SELECT DISTINCT name
FROM Students
WHERE student_id IN (
    SELECT student_id 
    FROM Marks 
    WHERE marks > (SELECT AVG(marks) FROM Marks)
);

-- List students who have marks in Math
Select s.name, s.class
from students s
where exists(
	select 1 from marks m
	where m.student_Id = s.student_Id and m.subject = 'Math'
	);
-- List subjects where average score is above 80
select subject, avg(marks) as avg_marks
from(
		Select * from marks
        ) AS AllMarks
Group by subject
Having AVG(marks)>80;

--  students with the highest individual mark
SELECT name,class
FROM Students
WHERE student_id = (
    SELECT student_id 
    FROM Marks 
    ORDER BY marks DESC 
    LIMIT 1
);

-- students who have taken all subjects offered
SELECT name
FROM Students S
WHERE (
    SELECT COUNT(DISTINCT subject)
    FROM Marks M
    WHERE M.student_id = S.student_id
) = (
    SELECT COUNT(DISTINCT subject) FROM Marks
);

-- Ranking students by their total marks using subquery
SELECT RANK() OVER (ORDER BY marks DESC) AS ranking,
       name,marks
FROM (
    SELECT s.name, SUM(m.marks) AS marks
    FROM students s
    JOIN marks m ON s.student_id = m.student_id
    GROUP BY s.student_id
) AS Ranked;
