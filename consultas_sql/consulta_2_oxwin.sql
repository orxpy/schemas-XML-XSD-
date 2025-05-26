WITH DepartmentSalaries AS (
    SELECT
        d.department_name,
        SUM(e.salary) AS department_total_salary
    FROM employees e
    JOIN departments d ON e.department_id = d.department_id
    WHERE e.department_id IS NOT NULL
    GROUP BY d.department_name
),
TotalCompanySalary AS (
    SELECT SUM(salary) AS total_salary FROM employees
)
SELECT
    ds.department_name,
    ds.department_total_salary,
    ROUND((ds.department_total_salary / tcs.total_salary) * 100, 2) AS percentage_of_total
FROM DepartmentSalaries ds, TotalCompanySalary tcs
WHERE ds.department_name IS NOT NULL
ORDER BY percentage_of_total DESC;