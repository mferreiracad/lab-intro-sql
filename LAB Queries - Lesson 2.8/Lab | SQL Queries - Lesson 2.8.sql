use sakila;
-- Write a query to display for each store its store ID, city, and country.
select s.store_id, c.city, co.country
from sakila.store s
join sakila.address a
	on s.address_id = a.address_id
join sakila.city c
	on c.city_id = a.city_id
join sakila.country co
	on co.country_id = c.country_id;

-- Write a query to display how much business, in dollars, each store brought in.
select sto.store_id as Store, concat('$ ',sum(p.amount)) as Total
from sakila.store sto
join sakila.staff sta
	on sto.store_id = sta.store_id
join sakila.payment p
	on sta.staff_id = p.staff_id
group by Store;

-- Which film categories are longest?
select c.name as Category, avg(f.length) as Avg_Length
from sakila.category c
join sakila.film_category fc
	on c.category_id = fc.category_id
join sakila.film f
	on fc.film_id = f.film_id
Group by category
Order by Avg_Length Desc
Limit 3;

-- Display the most frequently rented movies in descending order.
select f.title as Title, count(r.rental_id) as Frequency
From sakila.rental r
Join sakila.inventory i
	on r.inventory_id = i.inventory_id
Join sakila.film f
	on f.film_id = i.film_id
group by title
order by Frequency desc;

-- List the top five genres in gross revenue in descending order.
Select c.name As Category, sum(p.amount) as Gross_Revenue
From sakila.payment p
Join sakila.rental r
	on r.rental_id = p.rental_id
Join sakila.inventory i
	on i.inventory_id = r.inventory_id
Join sakila.film f
	on f.film_id = i.film_id
Join sakila.film_category fc
	on fc.film_id = f.film_id
Join sakila.category c
	on c.category_id = fc.category_id
Group by Category
Order by Gross_Revenue Desc
Limit 5;

-- Is "Academy Dinosaur" available for rent from Store 1?
Select i.store_id as Store, f.title as Title, count(i.inventory_id) as Stock
From sakila.inventory i
Join sakila.film f
	on f.film_id = i.film_id
Join sakila.store s
	on s.store_id = i.store_id
Where f.title = "Academy Dinosaur" and i.store_id = 1
Group by i.store_id;

-- Get all pairs of customers that have rented the same film more than 3 times.
SELECT f.title,cust1, cust2
FROM(
	SELECT film_id,cust1,cust2,COUNT(*) OVER (PARTITION BY film_id) ct
	FROM(
		SELECT r1.inventory_id film_id,r1.customer_id cust1,r2.customer_id cust2
		FROM rental r1
		JOIN rental r2
			ON r1.inventory_id = r2.inventory_id AND r1.customer_id <> r2.customer_id) d1
		WHERE cust1 < cust2) d2
		JOIN film f
			ON d2.film_id = f.film_id
 WHERE ct > 3;

-- For each film, list actor that has acted in more films.
SELECT film_id,a.first_name,a.last_name
FROM(
	SELECT film_id,actor_id,'number',MAX('number')
    OVER (PARTITION BY film_id) max_for_film
	FROM(
		SELECT fc.film_id,fc.actor_id, COUNT(*) OVER (PARTITION BY fc.actor_id) 'number'
		FROM film_actor fc
		ORDER BY fc.film_id)sq1
    )sq2
JOIN actor a
	ON sq2.actor_id = a.actor_id
WHERE 'number' = max_for_film;

-- Get all pairs of actors that worked together.
SELECT fa1.actor_id AS Actor1, concat(a1.first_name,' ',a1.last_name),
		fa2.actor_id AS Actor2, concat(a2.first_name,' ',a2.last_name)
FROM sakila.film_actor AS fa1
JOIN sakila.film_actor AS fa2
	ON fa1.actor_id != fa2.actor_id
JOIN sakila.actor as a1
	ON a1.actor_id = fa1.actor_id
JOIN sakila.actor as a2
	ON a2.actor_id = fa2.actor_id
WHERE fa1.actor_id < fa2.actor_id     
	AND fa1.film_id = fa2.film_id;