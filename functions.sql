CREATE OR REPLACE FUNCTION log_drugs_available_changes()
    RETURNS TRIGGER AS $$
BEGIN
    IF (TG_OP = 'INSERT') THEN
        INSERT INTO drugs_available_log(action_type, id, drug_name, price, approval)
        VALUES ('INSERT', NEW.id, NEW.drug_name, NEW.price, NEW.approval);
    ELSIF (TG_OP = 'UPDATE') THEN
        INSERT INTO drugs_available_log(action_type, id, drug_name, price, approval)
        VALUES ('UPDATE', OLD.id, OLD.drug_name, OLD.price, OLD.approval);
    ELSIF (TG_OP = 'DELETE') THEN
        INSERT INTO drugs_available_log(action_type, id, drug_name, price, approval)
        VALUES ('DELETE', OLD.id, OLD.drug_name, OLD.price, OLD.approval);
    END IF;
    RETURN NULL;
END;
$$ LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION log_branches_changes()
    RETURNS TRIGGER AS $$
BEGIN
    IF (TG_OP = 'INSERT') THEN
        INSERT INTO branches_log(action_type, id, branch_name, location)
        VALUES ('INSERT', NEW.id, NEW.branch_name, NEW.location);
    ELSIF (TG_OP = 'UPDATE') THEN
        INSERT INTO branches_log(action_type, id, branch_name, location)
        VALUES ('UPDATE', OLD.id, OLD.branch_name, OLD.location);
    ELSIF (TG_OP = 'DELETE') THEN
        INSERT INTO branches_log(action_type, id, branch_name, location)
        VALUES ('DELETE', OLD.id, OLD.branch_name, OLD.location);
    END IF;
    RETURN NULL;
END;
$$ LANGUAGE plpgsql;
CREATE OR REPLACE FUNCTION log_employee_changes()
    RETURNS TRIGGER AS $$
BEGIN
    IF TG_OP = 'INSERT' THEN
        INSERT INTO employee_log (
            action_type, id, employee_name, employee_salary, type_employee, branch_id
        )
        VALUES (
                   'INSERT', NEW.id, NEW.employee_name, NEW.employee_salary, NEW.type_employee, NEW.branch_id
               );

    ELSIF TG_OP = 'UPDATE' THEN
        INSERT INTO employee_log (
            action_type, id, employee_name, employee_salary, type_employee, branch_id
        )
        VALUES (
                   'UPDATE', NEW.id, NEW.employee_name, NEW.employee_salary, NEW.type_employee, NEW.branch_id
               );

    ELSIF TG_OP = 'DELETE' THEN
        INSERT INTO employee_log (
            action_type, id, employee_name, employee_salary, type_employee, branch_id
        )
        VALUES (
                   'DELETE', OLD.id, OLD.employee_name, OLD.employee_salary, OLD.type_employee, OLD.branch_id
               );
    END IF;

    RETURN NULL; -- Ensures the original operation is unaffected
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION log_stock_changes()
RETURNS TRIGGER AS $$
BEGIN
    IF (TG_OP = 'INSERT') THEN
        INSERT INTO stock_log(stock_id, branch_id, drug_id, brand_name, amount, expiration_date, order_id, operation_type)
        VALUES (NEW.id, NEW.branch_id, NEW.drug_id, NEW.brand_name, NEW.amount, NEW.expiration_date, NEW.order_id, 'INSERT');
        RETURN NEW;
    ELSIF (TG_OP = 'UPDATE') THEN
        INSERT INTO stock_log (stock_id, branch_id, drug_id, brand_name, amount, expiration_date, order_id, operation_type)
        VALUES (OLD.id, OLD.branch_id, OLD.drug_id, OLD.brand_name, OLD.amount, OLD.expiration_date, OLD.order_id, 'UPDATE');
        RETURN NEW;
    ELSIF (TG_OP = 'DELETE') THEN
        INSERT INTO stock_log (stock_id, branch_id, drug_id, brand_name, amount, expiration_date, order_id, operation_type)
        VALUES (OLD.id, OLD.branch_id, OLD.drug_id, OLD.brand_name, OLD.amount, OLD.expiration_date, OLD.order_id, 'DELETE');
        RETURN OLD;
    END IF;
