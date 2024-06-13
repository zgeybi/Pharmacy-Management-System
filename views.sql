-- VIEW FOR EXPIRED MEDICATION
CREATE VIEW pharmacy.expired_medication AS
SELECT *
FROM pharmacy.inventory
WHERE expiry_date < CURRENT_DATE;

-- VIEW TO SHOW MEDICATION THAT IS LOW IN AMOUNT, USEFUL TO QUICKLY DECIDE WHAT PHARMACY NEEDS
CREATE VIEW pharmacy.low_inventory AS
SELECT *
FROM pharmacy.inventory
WHERE amount < 10;

-- VIEW TO SHOW ACTIVE EMPLOYEES
CREATE VIEW pharmacy.active_employees AS
SELECT e.first_name, e.last_name, j.contract_end
FROM pharmacy.employees e
JOIN pharmacy.jobs j ON e.employee_number = j.employee_number
WHERE CURRENT_DATE < j.contract_end;
