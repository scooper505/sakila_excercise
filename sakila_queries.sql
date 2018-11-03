USE sakila;

/* 1A */
/* 1A */
SELECT * FROM actor;


/* 1B: First and last from actor */
SELECT concat(first_name," ", last_name) as "Actor Name"
FROM actor;



/* 2A: F#Find the ID Number and the full name of actor with name Joe */
SELECT actor_id, concat(first_name," ", last_name) as "full name"
FROM actor
WHERE first_name Like "Joe%"


/* 2B */
SELECT concat(first_name," ", last_name) as "full name"
FROM actor 
WHERE last_name like "%GEN%";


/* 2C lnames that have 'Li' */
SELECT last_name, first_name
FROM actor
WHERE last_name like "%LI%"
ORDER BY last_name, first_name;

/* 2D */
SELECT country_id, country 
FROM country
WHERE country IN (Afghanistan, Bangladesh, China)

/* 3A */
ALTER TABLE actor
ADD COLUMN description BLOB AFTER last_name;

/* 3B */
ALTER TABLE actor
DROP COLUMN description;

/* 4A */
SELECT COUNT(last_name) 
FROM actor
GROUP BY last_name;

/* 4B */
SELECT COUNT(last_name) 
FROM actor
GROUP BY last_name
HAVING COUNT(last_name) > 2;

UPDATE actor
SET first_name= 'HARPO'
WHERE first_name= 'GROUCHO' AND last_name = 'WILLIAMS';


SET SQL_SAFE_UPDATES = 0;
UPDATE actor SET first_name = 'GROUCHO' WHERE first_name = 'HARPO';

SHOW CREATE TABLE address;

/* 1A */
SELECT staff.first_name, staff.last_name, address.address
FROM staff
LEFT JOIN address
	ON staff.address_id = address.address_id;

/* 1A */
SELECT staff.first_name, staff.last_name, SUM(payment.amount) as total
FROM staff
JOIN payment
	ON staff.staff_id = payment.staff_id
WHERE payment.payment_date LIKE '2005-08-%'
GROUP BY staff.staff_id;

-- 5c --

/* 6C: List each film and actor count for each film */
SELECT DISTINCT film.title, COUNT(film_actor.actor_id)
FROM film 
INNER JOIN film_actor
	ON film.film_id = film_actor.film_id
GROUP BY film.title;


/* 6E: # copies of the film `Hunchback Impossible` in inventory system */
SELECT COUNT(film_id) AS hunchback_imp_copies
FROM inventory
WHERE film_id IN 
(
  SELECT film_id
  FROM film 
  WHERE title = "Hunchback Impossible"
 );


/* 6D: total paid by each customer */
SELECT CONCAT(customer.first_name," ", customer.last_name) AS full_name, SUM(payment.amount) AS total_paid
FROM customer
LEFT JOIN payment
	ON customer.customer_id = payment.customer_id
GROUP BY full_name ASC;


/* 7A: titles of movies starting with the letters `K` and `Q` in English */
SELECT title 
FROM film
WHERE title LIKE 'K%' or title LIKE 'Q%'
	AND language IN 
	  (SELECT language_id
	   FROM lnames
	   WHERE language = 'English'
		);

/* 7B: all actors from alone trip */
SELECT CONCAT(first_name," ", last_name) AS actor_full_name
FROM actor
WHERE actor_id IN
  (SELECT actor_id
  	FROM film_actor
  	WHERE film_id IN
  	(SELECT film_id
  		FROM film
  		WHERE title = 'Alone Trip'));


/* 7C: all Canadian customers contact info */
SELECT CONCAT(customer.first_name, " ", customer.last_name) as cust_name, customer.email, country.country 
FROM customer
JOIN address
	ON customer.address_id = address.address_id
	JOIN city
		ON address.city_id = city.city_id
		JOIN country
			ON city.country_id = country.country_id
WHERE country = "Canada";

/* 7D: famliy categorized films  */
SELECT title 
FROM film
WHERE film_id IN
(
  SELECT film_id
  FROM film_category
  WHERE category_id IN
  (
  	SELECT category_id
  	FROM category
  	WHERE name = "Family"
  	)
 );


/* 7E: most frequently rented movies  */
SELECT film.title, COUNT(film.film_id) AS rental_count
FROM film
JOIN inventory
	ON film.film_id = inventory.film_id
	JOIN rental 
		ON inventory.inventory_id = rental.inventory_id
GROUP BY film.title
ORDER BY rental_count DESC;


/* 7E: business in dollars for each store */

SELECT customer.store_id AS store_id, SUM(payment.amount) AS total_revenue
FROM customer
JOIN payment
	ON customer.customer_id = payment.customer_id
GROUP BY customer.store_id;
