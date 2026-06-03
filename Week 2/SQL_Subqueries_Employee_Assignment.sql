CREATE DATABASE Employees;
USE Employees;

CREATE TABLE Employees(
	EmployeeID INT PRIMARY KEY,
    EmployeeName VARCHAR(100),
    Department VARCHAR(50),
    Salary DECIMAL(10,2),
    ManagerID INT,
    HireDate DATE);
    
DESC Employees;

INSERT INTO Employees
(EmployeeID, EmployeeName, Department, Salary, ManagerID, HireDate)
VALUES
(101, 'John', 'Sales', 50000, 201, '2021-01-10'),
(102, 'Mary', 'Sales', 65000, 201, '2020-03-15'),
(103, 'David', 'HR', 55000, 202, '2022-05-20'),
(104, 'Sophia', 'HR', 70000, 202, '2019-07-18'),
(105, 'James', 'IT', 80000, 203, '2018-11-01'),
(106, 'Emma', 'IT', 75000, 203, '2021-09-25'),
(107, 'Michael', 'Finance', 90000, 204, '2017-06-12'),
(108, 'Olivia', 'Finance', 60000, 204, '2023-02-01');

SELECT * from Employees;

-- 1. Find employees earning more than the average salary.
SELECT EmployeeName 
FROM Employees
WHERE Salary > ( SELECT Avg(Salary) 
				FROM Employees); 
SELECT Avg(Salary) 
FROM Employees;

-- 2. Find employees earning the highest salary.
SELECT EmployeeName
FROM Employees
Where Salary = (SELECT MAX(Salary) FROM Employees);

-- 3. Find employees earning the second highest salary.
SELECT EmployeeName,Salary
FROM (
SELECT EmployeeID,EmployeeName,Salary,Row_number() OVER (order by salary DESC) as rn
FROM Employees) emp
where rn=2;

-- 4. List employees whose salary is less than the maximum salary.
SELECT EmployeeName,Salary
FROM Employees
Where Salary < (SELECT MAX(Salary) FROM Employees)
order by Salary DESC;

-- 5. Find employees working in the same department as the employee with the highest salary.
SELECT EmployeeName,Salary,Department
FROM Employees
WHERE Department = (SELECT Department FROM Employees where salary = (SELECT Max(Salary) from employees));

-- 6. Find departments having employees with salary greater than 70,000.
SELECT distinct(Department)
FROM Employees
Where Salary > 70000;

-- 7. Find employees whose salary is above their department average salary.
SELECT EmployeeName, Salary, Department
FROM Employees e1
WHERE Salary > (
    SELECT AVG(Salary)
    FROM Employees e2
    WHERE e1.Department = e2.Department
);

-- 8. Find employees who earn more than all employees in the HR department.
SELECT EmployeeName
FROM Employees
Where Salary > ALL (SELECT Salary from employees where depaartment = 'HR');

-- 9. Find employees whose salary matches any salary in the Sales department.
SELECT EmployeeName
FROM EMployees
Where Salary > (SELECT Max(Salary) FROM Employees Where Department = 'Sales');

-- 10. Find employees hired after the employee with the lowest salary.
SELECT EmployeeName,
       HireDate
FROM Employees
WHERE HireDate > (
    SELECT HireDate
    FROM Employees
    WHERE Salary = (SELECT MIN(Salary)FROM Employees)
);

-- 11. Find the department with the highest average salary.
SELECT department,Avg(salary)
FROM Employees
Group by Department
order by Department
limit 1;

-- 12. Find employees who earn the minimum salary in their department.
SELECT Employeename,department
From Employees e
Where Salary = (SELECT Min(salary) from employees where e.department = department);

-- 13. Display managers who manage employees earning more than 75,000.
SELECT ManagerID
From Employees
Where Salary > 75000;

-- 14. Find employees whose salary is greater than their manager's salary (assume managers are employees). 



-- 15. Find the top 3 highest paid employees using a subquery.
Select employeename,salary
from employees
order by salary desc
limit 3 ;

