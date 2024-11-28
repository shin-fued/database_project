--CREATE TYPE employee_type AS ENUM ('pharmacist', 'staff');

drop table if exists drugs_available cascade;
drop table if exists branches cascade;
drop table if exists employee cascade;
drop table if exists stock_order cascade;
drop table if exists stock cascade;
drop table if exists transactions cascade;
drop table if exists shift cascade;

create table if not exists drugs_available(
                                              id int unique,
                                              drug_name varchar(40) unique,
                                              price float(2),
                                              approval boolean default FALSE,
                                              primary key (id)
);

Create Table if not exists branches(
                                       id int not null unique,
                                       branch_name varchar(40) not null,
                                       location varchar(255) not null,
                                       primary key (id)
);

CREATE TABLE IF NOT EXISTS employee (
                                        id INT not null unique,
                                        employee_name VARCHAR(255) not null,
                                        employee_salary INT not null,
                                        type_employee employee_type not null,
                                        branch_id int,
    constraint fk_branch
        foreign key (branch_id)
            references branches(id),
                                        primary key (id)
);

CREATE TABLE IF NOT EXISTS shift(
                                            date date,
                                           employee_id INT not null,
                                           constraint fk_employee
                                               foreign key(employee_id)
                                                   references employee(id),
                                            shift_number INT,
    primary key (date, shift_number, employee_id)
);

create table if not exists stock_order(
                                          id int unique,
                                          drug_id int not null,
                                          constraint fk_drug
                                              foreign key(drug_id)
                                                  references drugs_available(id),
                                        amount int not null,
                                        time timestamp,
                                        order_placed boolean,
                                         primary key (id)
);

CREATE TABLE IF NOT EXISTS stock(
                                    branch_id INT,
                                    constraint fk_branch
                                        foreign key(branch_id)
                                            references branches(id),
                                    drug_id INT not null,
                                    constraint fk_drug
                                        foreign key(drug_id)
                                            references drugs_available(id),
                                    drug_name varchar(255) not null,
                                    amount INT not null,
                                    order_id int default null,
                                    constraint fk_order
                                        foreign key(order_id)
                                            references stock_order(id),
                                    primary key (drug_id, branch_id)
);


CREATE TABLE IF NOT EXISTS transactions(
                                            purchaser VARCHAR(255) not null,
                                            drug_name VARCHAR(255) not null,
                                            drug_id int not null,
                                            constraint fk_drug
                                                foreign key(drug_id)
                                                    references drugs_available(id),
                                            employee_id INT not null,
                                            constraint fk_employee
                                                foreign key(employee_id)
                                                    references employee(id),
                                            price numeric(2) not null,
                                            time timestamp not null,
                                            branch_id int,
                                            constraint fk_branch
                                                foreign key(branch_id)
                                                    references branches(id),
                                            primary key (purchaser, drug_id, branch_id)
);


CREATE TABLE IF NOT EXISTS drugs_available_log (
    log_id SERIAL PRIMARY KEY,
    action_type VARCHAR(10) NOT NULL, -- 'INSERT', 'UPDATE', or 'DELETE'
    log_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    id INT,
    drug_name VARCHAR(40),
    price FLOAT,
    approval BOOLEAN
);
CREATE TABLE IF NOT EXISTS branches_log (
    log_id SERIAL PRIMARY KEY,
    action_type VARCHAR(10) NOT NULL,
    log_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    id INT,
    branch_name VARCHAR(40),
    location VARCHAR(255)
);

CREATE TABLE IF NOT EXISTS employee_log (
    log_id SERIAL PRIMARY KEY,
    action_type VARCHAR(10) NOT NULL,
    log_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    id INT,
    employee_name VARCHAR(255),
    employee_salary INT,
    type_employee employee_type,
    branch_id INT
);


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
AFTER INSERT OR UPDATE OR DELETE ON drugs_available
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



insert into branches(id, branch_name, location) values (1, 'salaya', 'salaya thailand') ON CONFLICT DO NOTHING;
insert into branches(id, branch_name, location) values (2, 'bangkok', 'bangkok thailand') ON CONFLICT DO NOTHING;

