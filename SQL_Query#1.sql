QUERY #1

SELECT DATE_TRUNC('month', p.payment_date) AS pay_mon,
CONCAT(c.first_name,' ',c.last_name) AS fullname,
COUNT(*) AS pay_countpermonth,
SUM(p.amount) AS pay_amount
FROM customer c
JOIN payment p
ON c.customer_id = p.customer_id
JOIN(SELECT customer_id cust_id, COUNT(*) pay_countpermonth, SUM(amount) pay_amount
    FROM payment
    GROUP BY 1
    ORDER BY 3 DESC
    LIMIT 10) t1
ON c.customer_id = t1.cust_id
WHERE DATE_PART('year', p.payment_date) = '2007'
GROUP BY 1, 2
ORDER BY 2
