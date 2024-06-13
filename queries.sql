-- COUNT NUMBER OF MEDICATION SUPPLIED
SELECT s.supplier_name, COUNT(*) AS total_items_supplied
FROM pharmacy.suppliers s
JOIN pharmacy.inventory i ON s.supplier_name = i.supplier_name
GROUP BY s.supplier_name;

-- SHOW SPECIFIC BASKET OF PATIENT
SELECT bi.medicine_name, bi.amount
FROM pharmacy.basket_items bi
JOIN pharmacy.basket b ON bi.basket_id = b.basket_id
WHERE b.insurance_number = 9944428914;

-- CALCULATE TOTAL PRICE OF BASKETS
SELECT b.basket_id, SUM(M.price * b.amount) AS total_price FROM pharmacy.basket b1
JOIN pharmacy.basket_items b ON b1.basket_id = b.basket_id
JOIN pharmacy.medicine m ON m.medicine_name = b.medicine_name
GROUP BY b.basket_id;

-- SHOW NAME AND AGE OF PATIENT WHO BOUGHT FROM CERTAIN SUPPLIER
SELECT DISTINCT p.first_name, p.last_name, p.age
FROM pharmacy.patients p
JOIN pharmacy.basket b ON p.insurance_number = b.insurance_number
JOIN pharmacy.basket_items bi ON b.basket_id = bi.basket_id
JOIN pharmacy.inventory i ON bi.medicine_name = i.medicine_name
WHERE i.supplier_name = 'Sun Pharmaceutical Industries Limited';

-- SHOW NAMES OF MEDICINE AND THEIR PRICES AND THEIR SUPPLIERS
SELECT i.medicine_name, i.price, s.supplier_name
FROM pharmacy.inventory i
JOIN pharmacy.suppliers s ON i.supplier_name = s.supplier_name;

-- SHOW EMPLOYEES AND THEIR SALARIES
SELECT e.first_name, e.last_name, j.position, j.salary
FROM pharmacy.employees e
JOIN pharmacy.jobs j ON e.employee_number = j.employee_number;

-- GET PATIENTS WHO BOUGHT MEDICINE OF CERTAIN PRICE
SELECT DISTINCT p.first_name, p.last_name
FROM pharmacy.patients p
JOIN pharmacy.basket b ON p.insurance_number = b.insurance_number
JOIN pharmacy.basket_items bi ON b.basket_id = bi.basket_id
JOIN pharmacy.inventory i ON bi.medicine_name = i.medicine_name
WHERE i.price > 3000;

-- SHOW THE NUMBER OF THE UNITS OF MEDICINE SOLD WITH ITS PRICE
SELECT i.medicine_name, i.price, SUM(bi.amount) AS units_sold
FROM pharmacy.inventory i
JOIN pharmacy.basket_items bi ON i.medicine_name = bi.medicine_name
GROUP BY i.medicine_name, i.price;

-- SHOW TOTAL SPENT BY PATIENTS
SELECT p.insurance_number, p.first_name, p.last_name, SUM(m.price * bi.amount) AS total_spent
FROM pharmacy.patients p
JOIN pharmacy.basket b ON p.insurance_number = b.insurance_number
JOIN pharmacy.basket_items bi ON b.basket_id = bi.basket_id
JOIN pharmacy.medicine m ON bi.medicine_name = m.medicine_name
GROUP BY p.insurance_number, p.first_name, p.last_name;

-- SHOWS WHICH MEDICINE APPEARS MOST IN UNPURCHASED BASKETS
SELECT bi.medicine_name, COUNT(*) AS num_appearances
FROM pharmacy.basket_items bi
LEFT JOIN pharmacy.basket b ON b.basket_id = bi.basket_id
WHERE b.purchased_flag = false
GROUP BY bi.medicine_name
ORDER BY COUNT(*) DESC LIMIT 1;