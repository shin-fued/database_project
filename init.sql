Create Table if not exists branches(
    id int not null,
    branch_name varchar(40) not null,
    location varchar(255) not null,
    primary key (id)
);

CREATE TABLE IF NOT EXISTS stock(
    branch_id INT,
    constraint fk_branch
        foreign key(branch_id)
            references branches(id),
    drug_id INT not null Unique,
    drug_name varchar(255) not null,
    amount INT,
    primary key (drug_id)
);

CREATE TABLE IF NOT EXISTS transactions (
                              purchaser VARCHAR(255) not null,
                              drug_name VARCHAR(255) not null,
                              drug_id int not null,
                              employee_id INT not null,
                              price numeric(2) not null,
                              time timestamp not null,
    primary key (purchaser, time)
);

CREATE TYPE employee_type AS ENUM ('pharmacist', 'staff');

CREATE TABLE IF NOT EXISTS employee (
                                        employee_id INT not null unique,
                                        employee_name VARCHAR(255) not null,
                                        employee_salary INT not null,
                                        type_employee employee_type not null,
    primary key (employee_id)
);

insert into branches(id, branch_name, location) values (1, 'salaya', 'salaya thailand');
insert into branches(id, branch_name, location) values (2, 'bangkok', 'bangkok thailand');
