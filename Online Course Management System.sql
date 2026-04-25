ALTER AUTHORIZATION ON DATABASE:: OnlineCourseDB TO sa;

SELECT *
FROM Students,Enrollments,Courses,Instructors

SELECT *FROM Students -- Select all columns for these students
WHERE age > ( -- Condition: age greater than the overall average
SELECT AVG(age) FROM Students -- Calculate overall average age
)
--2. Instructors with salary > avg salary of their specialization

SELECT * -- (Outer query): Selects all columns of the instructor (i)
FROM Instructors i -- Gave the main table an alias 'i' to easily reference it in the subquery
WHERE salary > ( --Condition: current instructor's salary is greater than the value returned by the subquery
SELECT AVG(salary) -- Subquery: calculates the average salary of all instructors 
FROM Instructors --who exist in the same table
WHERE specialization = i.specialization --only those who share the same specialization as the current instructor (i)
)

-- 3. Show courses that have a price higher than the average price of all courses

SELECT * FROM Courses-- Select all course columns
WHERE price > ( -- Condition: price above overall average
    SELECT AVG(price) FROM Courses -- Calculate overall average course price
)

-- 4. Retrieve students who are enrolled in at least one course

SELECT *FROM Students-- Select all student columns
WHERE student_id IN (SELECT student_id FROM Enrollments) -- Check if student exists in Enrollments & Get all students who have enrollments

-- 5. Retrieve students who are NOT enrolled in any course

SELECT *FROM Students-- Select all student columns
WHERE student_id NOT IN (SELECT student_id FROM Enrollments) -- Check if student  NOT exists in Enrollments & Get all students who have enrollments


-- 6. Show courses that have no enrollments

SELECT *FROM Courses -- Select all course columns
WHERE course_id NOT IN ( SELECT course_id FROM Enrollments) -- Check if course has no related enrollments & Get all courses that have NOT enrollment


-- 7. Show instructors who are not assigned to any course

SELECT *FROM Instructors -- Select all instructor columns
WHERE instructor_id NOT IN ( -- Check if instructor is not linked to any course
SELECT instructor_id FROM Courses) -- Get all instructors who teach at least one course

-- 8. Count number of students per city and show only cities with more than 20 students


SELECT city, COUNT(*) AS student_count FROM Students -- Select city and count of students
GROUP BY city -- Group by city to calculate per city
HAVING COUNT(*) > 20 -- Filter cities with more than 20 students


-- 9. Show specializations where the average salary is above 18000

SELECT specialization, AVG(salary) AS avg_salary -- Specialization and its average salary
FROM Instructors
GROUP BY specialization -- Group by specialization
HAVING AVG(salary) > 18000; -- Filter specializations with average above 18000


-- 10. Retrieve courses where the number of enrollments is greater than the average enrollments per course

SELECT c.course_name, COUNT(*) AS enr_count -- Course name and enrollment count
FROM Enrollments e
JOIN Courses c ON e.course_id = c.course_id -- Join to get course names
GROUP BY c.course_name -- Group by course name
HAVING COUNT(*) > ( -- Compare enrollment count to average
SELECT AVG(cnt) -- Get average of enrollment counts
FROM (SELECT COUNT(*) AS cnt -- Subquery: count enrollments per course
FROM Enrollments
GROUP BY course_id) AS T -- Alias required for sub-subquery in SQL Server
)

-- 11. Show students who are enrolled in more courses than the average number of courses per student

SELECT student_id, COUNT(*) AS course_count -- Student and count of courses enrolled
FROM Enrollments
GROUP BY student_id -- Group by student
HAVING COUNT(*) > ( -- Compare to average courses per student
SELECT AVG(course_count) -- Calculate average of course counts
FROM (SELECT COUNT(*) AS course_count -- Subquery: count courses per student
FROM Enrollments
GROUP BY student_id) AS sub -- Alias required for subquery
)

-- 12. Show the course(s) with the highest number of enrollments

SELECT TOP 1 WITH TIES c.course_name, COUNT(*) AS enr_count -- TOP 1 WITH TIES includes ties
FROM Enrollments e
JOIN Courses c ON e.course_id = c.course_id -- Join to get course name
GROUP BY c.course_name -- Group by course name
ORDER BY COUNT(*) DESC; -- Order by enrollment count descending


