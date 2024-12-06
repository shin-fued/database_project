insert into branches(id, branch_name, location) values (1,'salaya', 'salaya thailand') ON CONFLICT DO NOTHING;
insert into branches(id,  branch_name, location) values (2, 'bangkok', 'bangkok thailand') ON CONFLICT DO NOTHING;

INSERT INTO drugs(drug_name, brand_name, price, tag,approval) VALUES ('Paracetamol', 'Calpol', 20.5, 'fever', True) ON CONFLICT DO NOTHING;
INSERT INTO drugs(drug_name, brand_name, price, tag,approval) VALUES ('Ibuprofen', 'Brufen', 50.0, 'pain', True) ON CONFLICT DO NOTHING;
INSERT INTO drugs(drug_name, brand_name, price, tag,approval) VALUES ('Cetirizine', 'Cetzine', 15.75, 'allergy', True) ON CONFLICT DO NOTHING;
INSERT INTO drugs(drug_name, brand_name, price, tag,approval) VALUES ('Amoxicillin', 'Amoxil', 120.0, 'antibiotic', True) ON CONFLICT DO NOTHING;
INSERT INTO drugs(drug_name, brand_name, price, tag,approval) VALUES ('Omeprazole', 'Omez', 80.0, 'acidity', True) ON CONFLICT DO NOTHING;
INSERT INTO drugs(drug_name, brand_name, price, tag,approval) VALUES ('Metformin', 'Glyciphage', 90.0, 'diabetes', True) ON CONFLICT DO NOTHING;
INSERT INTO drugs(drug_name, brand_name, price, tag,approval) VALUES ('Losartan', 'Losar', 70.0, 'hypertension', True) ON CONFLICT DO NOTHING;
INSERT INTO drugs(drug_name, brand_name, price, tag,approval) VALUES ('Salbutamol', 'Asthalin', 30.0, 'asthma', True) ON CONFLICT DO NOTHING;
INSERT INTO drugs(drug_name, brand_name, price, tag,approval) VALUES ('Ranitidine', 'Zinetac', 25.0, 'ulcers', False) ON CONFLICT DO NOTHING;
INSERT INTO drugs(drug_name, brand_name, price, tag,approval) VALUES ('Hydroxychloroquine', 'HCQ', 150.0, 'malaria', True) ON CONFLICT DO NOTHING;
INSERT INTO drugs(drug_name, brand_name, price, tag,approval) VALUES ('Aspirin', 'Ecosprin', 40.0, 'pain', True) ON CONFLICT DO NOTHING;
INSERT INTO drugs(drug_name, brand_name, price, tag,approval) VALUES ('Clopidogrel', 'Plavix', 120.0, 'heart', True) ON CONFLICT DO NOTHING;
INSERT INTO drugs(drug_name, brand_name, price, tag,approval) VALUES ('Atorvastatin', 'Lipitor', 110.0, 'cholesterol', True) ON CONFLICT DO NOTHING;
INSERT INTO drugs(drug_name, brand_name, price, tag,approval) VALUES ('Montelukast', 'Montair', 95.0, 'allergy', True) ON CONFLICT DO NOTHING;
INSERT INTO drugs(drug_name, brand_name, price, tag,approval) VALUES ('Levothyroxine', 'Thyronorm', 75.0, 'thyroid', True) ON CONFLICT DO NOTHING;
INSERT INTO drugs(drug_name, brand_name, price, tag,approval) VALUES ('Gliclazide', 'Diamicron', 100.0, 'diabetes', True) ON CONFLICT DO NOTHING;
INSERT INTO drugs(drug_name, brand_name, price, tag,approval) VALUES ('Azithromycin', 'Zithromax', 150.0, 'antibiotic', True) ON CONFLICT DO NOTHING;
INSERT INTO drugs(drug_name, brand_name, price, tag,approval) VALUES ('Doxycycline', 'Doxinate', 130.0, 'antibiotic', False) ON CONFLICT DO NOTHING;
INSERT INTO drugs(drug_name, brand_name, price, tag,approval) VALUES ('Furosemide', 'Lasix', 65.0, 'diuretic', True) ON CONFLICT DO NOTHING;
INSERT INTO drugs(drug_name, brand_name, price, tag,approval) VALUES ('Prednisolone', 'Omnacortil', 85.0, 'steroid', True) ON CONFLICT DO NOTHING;
INSERT INTO drugs(drug_name, brand_name, price, tag,approval) VALUES ('Pantoprazole', 'Pantocid', 90.0, 'acidity', True) ON CONFLICT DO NOTHING;
INSERT INTO drugs(drug_name, brand_name, price, tag,approval) VALUES ('Diclofenac', 'Voveran', 50.0, 'pain', True) ON CONFLICT DO NOTHING;
INSERT INTO drugs(drug_name, brand_name, price, tag,approval) VALUES ('Ciprofloxacin', 'Ciplox', 110.0, 'antibiotic', True) ON CONFLICT DO NOTHING;
INSERT INTO drugs(drug_name, brand_name, price, tag,approval) VALUES ('Insulin Glargine', 'Lantus', 300.0, 'diabetes', True) ON CONFLICT DO NOTHING;


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

