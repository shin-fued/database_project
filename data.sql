insert into branches( branch_name, location) values ('salaya', 'salaya thailand') ON CONFLICT DO NOTHING;
insert into branches( branch_name, location) values ( 'bangkok', 'bangkok thailand') ON CONFLICT DO NOTHING;

insert into drugs(drug_name, price) values ( 'paracetamol', 60.00) ON CONFLICT DO NOTHING;
insert into drugs(drug_name, approval, price) values ('fentanyl', TRUE, 3000.00) ON CONFLICT DO NOTHING;
insert into drugs(drug_name, price) values ('acetaminophen', 70.00) ON CONFLICT DO NOTHING;
insert into drugs(drug_name, approval, price) values ( 'insulin', TRUE, 60.00) ON CONFLICT DO NOTHING;
insert into drugs(drug_name, price) values ('adapelene', 60.00) ON CONFLICT DO NOTHING;

insert into employee(employee_name, employee_salary, type_employee, branch_id) values ('kanat tangwongsan', 60000, 'pharmacist', 1) ON CONFLICT DO NOTHING;
insert into employee(employee_name, employee_salary, type_employee, branch_id) values ('Boonyanit Matayomchit', 20000, 'staff', 2) ON CONFLICT DO NOTHING;
insert into employee(employee_name, employee_salary, type_employee, branch_id) values ( 'piti ongmonkonkul', 40000, 'staff', 1) ON CONFLICT DO NOTHING ;

insert into employee(employee_name, employee_salary, type_employee, branch_id) values ( 'Tath Kanchanarin', 50000, 'pharmacist', 1) ON CONFLICT DO NOTHING;
insert into employee(employee_name, employee_salary, type_employee, branch_id) values ('Austin Maddison', 30000, 'staff', 2) ON CONFLICT DO NOTHING;
insert into employee(employee_name, employee_salary, type_employee, branch_id) values ('Phavarisa Limchitti', 70000, 'pharmacist', 2) ON CONFLICT DO NOTHING ;

insert into employee(employee_name, employee_salary, type_employee, branch_id) values ('Leibniz', 20000, 'staff', 2) ON CONFLICT DO NOTHING;
insert into employee(employee_name, employee_salary, type_employee, branch_id) values ('Feynmann', 20000, 'staff', 2) ON CONFLICT DO NOTHING;
insert into employee(employee_name, employee_salary, type_employee, branch_id) values ('Patrick Batemann', 15000, 'staff', 1) ON CONFLICT DO NOTHING;

insert into employee(employee_name, employee_salary, type_employee, branch_id) values ('Luffy', 20000, 'staff', 2) ON CONFLICT DO NOTHING;
insert into employee(employee_name, employee_salary, type_employee, branch_id) values ('Sanji', 20000, 'staff', 2) ON CONFLICT DO NOTHING;
insert into employee(employee_name, employee_salary, type_employee, branch_id) values ('Batman', 15000, 'staff', 1) ON CONFLICT DO NOTHING;