-- 13. Show instructors whose total generated revenue is above the average revenue of all instructors


SELECT i.instructor_id, i.full_name, SUM(c.price) AS total_revenue -- Instructor and their total revenue
FROM Instructors i
JOIN Courses c ON i.instructor_id = c.instructor_id -- Join to link instructors to courses
JOIN Enrollments e ON c.course_id = e.course_id -- Join to count enrollments (each enrollment generates revenue)
GROUP BY i.instructor_id, i.full_name -- Group by instructor
HAVING SUM(c.price) > ( -- Compare total revenue to overall average
    SELECT AVG(revenue) -- Calculate average revenue across all instructors
    FROM (
        SELECT SUM(c2.price) AS revenue -- Subquery: revenue per instructor
        FROM Enrollments e2
        JOIN Courses c2 ON e2.course_id = c2.course_id
        GROUP BY c2.instructor_id) AS sub -- Alias required
)

-- 14. Retrieve students whose average grade is above the overall average grade


SELECT student_id, AVG(grade) AS avg_grade -- Student and their average grade
FROM Enrollments
GROUP BY student_id -- Group by student
HAVING AVG(grade) > ( -- Compare student average to overall average
    SELECT AVG(grade) FROM Enrollments -- Overall average grade
)


-- 15. Show students who scored the highest grade in any course

SELECT e.student_id, s.first_name + ' ' + s.last_name AS full_name, e.course_id, e.grade -- Student(name concatenat the first and last as full name ), course, and grade
FROM Enrollments e
JOIN Students s ON e.student_id = s.student_id -- Join to get student name by student id key 
JOIN (
    SELECT course_id, MAX(grade) AS max_grade  -- Subquery to calculate max grade per course
    FROM Enrollments  -- Get the highest grade for each course
    GROUP BY course_id
) m
ON e.course_id = m.course_id AND e.grade = m.max_grade -- Match course ID and keeponly students with the highest grade
ORDER BY e.grade DESC -- Sort results by grade in descending order


-- 16. Show courses whose average grade is below 60

SELECT course_id, AVG(grade) AS avg_grade -- Course and its average grade
FROM Enrollments
GROUP BY course_id -- Group by course
HAVING AVG(grade) < 60 -- Filter courses with average below 60

-- 17. Retrieve instructors who teach more courses than the average number of courses per instructor

SELECT instructor_id, COUNT(*) AS course_count -- Instructor and number of courses they teach
FROM Courses
GROUP BY instructor_id -- Group by instructor
HAVING COUNT(*) > ( -- Compare to average courses per instructor
    SELECT AVG(course_count) -- Calculate average of course counts
    FROM (
        SELECT COUNT(*) AS course_count -- Subquery: count courses per instructor
        FROM Courses
        GROUP BY instructor_id
    ) AS sub -- Alias required
)


-- 18. Show total revenue per category and display only categories with revenue above 100000


SELECT c.category, SUM(c.price) AS total_revenue -- Select instructor specialization and total revenue generated
FROM Courses c -- Instructors table with alias i
JOIN Enrollments e ON c.course_id = e.course_id -- Join Enrollments table to count students enrolled in each course (each enrollment contributes to revenue)
GROUP BY c.category -- Group results by instructor specialization
HAVING SUM(c.price) > 100000; -- Filter only specializations where total revenue is greater than 100,000

-- 19. Show students along with the number of courses they are enrolled in, including students with zero enrollments

SELECT s.student_id,s.first_name + ' ' + s.last_name AS full_name, COUNT(e.course_id) AS enrolled_courses -- Student and course count
FROM Students s
LEFT JOIN Enrollments e ON s.student_id = e.student_id -- LEFT JOIN includes students with no enrollments
GROUP BY s.student_id, s.first_name + ' ' + s.last_name  -- Group by student


-- 20. Show courses along with total enrollments, including courses with no enrollments

SELECT c.course_id, c.course_name, COUNT(e.student_id) AS total_enrollments -- Course and enrollment count
FROM Courses c
LEFT JOIN Enrollments e ON c.course_id = e.course_id -- LEFT JOIN includes courses with no enrollments
GROUP BY c.course_id, c.course_name; -- Group by course


