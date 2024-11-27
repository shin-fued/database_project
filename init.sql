create table if not exists drugs_available(
    id int unique,
    drug_name varchar(40),
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
                                        primary key (id)
);

create table if not exists stock_order(
    id int unique,
    drug_id int not null,
    constraint fk_drug
        foreign key(drug_id)
            references drugs_available(id),
    amount int not null,
    time timestamp,
    primary key (id)
);

CREATE TABLE IF NOT EXISTS stock(
    branch_id INT,
    constraint fk_branch
        foreign key(branch_id)
            references branches(id),
    drug_id INT not null unique,
    drug_name varchar(255) not null,
    amount INT,
    batch_id int,
    constraint fk_batch
        foreign key(batch_id)
            references batches(id),
    primary key (drug_id, branch_id)
);

CREATE TABLE IF NOT EXISTS transactions (
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
    branch_id int unique,
    constraint fk_branch
        foreign key(branch_id)
            references branches(id),
    primary key (purchaser, time, branch_id)
);

--CREATE TYPE employee_type AS ENUM ('pharmacist', 'staff');

--insert into branches(id, branch_name, location) values (1, 'salaya', 'salaya thailand');
--insert into branches(id, branch_name, location) values (2, 'bangkok', 'bangkok thailand');

insert into drugs_available(id,drug_name, price) values (1, 'paracetamol', 60.00);
insert into drugs_available(id,drug_name, approval, price) values (2, 'fentanyl', TRUE, 3000.00);
insert into drugs_available(id,drug_name, price) values (3, 'acetaminophen', 70.00);
insert into drugs_available(id,drug_name, approval, price) values (4, 'insulin', TRUE, 60.00);
insert into drugs_available(id,drug_name, price) values (5, 'adapelene', 60.00);
