use sakila;

-- Select all the actors with the first name ‘Scarlett’.
SELECT * FROM actor WHERE first_name = 'Scarlett';

-- How many films (movies) are available for rent and how many films have been rented?
-- I think this are two different questions..
-- It is being asked how many films are there to rent and not how many films are in the system of sakila.
-- So, I'm only counting with those films that are in the sakila inventory...and not in the sakira's list
-- of movies...But we can check:
SELECT COUNT(DISTINCT(film_id)) FROM sakila.film;
-- There are 1000 films in the sakila's list. Let's see how many are in the inventory:
SELECT COUNT(DISTINCT(film_id)) FROM sakila.inventory;
-- Only 958, so this number is the number of films that are available for renting...the difference, 42 films,
-- are films that sakila don't have (maybe these number represents films that are arriving to the store)
-- For the last part of the question, we want to see how many films have been rented...so, we want a count
-- of the rental_id, or we could use the max of rental_id ...
SELECT COUNT(rental_id) FROM sakila.rental;
SELECT max(rental_id) FROM sakila.rental;
-- Actually, there's a mistake somewhere in rental_id, since we are missing 5 entries when we do the count
-- Maybe, some of the entries have been erased from the dataset, that's the only reason to have a higher
-- number of rental_id's.
-- Jose told me that he understands this question as 'How many films are being rented right now',
-- if that's the case...I'm looking for NULLs
SELECT * FROM sakila.rental WHERE return_date IS NULL; -- 183 films not returned
-- to be sure...
SELECT return_date FROM sakila.rental; -- from a total of 16044
SELECT * FROM sakila.rental WHERE return_date is not null; -- where 15861 have already been returned

-- What are the shortest and longest movie duration? Name the values max_duration and min_duration.
-- SELECT title, min(length) as min_duration, max(length) as max_duration FROM film;
-- So I didn't know how to answer this one, so with the help of Philip I discovered a new method
-- and I decided to cheat and apply it here...
-- So I'm doing a union of two different tables. I know that this can be done in a different manner.
SELECT * FROM
(SELECT 'min_duration' AS '', sakila.film.title, sakila.film.length
FROM sakila.film -- first table to access
ORDER BY sakila.film.length ASC -- ascending order to have the lowest value first
LIMIT 1 -- limiting the results to one
) AS table_1 -- giving the table a name
UNION -- merging min_table with max_table
SELECT * FROM
(SELECT 'max_duration' AS '', sakila.film.title, sakila.film.length
FROM sakila.film -- second table to access
ORDER BY sakila.film.length DESC -- descending order to have the highest value first
LIMIT 1 -- limiting the number of results to one
) AS table_2; -- giving the table a name

-- What's the average movie duration expressed in format (hours, minutes)?
-- This is not right...this is 1 minute and 15 seconds...
SELECT CONVERT(AVG(length),TIME) AS "hours:minutes" FROM sakila.film;
-- But when I try to multiply the length by 60, or even the avg(length) by 60, I receive a NULL value...
-- I have to look into this one again...later...

-- How many distinct (different) actors' last names are there?
SELECT COUNT(DISTINCT(last_name)) FROM actor;
-- This one its easy...

-- Since how many days has the company been operating (check DATEDIFF() function)?
SELECT DATEDIFF(max(rental_date), min(rental_date)) AS days FROM sakila.rental;
-- I believe that the first data of operation is coincident with the first rental...or the first payment...
SELECT DATEDIFF(max(payment_date), min(payment_date)) AS days FROM sakila.payment;
-- or the first customer entry
SELECT DATEDIFF(max(create_date), min(create_date)) AS days FROM sakila.customer;
-- Actually, all the customers accounts were created on the same day...thats weird...I guess the
-- dataset is a bit "random" and only for 'trainning' purposes...

-- Show rental info with additional columns month and weekday. Get 20 results.
-- I have to create two new colums...one for month and one for day of the week...
SELECT *,
date_format(CONVERT(left(rental_date,23),date), '%M') AS 'Month', -- This converts the format of the date 
																-- and returns it as a Month ('%M')
date_format(CONVERT(left(rental_date,23),date), '%W') AS 'Weekday' -- This converts the format of the date
																	-- and returns it as a day of the week
FROM sakila.rental LIMIT 20; -- this limits the results to 20


-- Add an additional column day_type with values 'weekend' and 'workday' depending on the rental day of the week.
-- I will just copy the previous one and add the case method...
SELECT *, date_format(CONVERT(LEFT(rental_date,23),DATE), '%M') AS 'Month',
date_format(CONVERT(LEFT(rental_date,23),DATE), '%W') AS 'Weekday',
CASE
WHEN date_format(CONVERT(left(rental_date,23),DATE), '%W') = ('Tuesday' | 'Monday' | 'Wednesday' | 'Friday' | 'Thursday') then 'Week'
ELSE 'Weekend' -- If any of the previous conditions is true, then it was rented during the weekend
END AS 'Week / Weekend' -- name of the new column
FROM sakila.rental LIMIT 20; -- limiting to 20 results

-- Get release years.
SELECT DISTINCT(release_year) FROM sakila.film;
-- need no coments...

-- Get all films with ARMAGEDDON in the title.
SELECT * FROM sakila.film WHERE title LIKE '%ARMAGEDDON%';
-- need no coments...

-- Get all films which title ends with APOLLO.
SELECT * FROM sakila.film WHERE title LIKE '%APOLLO';
-- need no coments...

-- Get 10 the longest films.
SELECT film.title, film.length FROM sakila.film ORDER BY length DESC LIMIT 10;
-- It only asks for the film but I decided to put also the length 

-- How many films include Behind the Scenes content?
SELECT COUNT(*) FROM sakila.film WHERE special_features LIKE '%Behind the Scenes%';
-- This is a count of all films that contain 'behind the scenes' as a special feature...538
-- If I wanted a list of films with only behind the scenes as a special feature...
SELECT COUNT(*) FROM sakila.film WHERE special_features = 'Behind the Scenes'
-- only 70 have only behind the scenes as a unique special_feature


