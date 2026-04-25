# 🚀 SQL Server DQL Mastery Project

<div align="center">

![SQL Server](https://img.shields.io/badge/SQL%20Server-2016%2B-CC2927?style=for-the-badge&logo=microsoft-sql-server&logoColor=white)
![T-SQL](https://img.shields.io/badge/T--SQL-DQL-0078D4?style=for-the-badge&logo=microsoft&logoColor=white)
![Queries](https://img.shields.io/badge/Queries-53-28a745?style=for-the-badge)
![Status](https://img.shields.io/badge/Status-Complete-success?style=for-the-badge)

**53 advanced DQL exercises on a fully relational Online Course Management System**

</div>

---

## 📊 Project Overview

This project contains **53 advanced DQL (Data Query Language)** exercises covering real-world scenarios for SQL Server. It demonstrates proficiency in:

- ✅ Scalar & Correlated Subqueries
- ✅ Nested Subqueries (up to 3 levels)
- ✅ Complex JOINs (INNER, LEFT)
- ✅ Aggregate Functions with `GROUP BY` & `HAVING`
- ✅ `EXISTS` / `NOT EXISTS` operators
- ✅ Relational Division — Double `NOT EXISTS` pattern
- ✅ CTEs (`WITH` clause)
- ✅ `CASE WHEN` conditional bucketing
- ✅ `ANY` / `ALL` set comparisons
- ✅ `TOP N WITH TIES` ranked results

---

## 🎯 Key Features

| Feature | Description |
|---------|-------------|
| **53 Queries** | From basic filtering to advanced 3-level nested subqueries |
| **Real-world schema** | Students, Instructors, Courses, Enrollments |
| **Documented** | Every query has inline comments explaining the logic |
| **Bilingual** | Arabic & English explanations |
| **Pattern-focused** | Groups queries by technique, not just number |

---

## 🗄️ Database Schema

```
┌─────────────┐        ┌──────────────┐        ┌──────────────────┐
│  Students   │        │  Enrollments │        │    Courses       │
│─────────────│        │──────────────│        │──────────────────│
│ student_id  │◄──────►│ student_id   │◄──────►│ course_id        │
│ first_name  │        │ course_id    │        │ course_name      │
│ last_name   │        │ grade        │        │ price            │
│ age         │        └──────────────┘        │ category         │
│ city        │                                │ duration_hours   │
└─────────────┘                                │ instructor_id    │
                                               └────────┬─────────┘
                                                        │
                                               ┌────────▼─────────┐
                                               │   Instructors    │
                                               │──────────────────│
                                               │ instructor_id    │
                                               │ full_name        │
                                               │ salary           │
                                               │ specialization   │
                                               └──────────────────┘
```

**Relationships:**
- One `Student` → many `Enrollments`
- One `Course` → many `Enrollments`
- One `Instructor` → many `Courses`
- `Enrollments` is the junction table (grade lives here)

---

## 📂 Query Index

<details>
<summary><b>🔵 Basic Filtering & Subqueries (1–7)</b></summary>

| # | Description | Technique |
|---|-------------|-----------|
| 1 | Students older than average age | Scalar subquery in `WHERE` |
| 2 | Instructors earning above their specialization's average | Correlated subquery |
| 3 | Courses priced above overall average | Scalar subquery |
| 4 | Students enrolled in at least one course | `IN` + subquery |
| 5 | Students with no enrollments | `NOT IN` + subquery |
| 6 | Courses with no enrollments | `NOT IN` + subquery |
| 7 | Instructors not assigned to any course | `NOT IN` + subquery |

</details>

<details>
<summary><b>🟡 GROUP BY + HAVING (8–18)</b></summary>

| # | Description | Technique |
|---|-------------|-----------|
| 8 | Cities with more than 20 students | `HAVING COUNT` |
| 9 | Specializations with average salary > 18,000 | `HAVING AVG` |
| 10 | Courses with enrollments above the average | Nested subquery in `HAVING` |
| 11 | Students enrolled in more courses than average | Nested subquery in `HAVING` |
| 12 | Course(s) with the highest enrollment count | `TOP 1 WITH TIES` |
| 13 | Instructors with above-average total revenue | Triple JOIN + nested subquery |
| 14 | Students with above-average grade | `HAVING AVG` + scalar subquery |
| 15 | Students who scored the highest grade in any course | Derived table JOIN |
| 16 | Courses with average grade below 60 | `HAVING AVG` |
| 17 | Instructors teaching more courses than average | Nested subquery |
| 18 | Categories with total revenue above 100,000 | `HAVING SUM` |

</details>

<details>
<summary><b>🟢 JOINs & Set Operations (19–24)</b></summary>

| # | Description | Technique |
|---|-------------|-----------|
| 19 | Students with enrollment count (including zeros) | `LEFT JOIN` |
| 20 | Courses with enrollment count (including zeros) | `LEFT JOIN` |
| 21 | Instructors with their courses (including unassigned) | `LEFT JOIN` |
| 22 | Students enrolled in ALL available courses | `HAVING COUNT(DISTINCT)` = total |
| 23 | Courses more expensive than at least one peer in category | `ANY` operator |
| 24 | Instructors earning above max salary in a specialization | Scalar subquery + `MAX` |

</details>

<details>
<summary><b>🟠 Aggregation & Analytics (25–36)</b></summary>

| # | Description | Technique |
|---|-------------|-----------|
| 25 | Students whose total paid amount exceeds 15,000 | `HAVING SUM` + `ORDER BY` |
| 26 | Cities where average student age > overall average | Correlated `HAVING` |
| 27 | Courses longer than category average duration | Correlated subquery |
| 28 | Instructors with more than 100 total enrollments | `HAVING COUNT` |
| 29 | Students who never scored below 60 | `HAVING MIN >= 60` |
| 30 | Courses where max grade is below 70 | `HAVING MAX` |
| 31 | Top 3 cities by enrolled student count | `TOP 3` + `ORDER BY` |
| 32 | Instructors with above-average course price | `HAVING AVG` |
| 33 | Students sharing a city with more than 30 others | `IN` + `HAVING` |
| 34 | Categories with above-average number of courses | Nested subquery |
| 35 | Instructors generating zero revenue | `NOT EXISTS` |
| 36 | Students and highest grade (including ungraded) | `LEFT JOIN` + `MAX` |

</details>

<details>
<summary><b>🔴 Advanced Queries (37–53)</b></summary>

| # | Description | Technique |
|---|-------------|-----------|
| 37 | Courses with students from more than 3 cities | `COUNT(DISTINCT)` |
| 38 | Instructors below avg salary but teaching 2+ courses | Combined `HAVING` conditions |
| 39 | Students enrolled in courses with multiple instructors | `COUNT(DISTINCT)` in `HAVING` |
| 40 | Instructor(s) teaching the most expensive course | Scalar subquery + `MAX` |
| 41 | Courses with enrollment below the minimum | Nested `MIN` subquery |
| 42 | Students with grade above their city's average | Correlated `HAVING` + double JOIN |
| 43 | Instructors with revenue equal to the maximum | Nested `MAX` subquery |
| 44 | Students enrolled in at least one course per category | `COUNT(DISTINCT)` = total categories |
| 45 | Courses where average grade > overall average | Correlated `HAVING` |
| 46 | Cities with total enrollments exceeding 200 | `HAVING COUNT` |
| 47 | Instructors with at least one course with no enrollments | `LEFT JOIN` + `HAVING COUNT = 0` |
| 48 | Students with total course duration over 100 hours | `HAVING SUM` |
| 49 | Second highest instructor salary | `TOP 1` inside `TOP 2` |
| 50 | Grade distribution (0–50, 51–70, 71–85, 86–100) | `CTE` + `CASE WHEN` |
| 51 | Students above average in **every** enrolled course | `NOT EXISTS` double negation |
| 52 | Instructors earning above specialization revenue average | Correlated nested subquery |
| 53 | Courses with enrollments from students in every city | `COUNT(DISTINCT)` = total cities |

</details>

---

## 🧠 Key SQL Patterns Explained

### 1. Relational Division — "For All" with Double NOT EXISTS (Query 51)

SQL has no `FOR ALL` quantifier. To express *"students above average in every course"*:

```sql
-- ❌ Cannot write: "WHERE grade > avg FOR ALL courses"

-- ✅ Double negation instead:
HAVING NOT EXISTS (
    SELECT 1
    FROM Enrollments e2
    WHERE e2.student_id = e1.student_id
    AND e2.grade <= (
        SELECT AVG(e3.grade)
        FROM Enrollments e3
        WHERE e3.course_id = e2.course_id
    )
)
-- Logic: "There is NO course where this student is NOT above average"
-- Which means: "The student is above average in ALL courses"
```

---

### 2. Nested Average of Counts (Queries 10, 11, 17, 34)

A common pattern for "show X where its count is above the average count":

```sql
HAVING COUNT(*) > (
    SELECT AVG(cnt)
    FROM (
        SELECT COUNT(*) AS cnt
        FROM Enrollments
        GROUP BY course_id
    ) AS T   -- ⚠️ SQL Server requires an alias on all derived tables
)
```

---

### 3. Second Highest Value Without Window Functions (Query 49)

```sql
SELECT TOP 1 salary
FROM (
    SELECT DISTINCT TOP 2 salary
    FROM Instructors
    ORDER BY salary DESC   -- Get the 2 highest
) AS sub
ORDER BY salary ASC        -- Then flip to get the 2nd
```

---

### 4. WHERE vs HAVING — When to Use Each

```sql
-- WHERE: filters BEFORE grouping (cannot use aggregate functions)
WHERE age > 20

-- HAVING: filters AFTER grouping (can use aggregate functions)
HAVING COUNT(*) > 5
HAVING AVG(grade) > (SELECT AVG(grade) FROM Enrollments)
```

---

### 5. NOT IN vs NOT EXISTS — The NULL Trap

```sql
-- ⚠️ NOT IN fails silently if the subquery returns any NULL
WHERE student_id NOT IN (SELECT student_id FROM Enrollments)
-- If Enrollments has a NULL student_id → returns 0 rows unexpectedly

-- ✅ NOT EXISTS is NULL-safe and generally preferred
WHERE NOT EXISTS (
    SELECT 1 FROM Enrollments e
    WHERE e.student_id = s.student_id
)
```

---

## 🛠️ Setup & Usage

**Requirements:** SQL Server 2016+ or Azure SQL Database

```sql
-- Step 1: Create the database
CREATE DATABASE OnlineCourseDB;
GO
USE OnlineCourseDB;
GO

-- Step 2: Run your schema creation script (Students, Instructors, Courses, Enrollments)

-- Step 3: Insert sample data

-- Step 4: Run any query from SQLTASK.sql
-- All 53 queries are self-contained and can be executed independently
```

---

## 📁 Repository Structure

```
📦 SQL-DQL-Mastery
 ┣ 📄 SQLTASK.sql     ← All 53 queries with full inline documentation
 ┗ 📄 README.md       ← This file
```

---

## 📈 Skills Demonstrated

```
Beginner               Intermediate                Advanced
────────────────────────────────────────────────────────────
WHERE + subquery    Correlated subquery        NOT EXISTS pattern
Simple JOIN         Derived tables             Relational division
GROUP BY            Multi-table JOINs          3-level nested subquery
HAVING              LEFT JOIN + NULL handling  CTE + CASE WHEN
                    COUNT(DISTINCT)            Correlated HAVING
```

---

## 👤 Author

> Built as a hands-on deep-dive into SQL analytical query writing.
> Every query solves a real business question — no filler exercises.

Feel free to ⭐ the repo if you found it useful, or open an issue if you spot a better approach to any query.

---

<div align="center">
<sub>SQL Server · T-SQL · DQL · Subqueries · Analytics</sub>
</div>