-- 21. Show instructors and their courses, including instructors without courses

SELECT i.instructor_id, i.full_name, c.course_name -- Instructor and their course
FROM Instructors i
LEFT JOIN Courses c ON i.instructor_id = c.instructor_id; -- LEFT JOIN includes instructors with no courses


-- 22. Retrieve students who are enrolled in ALL available courses

SELECT student_id  -- Student ID
FROM Enrollments
GROUP BY student_id -- Group by student
HAVING COUNT(DISTINCT course_id) = ( -- Check if distinct courses enrolled = total courses
    SELECT COUNT(*) FROM Courses -- Total number of courses available
)


-- 23. Show courses that are more expensive than at least one course in the same category

SELECT c1.course_name, c1.price, c1.category -- Course details
FROM Courses c1
WHERE c1.price > ANY ( -- ANY: greater than at least one value in the subquery
    SELECT c2.price -- Prices of other courses in same category
    FROM Courses c2
    WHERE c2.category = c1.category -- Same category
    AND c2.course_id != c1.course_id -- Exclude the current course itself
)


-- 24. Retrieve instructors whose salary is above the maximum salary in a specific specialization

SELECT * -- Select all instructor columns
FROM Instructors
WHERE salary > ( -- Compare salary to maximum salary in 'AI' specialization
    SELECT MAX(salary) FROM Instructors
    WHERE specialization = 'Data science' -- put 'Any specialization'
)


-- 25. Show students whose total paid amount exceeds 15000

SELECT 
    s.student_id,
    s.first_name + ' ' + s.last_name AS full_name,  -- Student full name
    SUM(c.price) AS total_paid                      -- Total amount paid
FROM Enrollments e
JOIN Courses c ON e.course_id = c.course_id         -- Get course price
JOIN Students s ON e.student_id = s.student_id      -- Join to get student name
GROUP BY s.student_id, s.first_name, s.last_name    -- Group by student info
HAVING SUM(c.price) > 15000                      -- Filter students who paid more than 15000
ORDER BY total_paid DESC --ORDERED THE RESULT BY TOAL PAID DESC


-- 26. Show cities where the average student age is higher than the overall average age

SELECT city, AVG(age) AS avg_age -- City and its average student age
FROM Students
GROUP BY city -- Group by city
HAVING AVG(age) > ( -- Compare city average to overall average
SELECT AVG(age) FROM Students -- Overall average age of all students
)

-- 27. Retrieve courses where the duration is above the average duration of courses in the same category

SELECT c1.course_name, c1.duration_hours, c1.category -- Course details
FROM Courses c1
WHERE c1.duration_hours > ( -- Compare duration to category average
    SELECT AVG(c2.duration_hours) -- Average duration of courses in same category
    FROM Courses c2
    WHERE c2.category = c1.category -- Same category
)


-- 28. Show instructors whose total enrollments across all their courses exceed 100

SELECT i.instructor_id, i.full_name, COUNT(e.student_id) AS total_enrollments -- Instructor and total enrollments
FROM Instructors i
JOIN Courses c ON i.instructor_id = c.instructor_id -- Link instructor to courses
JOIN Enrollments e ON c.course_id = e.course_id -- Link courses to enrollments
GROUP BY i.instructor_id, i.full_name -- Group by instructor
HAVING COUNT(e.student_id) > 100; -- Filter instructors with more than 100 enrollments



-- 29. Retrieve students who have never scored below 60 in any course


SELECT s.student_id,s.first_name + ' ' + s.last_name AS full_name
FROM Enrollments e
JOIN Students s ON e.student_id = s.student_id      -- Join to get student name
GROUP BY s.student_id,s.first_name + ' ' + s.last_name -- Group by student
HAVING MIN(grade) >= 60; -- Check if the minimum grade for this student is 60 or higher


-- 30. Show courses where the maximum grade achieved is below 70


SELECT course_id, MAX(grade) AS max_grade -- Course and its maximum grade
FROM Enrollments
GROUP BY course_id -- Group by course
HAVING MAX(grade) < 70; -- Filter courses where highest grade is below 70


-- 31. Retrieve the top 3 cities by number of enrolled students