insert into drugs_available(id,drug_name, price) values (1, 'paracetamol', 60.00) ON CONFLICT DO NOTHING;
insert into drugs_available(id,drug_name, approval, price) values (2, 'fentanyl', TRUE, 3000.00) ON CONFLICT DO NOTHING;
insert into drugs_available(id,drug_name, price) values (3, 'acetaminophen', 70.00) ON CONFLICT DO NOTHING;
insert into drugs_available(id,drug_name, approval, price) values (4, 'insulin', TRUE, 60.00) ON CONFLICT DO NOTHING;
insert into drugs_available(id,drug_name, price) values (5, 'adapelene', 60.00) ON CONFLICT DO NOTHING;

insert into employee(id,employee_name, employee_salary, type_employee, branch_id) values (1, 'kanat tangwongsan', 60000, 'pharmacist', 1) ON CONFLICT DO NOTHING;
insert into employee(id,employee_name, employee_salary, type_employee, branch_id) values (2, 'Boonyanit Matayomchit', 20000, 'staff', 2) ON CONFLICT DO NOTHING;
insert into employee(id,employee_name, employee_salary, type_employee, branch_id) values (3, 'piti ongmonkonkul', 40000, 'staff', 1) ON CONFLICT DO NOTHING ;

insert into employee(id,employee_name, employee_salary, type_employee, branch_id) values (4, 'Tath Kanchanarin', 50000, 'pharmacist', 1) ON CONFLICT DO NOTHING;
insert into employee(id,employee_name, employee_salary, type_employee, branch_id) values (5, 'Austin Maddison', 30000, 'staff', 2) ON CONFLICT DO NOTHING;
insert into employee(id,employee_name, employee_salary, type_employee, branch_id) values (6, 'Phavarisa Limchitti', 70000, 'pharmacist', 2) ON CONFLICT DO NOTHING ;

insert into employee(id,employee_name, employee_salary, type_employee, branch_id) values (7, 'Leibniz', 20000, 'staff', 2) ON CONFLICT DO NOTHING;
insert into employee(id,employee_name, employee_salary, type_employee, branch_id) values (8, 'Feynmann', 20000, 'staff', 2) ON CONFLICT DO NOTHING;
insert into employee(id,employee_name, employee_salary, type_employee, branch_id) values (9, 'Patrick Batemann', 15000, 'staff', 1) ON CONFLICT DO NOTHING;

insert into employee(id,employee_name, employee_salary, type_employee, branch_id) values (10, 'Luffy', 20000, 'staff', 2) ON CONFLICT DO NOTHING;
insert into employee(id,employee_name, employee_salary, type_employee, branch_id) values (11, 'Sanji', 20000, 'staff', 2) ON CONFLICT DO NOTHING;
insert into employee(id,employee_name, employee_salary, type_employee, branch_id) values (12, 'Batman', 15000, 'staff', 1) ON CONFLICT DO NOTHING;

insert into drugs_available(id,drug_name, price) values (6, 'bismuth subsalicylate', 60.00) ON CONFLICT DO NOTHING;
insert into drugs_available(id,drug_name, approval, price) values (7, 'Adderall', TRUE, 200.00) ON CONFLICT DO NOTHING;
insert into drugs_available(id,drug_name, approval, price) values (8, 'Lexapro', TRUE, 150.00) ON CONFLICT DO NOTHING;
insert into drugs_available(id,drug_name, price) values (9, 'insulin', 60.00) ON CONFLICT DO NOTHING;
insert into drugs_available(id,drug_name, price) values (10, 'adapelene', 60.00) ON CONFLICT DO NOTHING;


insert into stock(branch_id,drug_id, drug_name, amount) values (1, 1, 'paracetamol', 1000) ON CONFLICT DO NOTHING;
insert into stock(branch_id,drug_id, drug_name, amount) values (2, 1, 'paracetamol', 1000) ON CONFLICT DO NOTHING;
insert into stock(branch_id,drug_id, drug_name, amount) values (1, 7, 'Adderall', 1000) ON CONFLICT DO NOTHING;
insert into stock(branch_id,drug_id, drug_name, amount) values (2, 7, 'Adderall', 1000) ON CONFLICT DO NOTHING;
insert into stock(branch_id,drug_id, drug_name, amount) values (1, 6, 'bismuth subsalicylate', 1000) ON CONFLICT DO NOTHING;
insert into stock(branch_id,drug_id, drug_name, amount) values (2, 6, 'bismuth subsalicylate', 1000) ON CONFLICT DO NOTHING;

