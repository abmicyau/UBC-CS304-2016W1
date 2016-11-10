drop table Pharmacy_Assistant;
drop table Pharmacist;
drop table Pharmacy_Technician;
drop table Employee; 
-- EMPLOYEE MUST BE DROPPED AFTER 3 SUBCLASSES

-- drop table Pharmacy_managed;
-- drop table Works_in;
-- drop table Prescription_prescribed_by_is_for;
-- drop table service_provides;
-- drop table Prescription_item_has;
-- drop table Item_consistof_drug;
-- drop table Drug;
-- drop table Over_the_counter_drug;
-- drop table Vaccination;
-- drop table Doctor;
-- drop table Stock_drug;
-- drop table Vaccination_consistof_drug;
-- drop table Payment_paid_by;
-- drop table Subsidizes;
-- drop table Customer;
-- drop table Patient;
-- drop table Walk_in_Client;
-- drop table Pharmacy_record_has;

create table Employee
	(emp_id int not null,
	email varchar2(60) null,
	date_of_birth date null, 
	address varchar2(50) null,
	name varchar2(50) null,
	phone_number char(10) null, 
	gender char(1) null,
	sin char(9) not null,
	primary key (emp_id));

insert into Employee
values (0, 'dtrump@hotmail.com', '1946-06-14', '123 Fake Street', 'Donald Trump', '6041111111', 'M', '000011234'); 


insert into Employee
values (1, 'clinton_h@gmail.com', '1947-10-26', '1600 Pennsylvania Avenue', 'Hillary Clinton', '6042222222', 'F', '119023228'); 


insert into Employee
values (2, 'drake_swag@yahoo.ca', '1986-10-24', '8200 Dalhousie Rd', 'Aubrey Drake', '6043333333', 'M', '778823456'); 


insert into Employee
values (3, 'thisisfame@aol.ca', '1977-06-08', '145 Calabasa Avenue', 'Kanye West', '6044444444', 'M', '122398009'); 


insert into Employee
values (4, 'hermoine@hogwarts.ca', '1990-04-15', '22 Jump Street', 'Emma Watson', '6045555555', 'F', '100976523'); 


create table Pharmacy_Assistant
	(emp_id int not null,
	primary key (emp_id),
foreign key (emp_id) references Employee ON DELETE CASCADE);

insert into Pharmacy_Assistant
values (0);


create table Pharmacist
	(emp_id int not null,
	liability_insurance varchar2(40) null,
	license_number char(8) not null,
	primary key (emp_id),
foreign key (emp_id) references Employee ON DELETE CASCADE);

insert into Pharmacist
values (1, 'Westland Insurance', '00000000');

insert into Pharmacist
values (2, 'Eastland Insurance', '00000001');


create table Pharmacy_Technician
	(emp_id int not null,
	license_number char(8) not null,
	primary key (emp_id),
foreign key (emp_id) references Employee ON DELETE CASCADE);

insert into Pharmacy_Technician
values (3, '00000002');

insert into Pharmacy_Technician
values (4, '00000003');


-- create table Pharmacy_managed
-- (store_id char(8) primary key not null,
--  emp_id char(8) not null, 
--  address char(40) not null,
--  name char(40) not null,
--  phone_number	 char(40) null,
--  foreign key (emp_id) references Employee ON DELETE CASCADE
-- 	);


-- insert into Pharmacy_managed
-- values ('00000000', '00000001', '2748 E Hastings St.', 'Shoppers Drug Mart', '604-251-5358');
	
-- create table Works_in
-- 	(emp_id char(8) not null,
-- 	 store_id char(8) not null,
-- 	 primary key (emp_id, store_id), 
-- 	 foreign key (emp_id) references Employee ON DELETE CASCADE, 
-- 	 foreign key (store_Id) references Pharmacy ON DELETE CASCADE);


-- insert into Works_in
-- values ('00000000', '00000000');


-- insert into Works_in
-- values ('00000001', '00000000');


-- insert into Works_in
-- values ('00000002', '00000000');


-- insert into Works_in
-- values ('00000003', '00000000');


