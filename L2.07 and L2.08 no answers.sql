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
ON account_id = account_id
limit 10;

-- table aliasing

SELECT *
FROM bank.account a
JOIN bank.order o
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
ON a.account_id = o.account_id;

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
-- 1


-- 2


-- 3


-- 4

-- end Activity

-- -------------------------------------------
-- what if I want to ask "in a certain region, what % of accounts have orders"?
-- I need the info of the accounts with orders, but also the info on the accounts without orders
-- LEFT and RIGHT outer joins

SELECT *
FROM bank.account a
LEFT JOIN bank.order o
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
SELECT * FROM disp
SELECT * FROM card
SELECT * FROM client


SELECT *
FROM bank.disp d
JOIN bank.client c
ON d.client_id = c.client_id

SELECT *
FROM bank.disp d
JOIN bank.card c
ON d.disp_id = c.disp_id


SELECT *
FROM bank.disp d
JOIN bank.client c
ON d.client_id = c.client_id
JOIN bank.card ca
ON d.disp_id = ca.disp_id;

-- ACTIVITY 3.2.1
-- I want an overview of all clients (and their accounts,
-- together with district name) for the clients that are the OWNER of the account.





-- MULTIPLE OUTER JOINS
-- I want all average incomes (A11) of all clients with no credit card

SELECT cl.client_id, COUNT(DISTINCT ca.card_id) AS num_cards, di.A11 AS salary
FROM bank.card ca
RIGHT JOIN bank.disp d USING (disp_id)
INNER JOIN bank.client cl USING (client_id)
INNER JOIN bank.district di ON di.A1 = cl.district_id
group by client_id
having num_cards = 0;

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


