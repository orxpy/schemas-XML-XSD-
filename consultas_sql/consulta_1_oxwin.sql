SELECT first_name, last_name, salary, department_name, avg_dept_salary
FROM (
    SELECT
        e.first_name,
        e.last_name,
        e.salary,
        d.department_name,
        AVG(e.salary) OVER (PARTITION BY e.department_id) AS avg_dept_salary
    FROM employees e
    JOIN departments d ON e.department_id = d.department_id
    WHERE e.department_id IS NOT NULL AND d.department_id IS NOT NULL
)
WHERE salary > avg_dept_salary
ORDER BY department_name, salary DESC;