SELECT TOP 3 city, COUNT(*) AS enrolled_count -- Top 3 cities and count of enrolled students
FROM Students s
JOIN Enrollments e ON s.student_id = e.student_id -- Only students who are enrolled
GROUP BY city -- Group by city
ORDER BY COUNT(*) DESC; -- Order by count descending to get top 3


-- 32. Show instructors whose average course price is higher than the overall average course price

SELECT i.instructor_id, i.full_name, AVG(c.price) AS avg_price -- Instructor and their average course price
FROM Instructors i
JOIN Courses c ON i.instructor_id = c.instructor_id -- Link instructor to courses
GROUP BY i.instructor_id, i.full_name -- Group by instructor
HAVING AVG(c.price) > ( -- Compare instructor's average to overall average
SELECT AVG(price) FROM Courses -- Overall average price of all courses
)


-- 33. Retrieve students who share the same city with more than 30 other students
SELECT student_id, first_name + ' ' + last_name AS full_name,city   -- select the name and id and city from table                                     
FROM Students
WHERE city IN (  -- Filter students whose city is in the following list
    SELECT city 
    FROM Students -- from table student 
    GROUP BY city -- Group students by city
    HAVING COUNT(*) > 30 -- Keep only cities that have more than 30 students
)


-- 34. Show categories where the number of courses is above the average number of courses per category

SELECT category, COUNT(*) AS course_count -- Category and number of courses
FROM Courses
GROUP BY category -- Group by category
HAVING COUNT(*) > ( -- Compare to average courses per category
    SELECT AVG(course_count) -- Calculate average of course counts
    FROM (
        SELECT COUNT(*) AS course_count -- Subquery: count courses per category
        FROM Courses
        GROUP BY category
    ) AS sub -- Alias required
)


-- 35. Retrieve instructors who do not generate any revenue

SELECT * -- Select all columns from Instructors table
FROM Instructors i -- Instructors table with alias i
WHERE NOT EXISTS ( -- Filter instructors where no matching records exist in the subquery
SELECT 1 -- Return a constant (only used to check existence, not actual data)
FROM Courses c -- Courses table
JOIN Enrollments e ON c.course_id = e.course_id -- Join enrollments to check if any student is enrolled in the instructor's courses
 WHERE c.instructor_id = i.instructor_id-- Match courses to the current instructor from outer query
)


-- 36. Show students and their highest grade, including students with no grades

SELECT s.student_id, s.first_name + ' ' + last_name AS full_name, MAX(e.grade) AS highest_grade -- Student and highest grade
FROM Students s
LEFT JOIN Enrollments e ON s.student_id = e.student_id -- LEFT JOIN includes students with no grades
GROUP BY s.student_id, s.first_name + ' ' + last_name  -- Group by student


-- 37. Retrieve courses that have enrollments from students in more than 3 different cities

SELECT c.course_id, c.course_name, COUNT(DISTINCT s.city) AS city_count -- Course and number of distinct cities
FROM Courses c
JOIN Enrollments e ON c.course_id = e.course_id -- Link to enrollments
JOIN Students s ON e.student_id = s.student_id -- Link to students to get city
GROUP BY c.course_id, c.course_name -- Group by course
HAVING COUNT(DISTINCT s.city) > 3; -- Filter courses with students from more than 3 cities (DISTINCT to sure that the cities do not repeat)


-- 38. Show instructors whose salary is below the average salary but teach more than 2 courses

SELECT i.instructor_id, i.full_name, i.salary, COUNT(c.course_id) AS course_count -- Instructor details and course count
FROM Instructors i
JOIN Courses c ON i.instructor_id = c.instructor_id -- Link to courses
GROUP BY i.instructor_id, i.full_name, i.salary -- Group by instructor
HAVING i.salary < (SELECT AVG(salary) FROM Instructors) -- Salary below overall average
AND COUNT(c.course_id) > 2; -- Teaches more than 2 courses


-- 39. Retrieve students who are enrolled in courses taught by more than one instructor

SELECT DISTINCT e.student_id -- Distinct student IDs (avoid duplicates)
FROM Enrollments e
JOIN Courses c ON e.course_id = c.course_id -- Link to courses
GROUP BY e.student_id, e.course_id -- Group by student and course
HAVING COUNT(DISTINCT c.instructor_id) > 1; -- Course has more than one instructor

