use sakila;

ALTER TABLE staff
DROP COLUMN picture;

select * from sakila.customer
where first_name = 'Tammy' and last_name = 'Sanders';

INSERT INTO staff(store_id,username, first_name, last_name, address_id, email) 
VALUES
(2,'TAMMY','TAMMY','SANDERS',79,'TAMMY.SANDERS@sakilacustomer.org');

select * from staff;
select * from customer where first_name = 'Charlotte' and last_name ='Hunter';
select* from inventory where film_id = 1;

INSERT INTO rental(rental_date,inventory_id, customer_id, staff_id) 
VALUES
(now(),4,'130',1);