END;
$$ LANGUAGE plpgsql;


CREATE OR REPLACE TRIGGER trg_drugs_available_changes
    AFTER INSERT OR UPDATE OR DELETE ON drugs
    FOR EACH ROW
EXECUTE FUNCTION log_drugs_available_changes();

CREATE or replace TRIGGER trg_branches_changes
    AFTER INSERT OR UPDATE OR DELETE ON branches
    FOR EACH ROW
EXECUTE FUNCTION log_branches_changes();
CREATE or replace TRIGGER employee_log_trigger
    AFTER INSERT OR UPDATE OR DELETE ON employee
    FOR EACH ROW
EXECUTE FUNCTION log_employee_changes();
CREATE or replace TRIGGER stock_changes_trigger
    AFTER INSERT OR UPDATE OR DELETE ON stock
    FOR EACH ROW
EXECUTE FUNCTION log_stock_changes();
-- end of log table features


-- make order
CREATE OR REPLACE FUNCTION make_order(
    drug INT,
    amount_d INT,
    branch INT
) RETURNS TEXT AS $$
    DECLARE
BEGIN
    INSERT INTO stock_order(drug_id, amount, order_placed, expiration_date, time, branch_id) values($1, $2, TRUE, ((timestamp '2024-01-01' +
                                                                                             random() * (timestamp '2040-12-31' -
                                                                                                                timestamp '2024-01-01'))), (select NOW() + (random() * (NOW()+'10 days' - NOW())) + '3 days'), $3);
    RETURN 'order placed';
END;
$$ LANGUAGE plpgsql;


--return all expired drugs
DROP FUNCTION expired(integer);
CREATE OR REPLACE FUNCTION expired(b int) returns table(d_id INT, d_drug varchar(40),d_brand varchar(40), am INT, exp date) as $$
BEGIN
return query SELECT s.drug_id, d.drug_name, d.brand_name, s.amount, s.expiration_date FROM stock as s right JOIN drugs as d ON s.drug_id = d.id where s.expiration_date <= current_date and s.branch_id=$1;
END;
    $$ LANGUAGE plpgsql;

--remove expired drugs
CREATE OR REPLACE FUNCTION remove_expired(b int, s int) returns TEXT as $$
    DECLARE
        p_drug_id INT;
BEGIN
SELECT drug_id into p_drug_id from stock where id=s;
DELETE FROM stock where drug_id=b and id=s;
RETURN format('removed drug %d from branch %d', p_drug_id, b);
END;
    $$ LANGUAGE plpgsql;


--drop function make_purchase(customer_name VARCHAR(255), p_drug_id INT, p_employee_id INT, p_branch_id INT, p_quantity INT);

CREATE OR REPLACE FUNCTION make_purchase(
    customer_name VARCHAR(255),
    p_drug_id INT,
    p_employee_id INT, -- Keep the original parameter name
    p_branch_id INT,
    p_quantity INT
)
    RETURNS TEXT AS $$
DECLARE
    drug_price drugs.price%TYPE;
    brand drugs.brand_name%TYPE;
    f_stock stock.id%TYPE;
    current_stock stock.amount%TYPE;