-- 40. Show the instructor(s) who teach the most expensive course

SELECT i.* -- Select all instructor columns 
FROM Instructors i
JOIN Courses c ON i.instructor_id = c.instructor_id -- Link to courses
WHERE c.price = (SELECT MAX(price) FROM Courses); -- Course price equals maximum price

-- 41. Retrieve courses whose enrollment count is below the minimum enrollment count of any other course

SELECT course_id, COUNT(*) AS enr_count -- Course and enrollment count
FROM Enrollments
GROUP BY course_id -- Group by course
HAVING COUNT(*) < ( -- Compare to...
SELECT MIN(enr_count) -- ...the minimum enrollment count
FROM (SELECT COUNT(*) AS enr_count -- Subquery: enrollment count per course
FROM Enrollments
GROUP BY course_id
) AS sub
WHERE enr_count > 0 -- Exclude courses with zero enrollments (if any)
)


-- 42. Show students whose average grade is higher than the average grade of their city

SELECT s.student_id, s.first_name + ' ' + last_name AS full_name, AVG(e.grade) AS student_avg_grade -- Student and their average grade
FROM Students s
JOIN Enrollments e ON s.student_id = e.student_id -- Link to grades
GROUP BY s.student_id, s.first_name + ' ' + last_name, s.city -- Group by student and city
HAVING AVG(e.grade) > ( -- Compare student average to city average
SELECT AVG(e2.grade) -- Average grade of all students in same city
FROM Students s2
JOIN Enrollments e2 ON s2.student_id = e2.student_id
WHERE s2.city = s.city -- Same city
)

-- 43. Retrieve instructors whose total revenue is equal to the maximum revenue generated

SELECT i.instructor_id, i.full_name, SUM(c.price) AS total_revenue -- Instructor and total revenue
FROM Instructors i
JOIN Courses c ON i.instructor_id = c.instructor_id -- Link to courses
JOIN Enrollments e ON c.course_id = e.course_id -- Link to enrollments
GROUP BY i.instructor_id, i.full_name -- Group by instructor
HAVING SUM(c.price) = ( -- Compare to maximum revenue
 SELECT MAX(revenue) -- Find maximum revenue
 FROM (SELECT SUM(c2.price) AS revenue -- Subquery: revenue per instructor
 FROM Enrollments e2
 JOIN Courses c2 ON e2.course_id = c2.course_id
 GROUP BY c2.instructor_id) AS sub -- Alias required
)


-- 44. Show students who have enrolled in at least one course from each category

SELECT student_id -- Student ID
FROM Enrollments e
JOIN Courses c ON e.course_id = c.course_id -- Link to get category
GROUP BY student_id -- Group by student
HAVING COUNT(DISTINCT c.category) = ( -- Check if student covered all categories
SELECT COUNT(DISTINCT category)FROM Courses-- Total number of categories
)


-- 45. Retrieve courses where the average grade is higher than the overall average grade
SELECT e.course_id,c.course_name ,AVG(grade) AS avg_grade -- Course and its average grade
FROM Enrollments e 
JOIN Courses c ON c.course_id =e.course_id
GROUP BY e.course_id,c.course_name -- Group by course
HAVING AVG(grade) > ( -- Compare course average to overall average
    SELECT AVG(grade) FROM Enrollments -- Overall average grade of all enrollments
)

-- 46. Show cities where the total number of enrollments exceeds 200

SELECT s.city, COUNT(e.student_id) AS total_enrollments -- City and total enrollments
FROM Students s
JOIN Enrollments e ON s.student_id = e.student_id -- Link to enrollments
GROUP BY s.city -- Group by city
HAVING COUNT(e.student_id) > 200; -- Filter cities with more than 200 enrollments


-- 47. Retrieve instructors who have at least one course with no enrollments

SELECT DISTINCT i.instructor_id, i.full_name -- Distinct instructor IDs and names
FROM Instructors i
JOIN Courses c ON i.instructor_id = c.instructor_id -- Link to courses
LEFT JOIN Enrollments e ON c.course_id = e.course_id -- LEFT JOIN to detect missing enrollments
GROUP BY i.instructor_id, i.full_name, c.course_id -- Group by instructor and course
HAVING COUNT(e.student_id) = 0; -- Keep only courses with zero enrollments


