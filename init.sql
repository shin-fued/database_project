--CREATE TYPE employee_type AS ENUM ('pharmacist', 'staff');
--CREATE TYPE drug_type AS ENUM ('cough', 'allergy', 'first aid', 'pain relief');

drop table if exists drugs cascade;
drop table if exists branches cascade;
drop table if exists employee cascade;
drop table if exists stock_order cascade;
drop table if exists stock cascade;
drop table if exists transactions cascade;
drop table if exists shift cascade;

create table if not exists drugs(
                                              id int unique not null generated always as identity,
                                              drug_name varchar(40),
    brand_name varchar(40),
                                              price float(2),
                                              approval boolean default FALSE,
                                              primary key (id),
    tag drug_type
);

Create Table if not exists branches(
                                       id int not null unique generated always as identity,
                                       branch_name varchar(40) not null,
                                       location varchar(255) not null,
                                       primary key (id)
);

CREATE TABLE IF NOT EXISTS employee (
                                        id INT not null unique generated always as identity,
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
                                          order_id int unique generated always as identity,
                                          drug_id int not null,
                                          constraint fk_drug
                                              foreign key(drug_id)
                                                  references drugs(id),
                                          amount int not null,
                                          time timestamp,
                                          order_placed boolean,
                                            expiration_date date,
                                          primary key (order_id)
);

CREATE TABLE IF NOT EXISTS stock(
                                    branch_id INT,
                                    constraint fk_branch
                                        foreign key(branch_id)
                                            references branches(id),
                                    drug_id INT not null,
                                    constraint fk_drug
                                        foreign key(drug_id)
                                            references drugs(id),
                                    drug_name varchar(255) not null,
                                    amount INT not null,
    expiration_date date,
                                    stock_id int default null,
                                    constraint fk_order
                                        foreign key(stock_id)
                                            references stock_order(order_id),
            primary key (stock_id)
);


CREATE TABLE IF NOT EXISTS transactions(
    id int unique not null generated always as identity,
                                           purchaser VARCHAR(255) not null,
                                           drug_name VARCHAR(255) not null,
                                           drug_id int not null,
                                           constraint fk_drug
                                               foreign key(drug_id)
                                                   references drugs(id),
                                           employee_id INT not null,
                                           constraint fk_employee
                                               foreign key(employee_id)
                                                   references employee(id),
                                           quantity INT not null,
                                           price numeric(2) not null,
                                           time timestamp not null,
                                           branch_id int,
                                           constraint fk_branch
                                               foreign key(branch_id)
                                                   references branches(id),
    approved boolean,
                                           primary key (id)
);



-- make log table
CREATE TABLE IF NOT EXISTS drugs_log (
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