-- insert into Works_in
-- values ('00000004', '00000000');


-- create table Prescription_prescribed_by_is_for
-- 	(service_id char(8) not null,
-- 	 doctor_id char(8) not null,
-- 	 customer_id char(8) not null,
-- 	 prescription_id char(8) not null, 
-- 	 date_prescribed char(10) not null, 
-- 	 primary key (service_id), 
-- 	 foreign key (doctor_id) references Doctor ON DELETE CASCADE, 
-- 	 foreign key (customer_id) references Patient ON DELETE CASCADE
-- 	);


-- insert into Prescription_prescribed_by_is_for
-- values ('00000000', '00000000', '00000000', '00000000', '2016-10-16');


-- insert into Prescription_prescribed_by_is_for
-- values ('00000001', '00000000', '00000001', '00000001', '2016-10-16');


-- insert into Prescription_prescribed_by_is_for
-- values ('00000002', '00000001', '00000002', '00000002', '2016-10-16');


-- insert into Prescription_prescribed_by_is_for
-- values ('00000003', '00000001', '00000003', '00000003', '2016-10-16');


-- insert into Prescription_prescribed_by_is_for
-- values ('00000004', '00000001', '00000004', '00000004', '2016-10-16');


-- create table Service_provides
-- 	(service_id char(8) not null,
-- 	emp_id char(8) not null,
-- 	primary key (service_id, emp_id), 
-- foreign key (emp_id) references Pharmacist ON DELETE CASCADE); 


-- insert into Service_provides
-- values ('00000000', '00000000');


-- insert into Service_provides
-- values ('00000001', '00000004');


-- insert into Service_provides
-- values ('00000002', '00000002');


-- insert into Service_provides
-- values ('00000003', '00000001');


-- insert into Service_provides
-- values ('00000004', '00000003');


