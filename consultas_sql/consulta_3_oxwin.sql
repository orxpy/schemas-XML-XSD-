SELECT e.first_name, e.last_name, e.salary, j.job_title, j.min_salary, j.max_salary
FROM employees e
JOIN jobs j ON e.job_id = j.job_id
WHERE e.salary < j.min_salary OR e.salary > j.max_salary
ORDER BY j.job_title, e.last_name;