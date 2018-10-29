USE sakila;

SELECT * FROM actor;

SELECT concat(first_name," ", last_name) as "Actor Name"
FROM actor;

#Find the ID Number and the full name of actor with name Joe

SELECT actor_id, concat(first_name," ", last_name) as "full name"
FROM actor
WHERE first_name Like "Joe%"