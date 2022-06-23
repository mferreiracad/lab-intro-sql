use sakila;

-- In the table actor, which are the actors whose last names are not repeated?
-- For example if you would sort the data in the table actor by last_name, you would see that there
-- is Christian Arkoyd, Kirsten Arkoyd, and Debbie Arkoyd. These three actors have the same last name.
-- So we do not want to include this last name in our output. Last name "Astaire" is present only one time
-- with actor "Angelina Astaire", hence we would want this in our output list.
SELECT sakila.actor.first_name as 'First Name', sakila.actor.last_name as 'Last Name'
FROM sakila.actor
GROUP BY last_name, first_name
Having COUNT(sakila.actor.last_name) = 1;


-- Which last names appear more than once? We would use the same logic as in the previous question but
-- this time we want to include the last names of the actors where the last name was present more than once
SELECT sakila.actor.first_name as 'First Name', sakila.actor.last_name as 'Last Name'
FROM sakila.actor
GROUP BY last_name, first_name
Having COUNT(sakila.actor.last_name) > 1;
select last_name from sakila.actor;
-- I'm not thinking properly....this one is obviously wrong...but, right now, I can't figure it out...

-- Using the rental table, find out how many rentals were processed by each employee.
SELECT sakila.staff.staff_id, concat(sakila.staff.First_Name, ' ' , sakila.staff.Last_Name) AS 'Fullname',
count(sakila.rental.rental_id) AS Rentals
FROM sakila.rental
Join staff on rental.staff_id = staff.staff_id
GROUP BY 'Fullname', staff_id;

-- Using the film table, find out how many films were released each year.
-- I want to count the distinct films release each year.
-- Select release_year and a count of the distinct films titles...
-- Group them by release_year
SELECT sakila.film.release_year as 'Release Year', count(distinct(sakila.film.title)) AS Films
FROM sakila.film
GROUP BY release_year;
-- There's only one year...

-- Using the film table, find out for each rating how many films were there.
SELECT sakila.film.rating, count(sakila.film.rating) AS 'Count'
FROM sakila.film
GROUP BY sakila.film.rating;

-- What is the mean length of the film for each rating type. Round off the average lengths to two decimal places
SELECT sakila.film.rating, ROUND(AVG(sakila.film.length),2) AS 'Average Length'
FROM sakila.film
GROUP BY sakila.film.rating;

-- Which kind of movies (rating) have a mean duration of more than two hours?
SELECT sakila.film.rating, AVG(sakila.film.length) AS Average
FROM sakila.film
GROUP BY sakila.film.rating
HAVING Average > 120;
-- This dosn't work with quotes...why???


-- Rank films by length (filter out the rows that have nulls or 0s in length column).
-- In your output, only select the columns title, length, and the rank.
SELECT DENSE_RANK() OVER(ORDER BY length DESC) AS 'Ranking', sakila.film.title, sakila.film.length
FROM sakila.film WHERE length IS NOT NULL AND length != 0
ORDER BY length DESC;