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
select c1.customer_id as id1,concat(c1.last_name,', ',c1.first_name),
		c2.customer_id as id2,concat(c2.last_name,', ',c2.first_name), count(*) as num_films
from sakila.customer c1
join rental r1 
	on r1.customer_id = c1.customer_id
join inventory i1
	on r1.inventory_id = i1.inventory_id
join film f1 
	on i1.film_id = f1.film_id
join inventory i2 on 
i2.film_id = f1.film_id
join rental r2 
	on r2.inventory_id = i2.inventory_id
join customer c2 
	on r2.customer_id = c2.customer_id
where c1.customer_id < c2.customer_id
group by c1.customer_id, c2.customer_id
having count(*) > 3
order by num_films desc;

-- For each film, list actor that has acted in more films.


-- Get all pairs of actors that worked together.

-- It's not working...I haven't figured out how to filter this in a way that a pair just appears once.
SELECT fa1.actor_id AS Actor1_id, concat(a1.first_name, ' ', a1.last_name) as Name1,
	concat(a2.first_name, ' ',a2.last_name) as Name2, fa2.actor_id AS Actor2_id, f.title
FROM sakila.film_actor AS fa1
JOIN sakila.film_actor AS fa2
	ON fa1.actor_id != fa2.actor_id
Join sakila.actor As a1
	on a1.actor_id = fa1.actor_id
Join sakila.actor as a2
	on a2.actor_id = fa2.actor_id
Join sakila.film f
	on fa1.film_id = f.film_id
WHERE fa1.actor_id < fa2.actor_id AND fa1.film_id = fa2.film_id;	

-- Get all possible pairs of actors and films.
select concat(a.last_name,', ', a.first_name) as Name, f.title as Title
from sakila.actor a
join sakila.film as f;