-- create table Prescription_item_has
-- (item_id char(8) not null,
--  prescription_id char(8) not null,
--  dose varchar(16) not null,
--  duration varchar(40) not null,
--  frequency varchar(40) not null,
--  primary key (item_id, prescription_id), 
--  foreign key (prescription_id) references Prescription ON DELETE CASCADE
-- );
-- insert into Prescription_item_has
-- values ('00000000', '00000000', '20 mg', '3 weeks', '1 capsule QID');
-- insert into Prescription_item_has
-- values ('00000001', '00000000', '80 mg', '2 weeks', '3 pills QD');
-- insert into Prescription_item_has
-- values ('00000002', '00000000', '100 mg', '2 weeks', '2 capsules TID');
-- insert into Prescription_item_has
-- values ('00000003', '00000001', '15 mg', '5 days', '1 pill every 3 hours);
-- insert into Prescription_item_has
-- values ('00000004', '00000001', '180 mg', '5 days', '2 tablets every 8 hours');


-- create table Item_consistof_drug 
-- 	(item_id char(8) not null,
-- 	 DIN char(8) not null,
-- 	 primary key (item_id, DIN), 
-- 	 foreign key (item_id) references Prescription_item ON DELETE CASCADE, 
--  	 foreign key (DIN) references Drug ON DELETE CASCADE
-- 	);


-- insert into Item_consistof_drug
-- values ('00000000' '00000000');
-- insert into Item_consistof_drug
-- values ('00000001' '00000001');
-- insert into Item_consistof_drug
-- values ('00000002' '00000002');
-- insert into Item_consistof_drug
-- values ('00000003' '00000003');
-- insert into Item_consistof_drug
-- values ('00000004' '00000004');


-- create table Drug
-- 	(DIN char(8) not null, 
-- 	 drug_name_INN varchar(25) not null,
-- 	 drug_name_trade varchar(25) not null,
-- 	 drug_description varchar(300) null,
-- 	 contraindications varchar(300) null,
-- 	 primary key (DIN)); 


-- insert into Drug
-- values ('00000000', 'Morphine', 'Oramorph', 'Strong opiate analgesic', 'Respiratory depression, acute pancreatitis');


-- insert into Drug
-- values ('00000001', 'Acetaminophen', 'Tylenol', 'Analgesic, antipyretic', 'Acute liver failure, shock');


-- insert into Drug
-- values ('00000002', 'Fluoxetine', 'Prozac', 'SSRI antidepressant', 'MAO inhibitors');


-- insert into Drug
-- values ('00000003', 'Diazepam', 'Valium', 'Benzodiazepine relaxant', 'Ataxia, severe hypoventilation, acute narrow-angle glaucoma, severe hepatic deficiencies (hepatitis and liver cirrhosis decrease elimination by a factor of two), severe renal deficiencies (for example, patients on dialysis), liver disorders, severe sleep apnea, severe depression, particularly when accompanied by suicidal tendencies, psychosis, pregnancy or breast feeding, caution required in elderly or debilitated patients, coma or shock, abrupt discontinuation of therapy, acute intoxication with alcohol, narcotics, or other psychoactive substances (with the exception of some hallucinogens and/or stimulants, where it is occasionally used as a treatment for overdose), history of alcohol or drug dependence, myasthenia gravis, an autoimmune disorder causing marked fatiguability, hypersensitivity or allergy to any drug in the benzodiazepine class');


-- insert into Drug
-- values ('00000004', 'Amoxicillin', 'Amoxil', 'Beta-lactam antibiotic', 'hypersensitivity to beta-lactam antibiotics');


-- create table Over_the_counter_drug 
-- 	(DIN char(8) not null,
-- 	 brand varchar(16) null,
-- 	 cost varchar(10) null,
-- 	 quantity char(10) null,
-- 	 primary key (DIN), 
-- 	 foreign key (DIN) references Drug ON DELETE CASCADE
-- 	);


-- insert into Over_the_counter_drug
-- values ('10001000, 'Advil', '$20.00', 100); 


-- insert into Over_the_counter_drug
-- values ('20002000, 'Tylenol', '$20.00', 150); 


-- insert into Over_the_counter_drug
-- values ('30003000, 'Reactine', '$13.00', 100); 


-- insert into Over_the_counter_drug
-- values ('40004000, 'Theraflu', '$11.00', 10); 


-- insert into Over_the_counter_drug
-- values ('50005000, 'NyQuil', '$8.00', 77); 




-- create table Vaccination 
-- 	(service_id char(8) not null, 
-- 	 vaccination_id char(8) null,
-- 	 date_vaccinated char(10) null,
-- 	 dose varchar(16) null,
-- 	 primary key (service_id), 
-- 	 foreign key (service_id) references Service ON DELETE CASCADE
-- ); 


-- Insert into Vaccination
-- values ('00000000', '10000000', '2016-02-23', '3mg'); 


-- Insert into Vaccination
-- values ('00000001', '20000000', '2015-12-03', '2mg'); 


-- Insert into Vaccination
-- values ('00000002', '30000000', '2016-06-03', '1mg'); 


-- create table Doctor 
-- 	(doctor_id char(8) not null,
-- 	 phone_number char(10) not null,
-- 	 name varchar(20),
-- 	 primary key (doctor_id)
-- 	);


-- insert into Doctor
-- values ('00000000', '778-888-1234', 'Dr. Miranda Bailey');


-- insert into Doctor
-- values ('00000001', '604-568-1234', 'Dr. Meredith Grey');


-- insert into Doctor
-- values ('00000002', '604-596-9923', 'Dr. Gregory House');


-- insert into Doctor
-- values ('00000003', '778-221-7865', 'Dr. Derek Shepherd');


-- insert into Doctor
-- values ('00000004', '403-555-2213', 'Dr. Christina Yang');


-- create table Stock_drug
-- 	(DIN char(8) not null,
-- 	 quantity varchar(10) null,
-- 	 cost_rate varchar(10) null,
-- 	 primary key (DIN), 
-- 	 foreign key (DIN) references Drug ON DELETE CASCADE
-- 	);




-- create table Payment_paid_by
-- 	(paymentId char(8) not null, 
-- 	customer_id char(8) not null,
-- 	date char(10) not null,
-- 	total char(10) not null,
-- 	cardNumber char(12) not null,
-- 	cardExpDate char(10) not null,
-- 	time char(5) not null,
-- 	primary key (paymentId), 
-- 	foreign key (customer_id) references Customer ON DELETE CASCADE 
-- 	); 


-- insert into Payment_paid_by
-- values ('11111111', '00000000', '2016-11-23', '$22.30', '123456789012', '2018-08-29', '13:00');


-- insert into Payment_paid_by
-- values ('22222222', '00000001', '2016-01-03', '$2.30', '412398792345', '2020-01-31', '14:45');


-- insert into Payment_paid_by
-- values ('33333333', '00000002', '2016-04-20', '$11.02', '543098672345', '2016-12-14', '09:11');


-- insert into Payment_paid_by
-- values ('44444444', '00000003', '2015-12-31', '$44.44', '432898761239', '2018-08-11', '11:37');


-- insert into Payment_paid_by
-- values ('55555555', '00000004', '2016-10-18', '$9.35', '543687931112', '2017-02-01', '16:07');


-- create table Insurance_coverage
-- 	(policyId char(8) not null,
-- 	 expDate char(10) null,
-- 	 maxAllowance int null,
--   	 company varchar (40) null,
-- 	 primary key (policyId)
-- ); 




-- create table Subsidizes
-- 	(paymentId char(8) not null, 
-- 	 policyId char(8) not null, 
-- 	 primary key (paymentId, policyId), 
-- 	 foreign key (paymentId) references Payment ON DELETE CASCADE, 
-- 	 foreign key (policyId) references Insurance_coverage ON DELETE CASCADE
-- ); 


-- create table Customer
-- 	(customer_id char(8) not null,
-- 	 name varchar(25) null,
-- 	 phone_number char(12) null,
-- 	 insurance_info varchar(30) null,
-- 	 primary key (customer_id)
-- 	);


-- insert into Customer
-- values ('00000000', 'Harry Potter', '778-112-9876', 'Westland Insurance');


-- insert into Customer
-- values ('00000001', 'Pikachu Chu', '604-552-5673', 'Westland Insurance');


-- insert into Customer
-- values ('00000002', 'Angelina Jolie', '604-234-6754', 'Blue Cross');


-- insert into Customer
-- values ('00000003', 'Ken Bone', '778-332-4326', 'Eastland Insurance');


-- insert into Customer
-- values ('00000004', 'Oprah Winfrey', '604-832-0986', 'Blue Cross');


-- create table Patient
-- 	(customer_Id char(8) not null,
-- 	 care_card_number char(16) not null,
-- 	 address char(20) null,
-- 	 birthdate char(10) null,
-- 	 gender char(1) null,
-- 	 primary key (customer_Id), 
-- 	 foreign key (customer_Id) references Customer ON DELETE CASCADE
-- 	);


-- insert into Patient
-- values ('00000000', '9123456798342343', '22B Baker Street', '1954-01-29', 'F');


-- insert into Patient
-- values ('00000001', '9100567832130097', '1766 Willow St.', '1975-06-04', 'F');


-- insert into Patient
-- values ('00000002', '9322998812344631', '567 Evergreen Ave.', '1980-07-31', 'M');


-- create table Walk_in_Client
-- 	(customer_Id char(8) not null, 
-- 	 primary key (customer_Id), 
-- 	 foreign key (customer_Id) references Customer ON DELETE CASCADE
-- 	); 


-- insert into Walk_in_Client
-- values ('00000003');


-- insert into Walk_in_Client
-- values ('00000004');


-- create table Pharmacy_record_has 
-- 	(record_id char(10) not null,
-- 	 care_card_number char(16) not null,
-- 	 purchasing_history varchar(100),
-- 	 primary key (record_id, care_card_number)
--  foreign key (care_card_number) references Patient ON DELETE CASCADE
-- );


-- insert into Pharmacy_record_has
-- values ('0000000000', '9123456798342343', 'Patient is up to date with all medication');


-- insert into Pharmacy_record_has
-- values ('0000000001', '9100567832130097', 'Patient switched brand of birth control');


-- insert into Pharmacy_record_has
-- values ('0000000002', '9322998812344631', 'Patient is up to date with all medication');
