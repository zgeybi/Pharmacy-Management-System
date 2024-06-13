-- FUNCTION TO ADD A NEW PATIENT
CREATE OR REPLACE FUNCTION pharmacy.add_patient(
    p_insurance_number BIGINT,
    p_first_name TEXT,
    p_last_name TEXT,
    p_age INT,
    p_active BOOL,
    p_loyalty_card BIGINT
)
RETURNS VOID
AS $$
BEGIN
    INSERT INTO pharmacy.patients(insurance_number, first_name, last_name, age, active, loyalty_card)
    VALUES (p_insurance_number, p_first_name, p_last_name, p_age, p_active, p_loyalty_card);
END;
$$ LANGUAGE plpgsql;


-- FUNCTION TO GET MEDICINE INFO BASED ON BARCODE
CREATE OR REPLACE FUNCTION pharmacy.get_medicine_info(
    p_barcode BIGINT
)
RETURNS TABLE (
    barcode BIGINT,
    medicine_name TEXT,
    price INT,
    supplier_name TEXT,
    amount INT,
    expiry_date DATE
)
AS $$
BEGIN
    RETURN QUERY
    SELECT m.barcode, m.medicine_name, m.price, i.supplier_name, i.amount, i.expiry_date
    FROM pharmacy.medicine m
    JOIN pharmacy.inventory i ON m.barcode = i.barcode
    WHERE m.barcode = p_barcode;
END;
$$ LANGUAGE plpgsql;

-- FUNCTION TO CALCULATE TOTAL PRICE OF A BASKET BASED ON ID
CREATE OR REPLACE FUNCTION basket_total_price(
    p_basket_id INT
)
RETURNS INT
AS $$
DECLARE
    total_price INT;
BEGIN
    SELECT SUM(m.price * bi.amount) INTO total_price
    FROM pharmacy.basket_items bi
    JOIN pharmacy.medicine m ON bi.medicine_name = m.medicine_name
    WHERE bi.basket_id = p_basket_id;

    RETURN total_price;
END;
$$ LANGUAGE plpgsql;
