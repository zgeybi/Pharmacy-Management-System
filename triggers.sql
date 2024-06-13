-- AUTOMATICALLY ADD ROW TO ORDERS TABLE AFTER BASKET IS MARKED PURCHASED
CREATE OR REPLACE FUNCTION pharmacy.fill_orders_on_purchase()
RETURNS TRIGGER AS $$
BEGIN
    IF NEW.purchased_flag = true THEN
        INSERT INTO pharmacy.orders (basket_id, loyalty_card, insurance_number, payment_type, date, total_price)
        SELECT NEW.basket_id, p.loyalty_card, p.insurance_number, 'Credit Card', CURRENT_DATE,
               SUM(m.price * bi.amount)
        FROM pharmacy.basket_items bi
        JOIN pharmacy.medicine m ON bi.medicine_name = m.medicine_name
        JOIN pharmacy.patients p ON p.insurance_number = NEW.insurance_number
        WHERE bi.basket_id = NEW.basket_id
        GROUP BY NEW.basket_id, p.loyalty_card, p.insurance_number;
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER fill_orders_trigger
AFTER UPDATE ON pharmacy.basket
FOR EACH ROW
EXECUTE FUNCTION pharmacy.fill_orders_on_purchase();


CREATE OR REPLACE FUNCTION pharmacy.decrease_inventory_on_purchase()
RETURNS TRIGGER AS $$
DECLARE
    v_medication RECORD;
    newamount INT;
BEGIN
    IF NEW.purchased_flag = TRUE THEN
        FOR v_medication IN
            SELECT bi.medicine_name, bi.amount
            FROM pharmacy.basket_items bi
            WHERE bi.basket_id = NEW.basket_id
        LOOP
            newamount = ( SELECT amount FROM pharmacy.inventory WHERE medicine_name = v_medication.medicine_name) - v_medication.amount;
            IF newamount < 0 THEN
                UPDATE pharmacy.basket SET purchased_flag = false WHERE basket_id = NEW.basket_id;
                RAISE NOTICE 'inventory amount isnt enough, purchase of basket with id % is cancelled.', NEW.basket_id;
                EXIT;
            end if;
            UPDATE pharmacy.inventory
            SET amount = amount - v_medication.amount
            WHERE medicine_name = v_medication.medicine_name;
        END LOOP;
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE TRIGGER trigger_decrease_inventory_on_purchase
AFTER UPDATE ON pharmacy.basket
FOR EACH ROW
EXECUTE FUNCTION pharmacy.decrease_inventory_on_purchase();


-- TRIGGER THAT FIRES ON LOW AMOUNT OF MEDICATION IN INVENTORY
CREATE OR REPLACE FUNCTION notify_low_inventory()
RETURNS TRIGGER AS $$
DECLARE
    v_inventory_count INT;
    v_threshold INT := 10;
BEGIN
    SELECT amount INTO v_inventory_count
    FROM pharmacy.inventory
    WHERE barcode = NEW.barcode;

    IF v_inventory_count < v_threshold THEN
        RAISE NOTICE 'Low inventory for medicine: %', NEW.medicine_name;
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE TRIGGER trigger_notify_low_inventory
AFTER UPDATE ON pharmacy.inventory
FOR EACH ROW
EXECUTE FUNCTION notify_low_inventory();


