QUERY #4

SELECT rating AS film_rating,
SUM(film_length) AS total_length,
SUM(movie_rev) AS total_sales
FROM(SELECT f.rating, f.length AS film_length, p.amount AS movie_rev
      FROM film f
      JOIN inventory i
      ON f.film_id = i.film_id
      JOIN rental r
      ON i.inventory_id = r.inventory_id
      JOIN payment p
      ON r.rental_id = p.rental_id
      ORDER BY 3 DESC) sub
GROUP BY 1
ORDER BY 3 DESC
