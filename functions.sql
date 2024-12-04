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

CREATE TRIGGER trg_drugs_available_changes
    AFTER INSERT OR UPDATE OR DELETE ON drugs
    FOR EACH ROW
EXECUTE FUNCTION log_drugs_available_changes();

CREATE TRIGGER trg_branches_changes
    AFTER INSERT OR UPDATE OR DELETE ON branches
    FOR EACH ROW
EXECUTE FUNCTION log_branches_changes();
CREATE TRIGGER employee_log_trigger
    AFTER INSERT OR UPDATE OR DELETE ON employee
    FOR EACH ROW
EXECUTE FUNCTION log_employee_changes();
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
CREATE OR REPLACE FUNCTION expired(b int) returns table(d_id INT, d_name varchar(40), am INT) as $$
BEGIN
return query SELECT drug_id, brand_name, amount FROM stock where expiration_date <= current_date and branch_id=$1;
END;
    $$ LANGUAGE plpgsql;

--remove expired drugs
CREATE OR REPLACE FUNCTION remove_expired(d int, b int) returns TEXT as $$
BEGIN
DELETE FROM stock where drug_id=$1 and branch_id=$2;
RETURN format('removed drug %d from branch %d', $1, $2);
END;
    $$ LANGUAGE plpgsql;

-- purchase function
CREATE OR REPLACE FUNCTION make_purchase(
    customer_name VARCHAR(255),
    p_drug_id INT,
    p_employee_id INT,
    p_branch_id INT,
    p_quantity INT
)
    RETURNS TEXT AS $$
DECLARE
    drug_price drugs.price%TYPE;
    brand drugs.brand_name%TYPE;

    f_stock stock.stock_id%TYPE;
        current_stock stock.amount%TYPE;
BEGIN
    -- Check if the drug exists and fetch its details
    /*SELECT amount, price, drugs.drug_name
    INTO current_stock, drug_price, drug_name
    FROM stock
             JOIN drugs ON stock.drug_id = drugs.id
    WHERE stock.drug_id = p_drug_id AND stock.branch_id = p_drug_id;*/

    SELECT stock_id INTO f_stock from stock where drug_id=p_drug_id and branch_id=p_branch_id and expiration_date>CURRENT_DATE ORDER BY expiration_date desc
 fetch first 1 rows only;
SELECT amount into current_stock from stock where stock_id=f_stock;

    IF NOT FOUND THEN
        RETURN 'Error: Drug not found in this branch.';
    END IF;

    -- Check if sufficient stock is available
    IF current_stock < p_quantity THEN
        RETURN 'Error: Insufficient stock available.';
    END IF;

    -- Deduct the quantity from the stock
    /*UPDATE stock
    --SET amount = amount - quantity
    --WHERE drug_id = $2 AND branch_id = $4;*/
SELECT amount into current_stock from stock where stock_id=f_stock;
Update stock set amount=current_stock-$2 where stock_id=f_stock;
    select price, brand_name into drug_price, brand from drugs where id=p_drug_id;

    -- Insert the transaction record
    INSERT INTO transactions (
        purchaser, brand_name, drug_id, employee_id, quantity,price, time, branch_id
    )
    VALUES (
               customer_name, brand, p_drug_id, p_employee_id, p_quantity,drug_price * p_quantity, CURRENT_TIMESTAMP, p_branch_id
           );

    -- Return a success message
    RETURN FORMAT('Purchase successful! %s x%d bought for $%.2f', brand, p_quantity, drug_price * p_quantity);
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION add_stock(
    p_drug_id INT,
    p_branch_id INT,
    p_amount INT,
    p_expiration_date DATE
) RETURNS TEXT AS $$
DECLARE
    current_amount INT;
BEGIN
    -- Check if the stock entry already exists for the drug and branch
    SELECT amount INTO current_amount
    FROM stock
    WHERE drug_id = p_drug_id AND branch_id = p_branch_id;

    IF FOUND THEN
        -- If the stock already exists, update the amount
        UPDATE stock
        SET amount = amount + p_amount, expiration_date = p_expiration_date
        WHERE drug_id = p_drug_id AND branch_id = p_branch_id;
        RETURN format('Stock updated: Added %d units to existing stock of Drug ID %d at Branch %d.', p_amount, p_drug_id, p_branch_id);
    ELSE
        -- Otherwise, insert a new stock entry
        INSERT INTO stock (branch_id, drug_id, brand_name, amount, expiration_date)
        SELECT p_branch_id, p_drug_id, brand_name, p_amount, p_expiration_date
        FROM drugs
        WHERE id = p_drug_id;
        RETURN format('New stock added: %d units of Drug ID %d at Branch %d.', p_amount, p_drug_id, p_branch_id);
    END IF;
END;
$$ LANGUAGE plpgsql;
