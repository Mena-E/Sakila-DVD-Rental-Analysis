QUERY#3

WITH t1 AS(SELECT i.store_id store_id, c.city AS city_1, SUM(p.amount) AS amount_1
            FROM city c
            JOIN address a
            ON c.city_id = a.city_id
            JOIN customer cus
            ON a.address_id = cus.address_id
            JOIN payment p
            ON cus.customer_id = p.customer_id
            JOIN rental r
            ON r.rental_id = p.rental_id
            JOIN inventory i
            ON i.inventory_id = r.inventory_id
            WHERE DATE_PART('year',p.payment_date) = '2007' AND i.store_id = '1'
            GROUP BY 1, 2
            ORDER BY 3 DESC
            LIMIT 25),

      t2 AS(SELECT i.store_id store_id, c.city AS city_2, SUM(p.amount) AS amount_2
            FROM city c
            JOIN address a
            ON c.city_id = a.city_id
            JOIN customer cus
            ON a.address_id = cus.address_id
            JOIN payment p
            ON cus.customer_id = p.customer_id
            JOIN rental r
            ON r.rental_id = p.rental_id
            JOIN inventory i
            ON i.inventory_id = r.inventory_id
            WHERE DATE_PART('year',p.payment_date) = '2007' AND i.store_id = '2'
            GROUP BY 1, 2
            ORDER BY 3 DESC
            LIMIT 25),

      t3 AS(SELECT t1.city_1 city_name, t1.amount_1 AS amount_spent
            FROM t1
            JOIN t2
            ON t1.city_1 = t2.city_2
            ORDER BY 2 DESC),

      t4 AS(SELECT city_name, amount_spent AS sales_2007,
            CASE WHEN amount_spent > 60 THEN 1000
            ELSE 0 END AS total_ad_budget
            FROM t3
            ORDER BY 2 DESC),

      t5 AS(SELECT city_name, sales_2007,
            SUM(sales_2007) OVER() AS total_sales, total_ad_budget
            FROM t4
            ORDER BY 2 DESC)

SELECT city_name, sales_2007,
      (sales_2007/total_sales) * total_ad_budget AS share_ad_budget
FROM t5
ORDER BY 2 DESC
