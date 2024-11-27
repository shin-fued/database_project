--CREATE TYPE employee_type AS ENUM ('pharmacist', 'staff');

drop table if exists drugs_available cascade;
drop table if exists branches cascade;
drop table if exists employee cascade;
drop table if exists stock_order cascade;
drop table if exists stock cascade;
drop table if exists transactions cascade;

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
