-- Question 1)

WITH Table1 AS ( 
    SELECT f.title,
           c.name AS category,
           r.rental_id
      FROM film AS f
      JOIN film_category AS fa
        ON f.film_id = fa.film_id JOIN category AS c
        ON fa.category_id = c.category_id JOIN inventory AS i
        ON f.film_id = i.film_id JOIN rental AS r
        ON i.inventory_id = r.inventory_id )

SELECT title, category,
       COUNT(rental_id) FROM Table1
 WHERE category IN ('Animation', 'Children', 'Classics', 'Comedy', 'Family', 'Music')
 GROUP BY 1, 2
 ORDER BY 2, 1;

-- Question 2)

SELECT f.title,
       c.name AS category,
       f.rental_duration,
       NTILE(4) OVER (ORDER BY f.rental_duration) AS standard_quartile
  FROM film AS f
  JOIN film_category AS fa
    ON f.film_id = fa.film_id JOIN category AS c
    ON fa.category_id = c.category_id
 WHERE c.name IN ('Animation', 'Children', 'Classics', 'Comedy', 'Family', 'Music');

-- Question 3)

WITH Table1 AS (
    SELECT c.name AS category,
           NTILE(4) OVER (ORDER BY f.rental_duration) AS standard_quartile FROM film AS f
      JOIN film_category AS fa
        ON f.film_id = fa.film_id JOIN category AS c
        ON fa.category_id = c.category_id
     WHERE c.name IN ('Animation', 'Children', 'Classics', 'Comedy', 'Family', 'Music')
)

SELECT category, 
       standard_quartile, 
       COUNT(standard_quartile)
  FROM Table1
 GROUP BY 1, 2
 ORDER BY 1, 2;