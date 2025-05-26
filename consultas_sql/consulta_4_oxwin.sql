WITH EmployeeRoles AS (
    SELECT
        e.employee_id,
        e.department_id,
        e.salary,
        CASE
            WHEN e.employee_id IN (SELECT DISTINCT manager_id FROM employees WHERE manager_id IS NOT NULL)
                  OR e.employee_id IN (SELECT DISTINCT manager_id FROM departments WHERE manager_id IS NOT NULL)
            THEN 'Manager'
            ELSE 'Non-Manager'
        END AS role_type
    FROM employees e
    WHERE e.department_id IS NOT NULL
),
AvgSalariesByRole AS (
    SELECT
        er.department_id,
        d.department_name,
        er.role_type,
        AVG(er.salary) AS avg_salary
    FROM EmployeeRoles er
    JOIN departments d ON er.department_id = d.department_id
    GROUP BY er.department_id, d.department_name, er.role_type
)
SELECT
    a.department_name,
    ROUND(AVG(CASE WHEN a.role_type = 'Manager' THEN a.avg_salary END), 2) AS avg_manager_salary,
    ROUND(AVG(CASE WHEN a.role_type = 'Non-Manager' THEN a.avg_salary END), 2) AS avg_non_manager_salary,
    ROUND(ABS(
        NVL(AVG(CASE WHEN a.role_type = 'Manager' THEN a.avg_salary END), 0) -
        NVL(AVG(CASE WHEN a.role_type = 'Non-Manager' THEN a.avg_salary END), 0)
    ), 2) AS avg_salary_difference
FROM AvgSalariesByRole a
GROUP BY a.department_name
HAVING COUNT(DISTINCT a.role_type) = 2 -- Solo departamentos con ambos roles para una diferencia significativa
ORDER BY a.department_name;