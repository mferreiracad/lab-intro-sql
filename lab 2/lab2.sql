use sakila;

-- Select all the actors with the first name ‘Scarlett’.
SELECT * FROM actor WHERE first_name = 'Scarlett';

-- How many films (movies) are available for rent and how many films have been rented?
SELECT COUNT(DISTINCT(film_id)) FROM sakila.inventory;
SELECT COUNT(rental_id) FROM sakila.rental;


-- What are the shortest and longest movie duration? Name the values max_duration and min_duration.
-- SELECT title, min(length) as min_duration, max(length) as max_duration FROM film;

Select *
From
(SELECT 'max_duration' as '', sakila.film.title, sakila.film.length
From sakila.film
Order By sakila.film.length desc
limit
1
) as t1
union
select *
From
(SELECT 'min_duration' as '', sakila.film.title, sakila.film.length
From sakila.film
Order By sakila.film.length asc
limit
1
) as t2;

-- What's the average movie duration expressed in format (hours, minutes)?
select convert(avg(length),time) as "hours:minutes" from sakila.film;

-- How many distinct (different) actors' last names are there?
SELECT COUNT(DISTINCT(last_name)) FROM actor;

-- Since how many days has the company been operating (check DATEDIFF() function)?
SELECT DATEDIFF(max(rental_date), min(rental_date)) AS days FROM sakila.rental;

-- Show rental info with additional columns month and weekday. Get 20 results.
SELECT *, date_format(CONVERT(left(rental_date,23),date), '%M') AS 'Month',
date_format(CONVERT(left(rental_date,23),date), '%W') AS 'Weekday'
FROM sakila.rental limit 20;
-- Add an additional column day_type with values 'weekend' and 'workday' depending on the rental day of the week.
SELECT *, date_format(CONVERT(left(rental_date,23),date), '%M') AS 'Month',
date_format(CONVERT(left(rental_date,23),date), '%W') AS 'Weekday',
CASE
WHEN date_format(CONVERT(left(rental_date,23),date), '%W') = 'Tuesday' then 'Week'
WHEN date_format(CONVERT(left(rental_date,23),date), '%W') = 'Monday' then 'Week'
WHEN date_format(CONVERT(left(rental_date,23),date), '%W') = 'Wednesday' then 'Week'
WHEN date_format(CONVERT(left(rental_date,23),date), '%W') = 'Friday' then 'Week'
WHEN date_format(CONVERT(left(rental_date,23),date), '%W') = 'Thursday' then 'Week'
ELSE 'Weekend'
END AS 'day'
FROM sakila.rental limit 20;

-- Get release years.
SELECT Distinct(release_year) FROM sakila.film;

-- Get all films with ARMAGEDDON in the title.
SELECT * FROM sakila.film WHERE title LIKE '%ARMAGEDDON%';

-- Get all films which title ends with APOLLO.
SELECT * FROM sakila.film WHERE title LIKE '%APOLLO';

-- Get 10 the longest films.
SELECT film.title, film.length FROM sakila.film ORDER BY length DESC LIMIT 10;

-- How many films include Behind the Scenes content?special_featuresspecial_features?
SELECT COUNT(*) FROM sakila.film WHERE special_features LIKE '%Behind the Scenes%';