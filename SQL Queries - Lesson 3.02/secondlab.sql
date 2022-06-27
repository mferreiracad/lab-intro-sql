use sakila;
-- How many copies of the film Hunchback Impossible exist in the inventory system?
select count(i.inventory_id) as Copies
from inventory i
where film_id = (
	select film_id
    from sakila.film
	where title = 'Hunchback Impossible');

-- List all films whose length is longer than the average of all the films.
SELECT title FROM sakila.film
where film.length > (
  select avg(film.length)
	from film
);

-- Use subqueries to display all actors who appear in the film Alone Trip.

Select concat(actor.last_name,', ', actor.first_name) as Actor
from sakila.actor 
Where actor_id in (
	select film_actor.actor_id from sakila.film_actor
    where film_id = (
		select film_id from  sakila.film
			where film.title = 'Alone Trip'
        )
);

-- Sales have been lagging among young families, and you wish to target all family movies for a promotion.
-- Identify all movies categorized as family films.
Select title
from sakila.film 
Where film.film_id in (
	select film_category.film_id from sakila.film_category
    where category_id = (
		select category.category_id from  sakila.category
			where category.name = 'family'
        )
);

-- Get name and email from customers from Canada using subqueries.
-- Do the same with joins. Note that to create a join, you will have to identify the correct
-- tables with their primary keys and foreign keys, that will help you get the relevant information.
Select concat(last_name, ', ',first_name) as Name, email
From sakila.customer
Where address_id in(
Select address_id
from sakila.address 
Where address.city_id in (
	select city.city_id from sakila.city
    where country_id = (
		select country.country_id from  sakila.country
			where country.country = 'Canada'
        )
)
);

Select concat(last_name, ', ',first_name) as Name, email
From sakila.customer c
join sakila.address a
	on c.address_id = a.address_id
join sakila.city ci
	on ci.city_id = a.city_id
join country co
	on co.country_id = ci.country_id
Where co.country = 'Canada';


-- Which are films starred by the most prolific actor? Most prolific actor is
-- defined as the actor that has acted in the most number of films. First you will
-- have to find the most prolific actor and then use
-- that actor_id to find the different films that he/she starred.
SELECT film.title
FROM sakila.film
WHERE film_id IN
	(SELECT film_actor.film_id
	FROM sakila.film_actor
	WHERE film_actor.actor_id IN
		(SELECT tb1.actor_id 
        FROM (
			SELECT	actor_id
				, count(film_actor.film_id) AS counts
			FROM film_actor
			GROUP BY actor_id
			ORDER BY counts DESC
			Limit 1
		) as tb1));
        
-- Films rented by most profitable customer. You can use the customer table and payment table to
-- find the most profitable customer ie the customer that has made the largest sum of payments
SELECT film.title
FROM sakila.film
WHERE film.film_id IN(
    SELECT inventory.film_id
	FROM sakila.inventory
	WHERE inventory.inventory_id IN(
		SELECT rental.inventory_id
		FROM sakila.rental
		WHERE rental.customer_id IN(
			SELECT tb1.customer_id 
			FROM(
				SELECT payment.customer_id, sum(payment.amount) AS pay
				FROM sakila.payment
				GROUP BY payment.customer_id
				ORDER BY pay DESC
				LIMIT 1) AS tb1)));
                
-- Customers who spent more than the average payments.
select concat(last_name, ', ', first_name) as Name from sakila.customer
where customer_id in (
	select customer_id
    from rental
    where RENTAL_ID IN(
		SELECT rental_id
		FROM sakila.payment
		where payment.amount > (
			select avg(payment.amount)
			from payment)));