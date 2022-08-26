-- Question 1)

SELECT DATE_PART('day', r.rental_date) AS rental_day,
       DATE_PART('month', r.rental_date) AS rental_month,
       DATE_PART('year', r.rental_date) AS rental_year,
       s.store_id,
       COUNT(r.rental_id) AS count_rentals
  FROM store AS s
  JOIN staff
    ON s.store_id = staff.store_id JOIN payment AS p
    ON staff.staff_id = p.staff_id
  JOIN rental AS r
    ON p.rental_id = r.rental_id
 GROUP BY 3, 2, 1, 4
 ORDER BY 3, 2, 1, 4;

-- Question 2)

WITH Table1 AS (
    SELECT CONCAT(c.first_name, ' ', c.last_name) AS full_name,
           SUM(p.amount) AS pay_amount FROM payment AS p
      JOIN customer AS c
        ON p.customer_id = c.customer_id
     GROUP BY 1
     ORDER BY 2 DESC
     LIMIT 10
)

SELECT p.payment_date AS pay_date, CONCAT(c.first_name, ' ', c.last_name) AS full_name, COUNT(p.payment_id) AS pay_countpermonth, SUM(p.amount) AS pay_amount
  FROM payment AS p JOIN customer AS c
    ON p.customer_id = c.customer_id
 WHERE CONCAT(c.first_name, ' ', c.last_name) IN (SELECT full_name FROM Table1) GROUP BY 2, 1
 ORDER BY 2, 1;

-- Question 3)

WITH Table1 AS (
    SELECT CONCAT(c.first_name, ' ', c.last_name) AS full_name,
           SUM(p.amount) AS pay_amount FROM payment AS p
      JOIN customer AS c
        ON p.customer_id = c.customer_id
     GROUP BY 1
     ORDER BY 2 DESC
     LIMIT 10
),

Table2 AS (
    SELECT DATE_TRUNC('month', p.payment_date) AS pay_mon,
           CONCAT(c.first_name, ' ', c.last_name) AS full_name,
           SUM(p.amount) AS pay_amount FROM payment AS p
      JOIN customer AS c
        ON p.customer_id = c.customer_id
     WHERE CONCAT(c.first_name, ' ', c.last_name) IN (SELECT full_name FROM Table1)
     GROUP BY 2, 1
     ORDER BY 2, 1
)

SELECT pay_mon,
       full_name,
       pay_amount,
       pay_amount - LAG(pay_amount) OVER (PARTITION BY full_name) AS pay_amount_difference
  FROM Table2;