insert into drugs_available(id,drug_name, price) values (11, 'Lyrica', 250.00) ON CONFLICT DO NOTHING;
insert into drugs_available(id,drug_name, price) values (12, 'Melatonin', 250.00) ON CONFLICT DO NOTHING;
insert into drugs_available(id,drug_name, price) values (13, 'Meloxicam', 250.00) ON CONFLICT DO NOTHING;
insert into drugs_available(id,drug_name, price) values (14, 'Metformin', 250.00) ON CONFLICT DO NOTHING;
insert into drugs_available(id,drug_name, price) values (15, 'Methadone', 250.00) ON CONFLICT DO NOTHING;
insert into drugs_available(id,drug_name, price) values (16, 'Methotrexate', 250.00) ON CONFLICT DO NOTHING;
insert into drugs_available(id,drug_name, price) values (17, 'Metoprolol', 250.00) ON CONFLICT DO NOTHING;
insert into drugs_available(id,drug_name, price) values (18, 'Mounjaro', 250.00) ON CONFLICT DO NOTHING;
insert into drugs_available(id,drug_name, price) values (19, 'Naltrexone', 250.00) ON CONFLICT DO NOTHING;
insert into drugs_available(id,drug_name, price) values (20, 'Naproxen', 250.00) ON CONFLICT DO NOTHING;
insert into drugs_available(id,drug_name, price) values (21, 'Narcan', 250.00) ON CONFLICT DO NOTHING;
insert into drugs_available(id,drug_name, price) values (22, 'Nurtec', 250.00) ON CONFLICT DO NOTHING;
insert into drugs_available(id,drug_name, price) values (23, 'Omeprazole', 250.00) ON CONFLICT DO NOTHING;
insert into drugs_available(id,drug_name, price) values (24, 'Opdivo', 250.00) ON CONFLICT DO NOTHING;
insert into drugs_available(id,drug_name, price) values (25, 'Otezla', 250.00) ON CONFLICT DO NOTHING;
insert into drugs_available(id,drug_name, price) values (26, 'Ozempic', 250.00) ON CONFLICT DO NOTHING;
insert into drugs_available(id,drug_name, price) values (27, 'Pantoprazole', 250.00) ON CONFLICT DO NOTHING;
insert into drugs_available(id,drug_name, price) values (28, 'Plan', 250.00) ON CONFLICT DO NOTHING;
insert into drugs_available(id,drug_name, price) values (29, 'B', 250.00) ON CONFLICT DO NOTHING;
insert into drugs_available(id,drug_name, price) values (30, 'Prednisone', 250.00) ON CONFLICT DO NOTHING;

