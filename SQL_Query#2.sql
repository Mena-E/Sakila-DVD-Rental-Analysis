QUERY #2

SELECT category_name, SUM(rental_count) rental_count
FROM(SELECT DISTINCT(f.title) film_title,
       c.name category_name,
       COUNT(r.rental_date) OVER (PARTITION BY f.title ORDER BY f.title) AS rental_count
FROM category c
JOIN film_category fc
ON fc.category_id = c.category_id
JOIN film f
ON f.film_id = fc.film_id
JOIN inventory i
ON i.film_id = f.film_id
JOIN rental r
ON i.inventory_id = r.inventory_id
ORDER BY c.name, f.title) sub
GROUP BY 1
ORDER BY 2 DESC
