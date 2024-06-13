CREATE SCHEMA IF NOT EXISTS pharmacy;

CREATE TABLE IF NOT EXISTS pharmacy.suppliers (
    supplier_name TEXT PRIMARY KEY,
    address TEXT,
    phone_number TEXT NOT NULL UNIQUE,
    website TEXT,
    email TEXT UNIQUE
);

CREATE TABLE IF NOT EXISTS pharmacy.inventory(
    barcode INT PRIMARY KEY,
    supplier_name TEXT REFERENCES pharmacy.suppliers(supplier_name) ON UPDATE CASCADE,
    amount INT,
    medicine_name TEXT NOT NULL,
    price INT,
    expiry_date DATE
);

CREATE TABLE IF NOT EXISTS pharmacy.medicine(
    barcode INT PRIMARY KEY REFERENCES pharmacy.inventory(barcode) ON UPDATE CASCADE,
    medicine_name TEXT NOT NULL,
    price INT NOT NULL
);


CREATE TABLE IF NOT EXISTS pharmacy.patients(
    insurance_number INT PRIMARY KEY,
    first_name TEXT NOT NULL,
    last_name TEXT NOT NULL,
    age INT,
    active bool NOT NULL,
    loyalty_card INT UNIQUE
);

CREATE TABLE IF NOT EXISTS pharmacy.basket(
    basket_id SERIAL PRIMARY KEY,
    insurance_number INT REFERENCES pharmacy.patients(insurance_number) ON UPDATE CASCADE,
    purchased_flag bool DEFAULT false

    -- DELETED MEDICINE NAME AND AMOUNT
);

CREATE TABLE IF NOT EXISTS pharmacy.basket_items (
    item_id SERIAL PRIMARY KEY,
    basket_id INT,
    FOREIGN KEY(basket_id) REFERENCES pharmacy.basket(basket_id),
    medicine_name TEXT NOT NULL,
    amount INT NOT NULL
);

CREATE TABLE IF NOT EXISTS pharmacy.orders(
    -- order_number SERIAL PRIMARY KEY,
    basket_id INT PRIMARY KEY REFERENCES pharmacy.basket(basket_id),
    loyalty_card INT REFERENCES pharmacy.patients(loyalty_card),
    insurance_number INT REFERENCES pharmacy.patients(insurance_number),
    payment_type TEXT NOT NULL,
    date DATE NOT NULL DEFAULT CURRENT_DATE,
    total_price INT NOT NULL
);

CREATE TABLE IF NOT EXISTS pharmacy.employees(
    employee_number SERIAL PRIMARY KEY,
    name TEXT NOT NULL,
    passport_number INT NOT NULL,
    age INT
);

CREATE TABLE IF NOT EXISTS pharmacy.jobs(
    employee_number INT REFERENCES pharmacy.employees(employee_number),
    contract_term DATE NOT NULL,
    position TEXT,
    salary INT
);