insert into stock(branch_id,drug_id, drug_name, amount) values (1, 11, 'Lyrica', 1000) ON CONFLICT DO NOTHING;
insert into stock(branch_id,drug_id, drug_name, amount) values (2, 11, 'Lyrica', 1000) ON CONFLICT DO NOTHING;
insert into stock(branch_id,drug_id, drug_name, amount) values (1, 12, 'Melatonin', 1000) ON CONFLICT DO NOTHING;
insert into stock(branch_id,drug_id, drug_name, amount) values (2, 12, 'Melatonin', 1000) ON CONFLICT DO NOTHING;
insert into stock(branch_id,drug_id, drug_name, amount) values (1, 13, 'Meloxicam', 1000) ON CONFLICT DO NOTHING;
insert into stock(branch_id,drug_id, drug_name, amount) values (2, 13, 'Meloxicam', 1000) ON CONFLICT DO NOTHING;
insert into stock(branch_id,drug_id, drug_name, amount) values (1, 14, 'Metformin', 1000) ON CONFLICT DO NOTHING;
insert into stock(branch_id,drug_id, drug_name, amount) values (2, 14, 'Metformin', 1000) ON CONFLICT DO NOTHING;
insert into stock(branch_id,drug_id, drug_name, amount) values (1, 15, 'Methadone', 1000) ON CONFLICT DO NOTHING;
insert into stock(branch_id,drug_id, drug_name, amount) values (2, 15, 'Methadone', 1000) ON CONFLICT DO NOTHING;
insert into stock(branch_id,drug_id, drug_name, amount) values (1, 16, 'Methotrexate', 1000) ON CONFLICT DO NOTHING;
insert into stock(branch_id,drug_id, drug_name, amount) values (2, 16, 'Methotrexate', 1000) ON CONFLICT DO NOTHING;
insert into stock(branch_id,drug_id, drug_name, amount) values (1, 17, 'Metoprolol', 1000) ON CONFLICT DO NOTHING;
insert into stock(branch_id,drug_id, drug_name, amount) values (2, 17, 'Metoprolol', 1000) ON CONFLICT DO NOTHING;
insert into stock(branch_id,drug_id, drug_name, amount) values (1, 18, 'Mounjaro', 1000) ON CONFLICT DO NOTHING;
insert into stock(branch_id,drug_id, drug_name, amount) values (2, 18, 'Mounjaro', 1000) ON CONFLICT DO NOTHING;
insert into stock(branch_id,drug_id, drug_name, amount) values (1, 19, 'Naltrexone', 1000) ON CONFLICT DO NOTHING;
insert into stock(branch_id,drug_id, drug_name, amount) values (2, 19, 'Naltrexone', 1000) ON CONFLICT DO NOTHING;
insert into stock(branch_id,drug_id, drug_name, amount) values (1, 20, 'Naproxen', 1000) ON CONFLICT DO NOTHING;
insert into stock(branch_id,drug_id, drug_name, amount) values (2, 20, 'Naproxen', 1000) ON CONFLICT DO NOTHING;
insert into stock(branch_id,drug_id, drug_name, amount) values (1, 21, 'Narcan', 1000) ON CONFLICT DO NOTHING;
insert into stock(branch_id,drug_id, drug_name, amount) values (2, 21, 'Narcan', 1000) ON CONFLICT DO NOTHING;
insert into stock(branch_id,drug_id, drug_name, amount) values (1, 22, 'Nurtec', 1000) ON CONFLICT DO NOTHING;
insert into stock(branch_id,drug_id, drug_name, amount) values (2, 22, 'Nurtec', 1000) ON CONFLICT DO NOTHING;
insert into stock(branch_id,drug_id, drug_name, amount) values (1, 23, 'Omeprazole', 1000) ON CONFLICT DO NOTHING;
insert into stock(branch_id,drug_id, drug_name, amount) values (2, 23, 'Omeprazole', 1000) ON CONFLICT DO NOTHING;
insert into stock(branch_id,drug_id, drug_name, amount) values (1, 24, 'Opdivo', 1000) ON CONFLICT DO NOTHING;
insert into stock(branch_id,drug_id, drug_name, amount) values (2, 24, 'Opdivo', 1000) ON CONFLICT DO NOTHING;
insert into stock(branch_id,drug_id, drug_name, amount) values (1, 25, 'Otezla', 1000) ON CONFLICT DO NOTHING;
insert into stock(branch_id,drug_id, drug_name, amount) values (2, 25, 'Otezla', 1000) ON CONFLICT DO NOTHING;
insert into stock(branch_id,drug_id, drug_name, amount) values (1, 26, 'Ozempic', 1000) ON CONFLICT DO NOTHING;
insert into stock(branch_id,drug_id, drug_name, amount) values (2, 26, 'Ozempic', 1000) ON CONFLICT DO NOTHING;
insert into stock(branch_id,drug_id, drug_name, amount) values (1, 27, 'Pantoprazole', 1000) ON CONFLICT DO NOTHING;
insert into stock(branch_id,drug_id, drug_name, amount) values (2, 27, 'Pantoprazole', 1000) ON CONFLICT DO NOTHING;
insert into stock(branch_id,drug_id, drug_name, amount) values (1, 28, 'Plan', 1000) ON CONFLICT DO NOTHING;
insert into stock(branch_id,drug_id, drug_name, amount) values (2, 28, 'Plan', 1000) ON CONFLICT DO NOTHING;
insert into stock(branch_id,drug_id, drug_name, amount) values (1, 29, 'B', 1000) ON CONFLICT DO NOTHING;
insert into stock(branch_id,drug_id, drug_name, amount) values (2, 29, 'B', 1000) ON CONFLICT DO NOTHING;
insert into stock(branch_id,drug_id, drug_name, amount) values (1, 30, 'Prednisone', 1000) ON CONFLICT DO NOTHING;
insert into stock(branch_id,drug_id, drug_name, amount) values (2, 30, 'Prednisone', 1000) ON CONFLICT DO NOTHING;