BEGIN
    -- Check if the drug stock exists for the given branch and fetch the nearest expiration stock
    BEGIN
        SELECT id, amount
        INTO f_stock, current_stock
        FROM stock
        WHERE drug_id = p_drug_id
          AND branch_id = p_branch_id
          AND expiration_date > CURRENT_DATE
        ORDER BY expiration_date ASC
        LIMIT 1;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            RETURN 'Error: Drug not found or expired in this branch.';
    END;

    -- Check if sufficient stock is available
    IF current_stock < p_quantity THEN
        RETURN 'Error: Insufficient stock available.';
    END IF;
    IF (select approval from drugs where id=p_drug_id) and (SELECT type_employee from employee where id=p_employee_id) != 'pharmacist' THEN
        INSERT INTO transactions (
        purchaser, brand_name, drug_id, employee_id, quantity, price, time, branch_id, approved
    )
    VALUES (
        customer_name, brand, p_drug_id, p_employee_id , p_quantity, drug_price * p_quantity , CURRENT_TIMESTAMP, p_branch_id, FALSE
    );
        RETURN 'Employee not qualified';
    END IF;

    -- Deduct the quantity from stock
    UPDATE stock
    SET amount = amount - p_quantity
    WHERE id = f_stock;

    -- Fetch drug details
    SELECT price, brand_name
    INTO drug_price, brand
    FROM drugs
    WHERE id = p_drug_id;

    -- Insert the transaction record
    INSERT INTO transactions (
        purchaser, brand_name, drug_id, employee_id, quantity, price, time, branch_id, approved
    )
    VALUES (
        customer_name, brand, p_drug_id, p_employee_id , p_quantity, drug_price * p_quantity , CURRENT_TIMESTAMP, p_branch_id, TRUE
    );

    -- Return success message
    RETURN FORMAT('Purchase successful! %s x%s bought for $%s', brand, p_quantity, drug_price * p_quantity);
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION add_stock_from_order(
) RETURNS TRIGGER AS $$
    DECLARE
        brand stock.brand_name%type;
BEGIN
        select brand_name into brand from drugs where id=new.drug_id;
    insert into stock(branch_id, drug_id, brand_name, amount, expiration_date, order_id) values(NEW.branch_id, new.drug_id, brand, new.amount, new.expiration_date, new.order_id);
        RETURN NULL;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE TRIGGER trg_add_stock_from_order
    AFTER INSERT ON stock_order
    FOR EACH ROW
EXECUTE FUNCTION add_stock_from_order();

-- the function for testing //
CREATE OR REPLACE FUNCTION add_stock(
    p_drug_id INT,
    brand VARCHAR(255),
    p_branch_id INT,
    p_amount INT,
    p_expiration_date DATE
) RETURNS TEXT AS $$
DECLARE
    check_id INT;
    new_order_id INT;
BEGIN
    -- Validate the drug ID and brand
    SELECT id INTO check_id
    FROM drugs
    WHERE id = p_drug_id AND brand_name = brand;

    IF NOT FOUND THEN
        RAISE EXCEPTION 'Invalid drug ID or brand name: % and %', p_drug_id, brand;
    END IF;

--     SELECT id INTO check_id
--     FROM stock
--     WHERE id = p_drug_id AND brand_name = brand and p_expiration_date = expiration_date and branch_id = p_branch_id;
--     IF FOUND THEN
--         UPDATE stock
--         SET amount = 0
--         WHERE id = p_drug_id AND brand_name = brand and p_expiration_date = expiration_date and branch_id = p_branch_id;
--         RETURN FORMAT('Stock added successfully for Drug ID: %s, Branch ID: %s, Amount: %s.', p_drug_id, p_branch_id, p_amount);
--     end if;

    -- Insert into stock_order
    INSERT INTO stock_order (drug_id, amount, time, order_placed, expiration_date, branch_id)
    VALUES (p_drug_id, p_amount, NOW(), TRUE, p_expiration_date, p_branch_id)
    RETURNING order_id INTO new_order_id;

    -- Return success message
    RETURN FORMAT('Stock added successfully for Drug ID: %s, Branch ID: %s, Amount: %s.', p_drug_id, p_branch_id, p_amount);
END;
$$ LANGUAGE plpgsql;


-- DO $$
-- BEGIN
--     PERFORM add_stock(2, 'Brufen', 2,1000, '2038-11-12');
-- END;
-- $$;
--
-- SELECT * from stock_log;


UPDATE stock
SET amount = 0
WHERE drug_id = 2 AND brand_name = 'Brufen' and expiration_date = '2038-11-12' and branch_id = 2;

Select * from stock where brand_name = 'Brufen';