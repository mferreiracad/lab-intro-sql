use sakila;
-- How many films are there for each of the categories in the category table.
-- Use appropriate join to write this query.
SELECT c.name as "Category", count(f.film_id) as 'Number of films'
FROM sakila.film f -- table 1
JOIN sakila.film_category fc -- table 2
ON f.film_id = fc.film_id -- common column
JOIN sakila.category AS c
ON fc.category_id = c.category_id
group by Category;


-- Display the total amount rung up by each staff member in August of 2005.
SELECT sum(p.amount) as "Total", s.staff_id
FROM sakila.payment p -- table 1
JOIN sakila.staff s -- table 2
ON p.staff_id = s.staff_id
Where month(p.payment_date) = 8 and year(p.payment_date) = 2005
Group by staff_id;

-- Which actor has appeared in the most films?
SELECT concat(a.last_name,', ',a.first_name) as 'Name',
		count(fa.film_id) as 'Number of apperances'
FROM sakila.film f
JOIN sakila.film_actor fa
ON  fa.film_id=f.film_id
JOIN sakila.actor a
ON fa.actor_id=a.actor_id
GROUP BY Name
ORDER BY count(f.film_id) DESC
Limit 1;

-- Most active customer (the customer that has rented the most number of films)
SELECT concat(c.first_name, ' ', c.last_name) as 'Name',
		count(r.rental_id) as 'Number of rentals'
FROM sakila.customer c
JOIN sakila.rental r
ON  c.customer_id=r.customer_id
GROUP BY Name
ORDER BY count(r.rental_id) DESC
Limit 1;


-- Display the first and last names, as well as the address, of each staff member.
SELECT concat(s.first_name, ' ', s.last_name) as 'Name',
		a.address as 'Address',
        a.district
       -- a.location
FROM sakila.staff s
Join sakila.address a
On s.address_id = a.address_id
Group By s.staff_id;

-- List each film and the number of actors who are listed for that film.
SELECT film.title AS Film,
		count(film_actor.actor_id) AS Actors
FROM sakila.Film
JOIN sakila.film_actor ON sakila.film.film_id = sakila.film_actor.film_id
GROUP BY Film
ORDER BY Actors DESC
;

-- Using the tables payment and customer and the JOIN command, list the total paid by each customer.
-- List the customers alphabetically by last name.
Select concat(c.last_name,', ', c.first_name) as 'Name', sum(p.amount)
From sakila.payment p
Join sakila.customer c
On p.customer_id = c.customer_id
Group by Name
Order by Name;


-- List number of films per category.
SELECT c.name as "Category", count(f.film_id) as 'Number of films'
FROM sakila.film f -- table 1
JOIN sakila.film_category fc -- table 2
ON f.film_id = fc.film_id -- common column
JOIN sakila.category AS c
ON fc.category_id = c.category_id
group by Category;