INSERT INTO stock(branch_id, drug_id,brand_name, amount,expiration_date) VALUES (1, (SELECT id from drugs WHERE brand_name='Calpol'),'Calpol', 1000, '2035-05-11') ON CONFLICT DO NOTHING;
INSERT INTO stock(branch_id, drug_id,brand_name, amount,expiration_date) VALUES (2, (SELECT id from drugs WHERE brand_name='Calpol'),'Calpol', 1000, '2035-05-11') ON CONFLICT DO NOTHING;
INSERT INTO stock(branch_id, drug_id,brand_name, amount,expiration_date) VALUES (1, (SELECT id from drugs WHERE brand_name='Brufen'),'Brufen', 1000, '2038-11-12') ON CONFLICT DO NOTHING;
INSERT INTO stock(branch_id, drug_id,brand_name, amount,expiration_date) VALUES (2, (SELECT id from drugs WHERE brand_name='Brufen'),'Brufen', 1000, '2038-11-12') ON CONFLICT DO NOTHING;
INSERT INTO stock(branch_id, drug_id,brand_name, amount,expiration_date) VALUES (1, (SELECT id from drugs WHERE brand_name='Cetzine'),'Cetzine', 1000, '2035-04-24') ON CONFLICT DO NOTHING;
INSERT INTO stock(branch_id, drug_id,brand_name, amount,expiration_date) VALUES (2, (SELECT id from drugs WHERE brand_name='Cetzine'),'Cetzine', 1000, '2035-04-24') ON CONFLICT DO NOTHING;
INSERT INTO stock(branch_id, drug_id,brand_name, amount,expiration_date) VALUES (1, (SELECT id from drugs WHERE brand_name='Amoxil'),'Amoxil', 1000, '2038-04-28') ON CONFLICT DO NOTHING;
INSERT INTO stock(branch_id, drug_id,brand_name, amount,expiration_date) VALUES (2, (SELECT id from drugs WHERE brand_name='Amoxil'),'Amoxil', 1000, '2038-04-28') ON CONFLICT DO NOTHING;
INSERT INTO stock(branch_id, drug_id,brand_name, amount,expiration_date) VALUES (1, (SELECT id from drugs WHERE brand_name='Omez'),'Omez', 1000, '2028-04-16') ON CONFLICT DO NOTHING;
INSERT INTO stock(branch_id, drug_id,brand_name, amount,expiration_date) VALUES (2, (SELECT id from drugs WHERE brand_name='Omez'),'Omez', 1000, '2028-04-16') ON CONFLICT DO NOTHING;
INSERT INTO stock(branch_id, drug_id,brand_name, amount,expiration_date) VALUES (1, (SELECT id from drugs WHERE brand_name='Glyciphage'),'Glyciphage', 1000, '2037-08-05') ON CONFLICT DO NOTHING;
INSERT INTO stock(branch_id, drug_id,brand_name, amount,expiration_date) VALUES (2, (SELECT id from drugs WHERE brand_name='Glyciphage'),'Glyciphage', 1000, '2037-08-05') ON CONFLICT DO NOTHING;
INSERT INTO stock(branch_id, drug_id,brand_name, amount,expiration_date) VALUES (1, (SELECT id from drugs WHERE brand_name='Losar'),'Losar', 1000, '2034-12-22') ON CONFLICT DO NOTHING;
INSERT INTO stock(branch_id, drug_id,brand_name, amount,expiration_date) VALUES (2, (SELECT id from drugs WHERE brand_name='Losar'),'Losar', 1000, '2034-12-22') ON CONFLICT DO NOTHING;
INSERT INTO stock(branch_id, drug_id,brand_name, amount,expiration_date) VALUES (1, (SELECT id from drugs WHERE brand_name='Asthalin'),'Asthalin', 1000, '2031-10-31') ON CONFLICT DO NOTHING;
INSERT INTO stock(branch_id, drug_id,brand_name, amount,expiration_date) VALUES (2, (SELECT id from drugs WHERE brand_name='Asthalin'),'Asthalin', 1000, '2031-10-31') ON CONFLICT DO NOTHING;
INSERT INTO stock(branch_id, drug_id,brand_name, amount,expiration_date) VALUES (1, (SELECT id from drugs WHERE brand_name='Zinetac'),'Zinetac', 1000, '2039-08-20') ON CONFLICT DO NOTHING;
INSERT INTO stock(branch_id, drug_id,brand_name, amount,expiration_date) VALUES (2, (SELECT id from drugs WHERE brand_name='Zinetac'),'Zinetac', 1000, '2039-08-20') ON CONFLICT DO NOTHING;
INSERT INTO stock(branch_id, drug_id,brand_name, amount,expiration_date) VALUES (1, (SELECT id from drugs WHERE brand_name='HCQ'),'HCQ', 1000, '2031-06-24') ON CONFLICT DO NOTHING;
INSERT INTO stock(branch_id, drug_id,brand_name, amount,expiration_date) VALUES (2, (SELECT id from drugs WHERE brand_name='HCQ'),'HCQ', 1000, '2031-06-24') ON CONFLICT DO NOTHING;
INSERT INTO stock(branch_id, drug_id,brand_name, amount,expiration_date) VALUES (1, (SELECT id from drugs WHERE brand_name='Ecosprin'),'Ecosprin', 1000, '2038-04-13') ON CONFLICT DO NOTHING;
INSERT INTO stock(branch_id, drug_id,brand_name, amount,expiration_date) VALUES (2, (SELECT id from drugs WHERE brand_name='Ecosprin'),'Ecosprin', 1000, '2038-04-13') ON CONFLICT DO NOTHING;
INSERT INTO stock(branch_id, drug_id,brand_name, amount,expiration_date) VALUES (1, (SELECT id from drugs WHERE brand_name='Plavix'),'Plavix', 1000, '2039-06-19') ON CONFLICT DO NOTHING;
INSERT INTO stock(branch_id, drug_id,brand_name, amount,expiration_date) VALUES (2, (SELECT id from drugs WHERE brand_name='Plavix'),'Plavix', 1000, '2039-06-19') ON CONFLICT DO NOTHING;
INSERT INTO stock(branch_id, drug_id,brand_name, amount,expiration_date) VALUES (1, (SELECT id from drugs WHERE brand_name='Lipitor'),'Lipitor', 1000, '2035-01-22') ON CONFLICT DO NOTHING;
INSERT INTO stock(branch_id, drug_id,brand_name, amount,expiration_date) VALUES (2, (SELECT id from drugs WHERE brand_name='Lipitor'),'Lipitor', 1000, '2035-01-22') ON CONFLICT DO NOTHING;
INSERT INTO stock(branch_id, drug_id,brand_name, amount,expiration_date) VALUES (1, (SELECT id from drugs WHERE brand_name='Montair'),'Montair', 1000, '2039-02-03') ON CONFLICT DO NOTHING;
INSERT INTO stock(branch_id, drug_id,brand_name, amount,expiration_date) VALUES (2, (SELECT id from drugs WHERE brand_name='Montair'),'Montair', 1000, '2039-02-03') ON CONFLICT DO NOTHING;
INSERT INTO stock(branch_id, drug_id,brand_name, amount,expiration_date) VALUES (1, (SELECT id from drugs WHERE brand_name='Thyronorm'),'Thyronorm', 1000, '2026-01-29') ON CONFLICT DO NOTHING;
INSERT INTO stock(branch_id, drug_id,brand_name, amount,expiration_date) VALUES (2, (SELECT id from drugs WHERE brand_name='Thyronorm'),'Thyronorm', 1000, '2026-01-29') ON CONFLICT DO NOTHING;
INSERT INTO stock(branch_id, drug_id,brand_name, amount,expiration_date) VALUES (1, (SELECT id from drugs WHERE brand_name='Diamicron'),'Diamicron', 1000, '2035-10-22') ON CONFLICT DO NOTHING;
INSERT INTO stock(branch_id, drug_id,brand_name, amount,expiration_date) VALUES (2, (SELECT id from drugs WHERE brand_name='Diamicron'),'Diamicron', 1000, '2035-10-22') ON CONFLICT DO NOTHING;
INSERT INTO stock(branch_id, drug_id,brand_name, amount,expiration_date) VALUES (1, (SELECT id from drugs WHERE brand_name='Zithromax'),'Zithromax', 1000, '2031-04-26') ON CONFLICT DO NOTHING;
INSERT INTO stock(branch_id, drug_id,brand_name, amount,expiration_date) VALUES (2, (SELECT id from drugs WHERE brand_name='Zithromax'),'Zithromax', 1000, '2031-04-26') ON CONFLICT DO NOTHING;
INSERT INTO stock(branch_id, drug_id,brand_name, amount,expiration_date) VALUES (1, (SELECT id from drugs WHERE brand_name='Doxinate'),'Doxinate', 1000, '2027-02-06') ON CONFLICT DO NOTHING;
INSERT INTO stock(branch_id, drug_id,brand_name, amount,expiration_date) VALUES (2, (SELECT id from drugs WHERE brand_name='Doxinate'),'Doxinate', 1000, '2027-02-06') ON CONFLICT DO NOTHING;
INSERT INTO stock(branch_id, drug_id,brand_name, amount,expiration_date) VALUES (1, (SELECT id from drugs WHERE brand_name='Lasix'),'Lasix', 1000, '2037-07-14') ON CONFLICT DO NOTHING;
INSERT INTO stock(branch_id, drug_id,brand_name, amount,expiration_date) VALUES (2, (SELECT id from drugs WHERE brand_name='Lasix'),'Lasix', 1000, '2037-07-14') ON CONFLICT DO NOTHING;
INSERT INTO stock(branch_id, drug_id,brand_name, amount,expiration_date) VALUES (1, (SELECT id from drugs WHERE brand_name='Omnacortil'),'Omnacortil', 1000, '2035-05-17') ON CONFLICT DO NOTHING;
INSERT INTO stock(branch_id, drug_id,brand_name, amount,expiration_date) VALUES (2, (SELECT id from drugs WHERE brand_name='Omnacortil'),'Omnacortil', 1000, '2035-05-17') ON CONFLICT DO NOTHING;
INSERT INTO stock(branch_id, drug_id,brand_name, amount,expiration_date) VALUES (1, (SELECT id from drugs WHERE brand_name='Pantocid'),'Pantocid', 1000, '2038-05-26') ON CONFLICT DO NOTHING;
INSERT INTO stock(branch_id, drug_id,brand_name, amount,expiration_date) VALUES (2, (SELECT id from drugs WHERE brand_name='Pantocid'),'Pantocid', 1000, '2038-05-26') ON CONFLICT DO NOTHING;
INSERT INTO stock(branch_id, drug_id,brand_name, amount,expiration_date) VALUES (1, (SELECT id from drugs WHERE brand_name='Voveran'),'Voveran', 1000, '2034-02-11') ON CONFLICT DO NOTHING;
INSERT INTO stock(branch_id, drug_id,brand_name, amount,expiration_date) VALUES (2, (SELECT id from drugs WHERE brand_name='Voveran'),'Voveran', 1000, '2034-02-11') ON CONFLICT DO NOTHING;
INSERT INTO stock(branch_id, drug_id,brand_name, amount,expiration_date) VALUES (1, (SELECT id from drugs WHERE brand_name='Ciplox'),'Ciplox', 1000, '2028-02-21') ON CONFLICT DO NOTHING;
INSERT INTO stock(branch_id, drug_id,brand_name, amount,expiration_date) VALUES (2, (SELECT id from drugs WHERE brand_name='Ciplox'),'Ciplox', 1000, '2028-02-21') ON CONFLICT DO NOTHING;
INSERT INTO stock(branch_id, drug_id,brand_name, amount,expiration_date) VALUES (1, (SELECT id from drugs WHERE brand_name='Lantus'),'Lantus', 1000, '2026-06-16') ON CONFLICT DO NOTHING;
INSERT INTO stock(branch_id, drug_id,brand_name, amount,expiration_date) VALUES (2, (SELECT id from drugs WHERE brand_name='Lantus'),'Lantus', 1000, '2026-06-16') ON CONFLICT DO NOTHING;


SELECT make_order(10, 1000, 2);
SELECT make_order(20, 1000, 2);
SELECT make_order(2, 1001, 1);
SELECT make_order(23, 1001, 1);

SELECT make_purchase('aaaa', 1, 1, 1,3);

select make_purchase('cccc', 6, 4, 1, 4);
select make_purchase('eeee', 6, 4, 1, 4);


INSERT INTO shift(shift_number, employee_id, branch_id, date) values(1,1,1, CURRENT_DATE

) ON CONFLICT DO NOTHING;

INSERT INTO shift(shift_number, employee_id, branch_id, date) values(3,2,2, CURRENT_DATE

) ON CONFLICT DO NOTHING;

INSERT INTO shift(shift_number, employee_id, branch_id, date) values(1,5,1, CURRENT_DATE

) ON CONFLICT DO NOTHING;

INSERT INTO shift(shift_number, employee_id, branch_id, date) values(1,7,1, CURRENT_DATE

) ON CONFLICT DO NOTHING;
