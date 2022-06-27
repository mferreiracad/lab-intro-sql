USE bank;

-- Lesson 2.07
-- JOINS
-- I want to get the number of accounts that have SIPO (household) orders per district

SELECT *
FROM bank.account;

SELECT *
FROM bank.order;

SELECT *
FROM bank.account
JOIN bank.order
ON bank.account.account_id = bank.order.account_id
limit 10;

-- does not run, to showcase ambiguity
SELECT *
FROM bank.account
JOIN bank.order
ON account_id = account_id -- Which account id is which?
limit 10;

-- table aliasing

SELECT *
FROM bank.account a -- creating the alias a for account
JOIN bank.order o -- creating the alias o for order
ON a.account_id = o.account_id
limit 10;

SELECT a.district_id , COUNT(a.account_id)
FROM bank.account a
JOIN bank.order o
ON a.account_id = o.account_id
WHERE o.k_symbol = 'SIPO'
GROUP BY a.district_id
ORDER BY a.district_id ASC;

-- we're done, right? Not so fast

SELECT COUNT(*)
FROM bank.account a
JOIN bank.order o
ON a.account_id = o.account_id
limit 10;

SELECT COUNT(account_id)
FROM bank.account;

SELECT COUNT(a.account_id)
FROM bank.account a
JOIN bank.order o
ON a.account_id = o.account_id;


SELECT COUNT(DISTINCT a.account_id)
FROM bank.account a
JOIN bank.order o
ON a.account_id = o.account_id;

-- what is going on?

SELECT a.district_id , COUNT(DISTINCT a.account_id)
FROM bank.account a
JOIN bank.order o
ON a.account_id = o.account_id
WHERE o.k_symbol = 'SIPO'
GROUP BY a.district_id
ORDER BY a.district_id ASC;

-- activity 2.8.3 - for the first 2 ask for name of district/region, for 3 just ID
-- Get a rank of districts ordered by the number of customers.
-- Get a rank of regions ordered by the number of customers.
-- Get the total amount borrowed by the district together with the average loan in that district.
-- Get the number of accounts opened by district and year.
-- 1
SELECT di.A2, count(c.client_id)
FROM bank.client c
JOIN bank.district di
ON di.A1 = c.district_id
GROUP BY di.A2
ORDER BY c.client_id ASC; -- missing the count!!!!!!!!!!!!!

-- 1. Get a rank of districts ordered by the number of customers
SELECT A2 as district_name, COUNT(client_id) #columns you want to display
FROM bank.district d # tables you need
JOIN bank.client c # tables you need
ON d.A1 = c.district_id #common column
GROUP BY d.A2 # group them by district_name
ORDER BY COUNT(client_id) DESC; #order them by number of clients

-- 2


-- 3
SELECT
	 T3.A2 AS District
	, SUM(T1.amount) AS total_amount_borrowed
    , AVG(T1.amount) AS average_loan
FROM
	bank.loan AS T1
JOIN bank.account as T2 on T1.account_id = T2.account_id 
JOIN district AS T3 on T2.district_id = T3.A1
GROUP BY
	T3.A2
;

-- 4

-- end Activity

-- -------------------------------------------
-- what if I want to ask "in a certain district, what % of accounts have orders"?
-- I need the info of the accounts with orders, but also the info on the accounts without orders
-- LEFT and RIGHT outer joins

SELECT *
FROM bank.account a
LEFT JOIN bank.order o -- inner join vs left join! NEED TO STUDY!!!
ON a.account_id = o.account_id;


SELECT a.district_id, COUNT(DISTINCT a.account_id)
FROM bank.account a
LEFT JOIN bank.order o
ON a.account_id = o.account_id
GROUP BY a.district_id;

SELECT a.district_id, COUNT(DISTINCT a.account_id)
FROM bank.account a
LEFT JOIN bank.order o
ON a.account_id = o.account_id
WHERE o.order_id IS NOT NULL
GROUP BY a.district_id;

-- now for an advanced trick - if we have time