-- 48. Show students whose total enrolled course duration exceeds 100 hours

SELECT s.student_id, s.first_name+ ' ' +last_name AS full_name , SUM(c.duration_hours) AS total_duration -- Student and total course duration
FROM Students s
JOIN Enrollments e ON s.student_id = e.student_id -- Link to enrollments
JOIN Courses c ON e.course_id = c.course_id -- Link to courses to get duration
GROUP BY s.student_id, s.first_name+ ' ' +last_name -- Group by student
HAVING SUM(c.duration_hours) > 100; -- Filter students with total duration > 100 hours


-- 49. Retrieve the second highest salary among instructors

SELECT TOP 1 salary -- Get the top 1 after ordering
FROM (SELECT DISTINCT TOP 2 salary -- Get the top 2 distinct salaries (highest and second highest)
FROM Instructors
ORDER BY salary DESC -- Order from highest to lowest
) AS sub
ORDER BY salary ASC; -- Order ascending so the second highest is now first


-- 50. Show the distribution of grades (count per grade range: 0–50, 51–70, 71–85, 86–100)

WITH GradeBuckets AS (
SELECT 
CASE 
     WHEN grade BETWEEN 0 AND 50 THEN '0-50'
     WHEN grade BETWEEN 51 AND 70 THEN '51-70'
     WHEN grade BETWEEN 71 AND 85 THEN '71-85'
     WHEN grade BETWEEN 86 AND 100 THEN '86-100'
END AS grade_range
 FROM Enrollments
)
SELECT grade_range, COUNT(*) AS count
FROM GradeBuckets
GROUP BY grade_range
ORDER BY grade_range




-- 51.Show students whose average grade is above their course's average grade in every course they enrolled in

SELECT e1.student_id,s.first_name+ ' ' +last_name AS full_name  -- Select student ID
FROM Enrollments e1
JOIN Students s ON s.student_id = e1.student_id
GROUP BY e1.student_id,s.first_name+ ' ' +last_name -- Group by student
HAVING NOT EXISTS ( -- Check that there is NO course where the student's grade is NOT above average
 SELECT 1 -- Subquery returns 1 if a violating course exists
 FROM Enrollments e2
 WHERE e2.student_id = e1.student_id -- Same student
 AND e2.grade <= ( -- Student's grade is less than or equal to course average
  SELECT AVG(e3.grade) -- Calculate course's average grade
  FROM Enrollments e3
 WHERE e3.course_id = e2.course_id -- For this specific course
)
)

-- 52.Retrieve instructors who generate more revenue than the average revenue of instructors in the same specialization

SELECT i.instructor_id, i.full_name, SUM(c.price) AS revenue, i.specialization -- Instructor, revenue, and specialization
FROM Instructors i
JOIN Courses c ON i.instructor_id = c.instructor_id -- Link instructor to courses
JOIN Enrollments e ON c.course_id = e.course_id -- Link courses to enrollments (revenue generated)
GROUP BY i.instructor_id, i.full_name, i.specialization -- Group by instructor and specialization
HAVING SUM(c.price) > ( -- Compare instructor's revenue to specialization average
    SELECT AVG(revenue) -- Calculate average revenue within the same specialization
    FROM (
        SELECT SUM(c2.price) AS revenue -- Subquery: revenue per instructor
        FROM Instructors i2
        JOIN Courses c2 ON i2.instructor_id = c2.instructor_id
        JOIN Enrollments e2 ON c2.course_id = e2.course_id
        WHERE i2.specialization = i.specialization -- Same specialization as outer instructor
        GROUP BY i2.instructor_id
    ) AS sub -- Alias required for subquery
)



-- 53. Show courses that have enrollments from students in every city available in the Students table

SELECT c.course_id, c.course_name -- Select course ID and name
FROM Courses c
JOIN Enrollments e ON c.course_id = e.course_id -- Link to enrollments
JOIN Students s ON e.student_id = s.student_id -- Link to students
GROUP BY c.course_id, c.course_name -- Group by course
HAVING COUNT(DISTINCT s.city) = (SELECT COUNT(DISTINCT city) FROM Students); -- Course covers all distinct cities