SELECT *
FROM
(SELECT a.district_id, COUNT(DISTINCT a.account_id)
FROM bank.account a
LEFT JOIN bank.order o
ON a.account_id = o.account_id
GROUP BY a.district_id) all_accs
JOIN
(SELECT a.district_id, COUNT(DISTINCT a.account_id)
FROM bank.account a
LEFT JOIN bank.order o
ON a.account_id = o.account_id
WHERE o.order_id IS NOT NULL
GROUP BY a.district_id) w_orders
USING(district_id);

-- notice the differences in size. Why?

SELECT COUNT(*)
FROM bank.account a
LEFT JOIN bank.order o
ON a.account_id = o.account_id;

SELECT COUNT(*)
FROM bank.account a
RIGHT JOIN bank.order o
ON a.account_id = o.account_id;

-- so, what can cause these weird counts?
-- rows in one of the tables not having a match on the other and vice versa (reduces size)
-- rows in one table matching more than one row in the other (creates duplicates)
-- let's talk about relations

-- activity: fill in the ERD of bank


-- Lesson 2.08
-- MULTIPLE JOINS

-- I want the birtdate of all owners of classic cards
SELECT * FROM bank.disp;
SELECT * FROM bank.card;
SELECT * FROM bank.client;


SELECT *
FROM bank.disp d
JOIN bank.client c
ON d.client_id = c.client_id;

SELECT *
FROM bank.disp d
JOIN bank.card c
ON d.disp_id = c.disp_id;


SELECT d.client_id, c.birth_number, left(c.birth_number,2) as year, SUBSTRING(c.birth_number, 3, 2) as month,
SUBSTRING(c.birth_number, 5, 2) as day,
CASE
When SUBSTRING(c.birth_number, 3, 2) > 12 then SUBSTRING(c.birth_number, 3, 2)-50
else SUBSTRING(c.birth_number, 3, 2)
end
FROM bank.disp d
JOIN bank.client c
ON d.client_id = c.client_id
JOIN bank.card ca
ON d.disp_id = ca.disp_id
Where ca.type = 'classic'
and d.type = 'owner';

-- jan's answer:
WHEN (substring(c.birth_number,3,2) >50)
THEN CONVERT(CONCAT('19', left(c.birth_number,2),
LPAD(substring(c.birth_number,3,2)-50,2,0), right(c.birth_number,2)),DATE);

-- ACTIVITY 3.2.1
-- I want an overview of all clients (and their accounts,
-- together with district name) for the clients that are the OWNER of the account.

SELECT c.client_id, di.account_id, d.A2 as 'District'
FROM bank.disp di
JOIN bank.client c
ON di.client_id = c.client_id
JOIN bank.district d
ON c.client_id = d.A1
WHERE di.type = 'OWNER';



-- MULTIPLE OUTER JOINS
-- I want all average incomes (A11) of all clients with no credit card

SELECT cl.client_id, -- COUNT(DISTINCT ca.card_id) AS num_cards,
       di.A11 AS salary
FROM bank.disp d
RIGHT JOIN bank.card ca USING (disp_id)
INNER JOIN bank.client cl USING (client_id)
INNER JOIN bank.district di ON di.A1 = cl.district_id
group by client_id
having COUNT(DISTINCT ca.card_id) = 0;

-- SELF JOINS
-- find accounts that are from the same district

SELECT *
FROM bank.account a1
JOIN bank.account a2
ON (a1.account_id <> a2.account_id) AND (a1.district_id = a2.district_id)
ORDER BY a1.district_id;

SELECT a1.account_id, a2.account_id, a1.district_id
FROM bank.account a1
JOIN bank.account a2
ON (a1.account_id <> a2.account_id) AND (a1.district_id = a2.district_id)
ORDER BY a1.district_id;

-- Activity 3.3.1
-- I want an overview of disponents of accounts with the owners of those accounts
SELECT d1.disp_id , d1.client_id as "Disponent's id",d1.account_id as "Account",
a1.frequency,a1.date, d2.client_id as "Owner's id"
FROM bank.disp d1
JOIN bank.disp d2
ON (d1.account_id = d2.account_id) AND (d1.type != d2.type)
JOIN bank.account a1
ON d1.account_id = a1.account_id
Where d1.type = 'DISPONENT'
ORDER BY d1.account_id
;

