drop table Vaccination;
drop table Service_provides;
drop table Pharmacy_Assistant;
drop table Pharmacist;
drop table Pharmacy_Technician;
drop table Works_in;
drop table Pharmacy_managed;
drop table Employee;
drop table Item_consistof_drug;
drop table Prescription_item_has;
drop table Prescription_by_is_for;
drop table Over_the_counter_drug;
drop table Stock_drug;
drop table Drug;
drop table Doctor;
drop table Subsidizes;
drop table Insurance_coverage;
drop table Payment_paid_by;
drop table Pharmacy_record_has;
drop table Patient;
drop table Walk_in_Client;
drop table Customer;

----------------------------------------------------------------

create table Employee
	(emp_id int not null,
	email varchar2(64) null,
	date_of_birth date null, 
	address varchar2(64) null,
	name varchar2(32) null,
	phone_number varchar2(32) null, 
	gender char(1) null,
	sin char(9) not null,
	username varchar2(32) null,
	password varchar2(32) null,
	primary key (emp_id));

create table Pharmacy_Assistant
	(emp_id int not null,
	primary key (emp_id),
	foreign key (emp_id) references Employee ON DELETE CASCADE);

create table Pharmacist
	(emp_id int not null,
	liability_insurance varchar2(40) null,
	license_number char(8) not null,
	primary key (emp_id),
	foreign key (emp_id) references Employee ON DELETE CASCADE);

create table Pharmacy_Technician
	(emp_id int not null,
	license_number char(8) not null,
	primary key (emp_id),
	foreign key (emp_id) references Employee ON DELETE CASCADE);

create table Pharmacy_managed
	(store_id int not null, 
	emp_id int not null, 
	address char(64) not null,
	name char(64) not null,
	phone_number varchar2(32) null,
	primary key (store_id),
	foreign key (emp_id) references Employee ON DELETE CASCADE);

create table Works_in
	(emp_id int not null,
	 store_id int not null,
	 primary key (emp_id, store_id), 
	 foreign key (emp_id) references Employee ON DELETE CASCADE, 
	 foreign key (store_Id) references Pharmacy_managed ON DELETE CASCADE);

-- TODO: Add tuples for Works_in

 create table Doctor 
 	(doctor_id int not null,
 	 phone_number varchar2(32) not null,
 	 name varchar2(32),
 	 primary key (doctor_id)
 	);

create table Customer
	(customer_id char(8) not null,
	 name varchar2(32) null,
 	 phone_number varchar2(32) null,
	 insurance_info varchar2(32) null,
 	 primary key (customer_id)
 	);

 create table Patient
 	(customer_Id char(8) not null,
 	 care_card_number char(16) not null unique,
 	 address char(32) null,
 	 birthdate date null,
 	 gender char(1) null,
 	 primary key (customer_Id), 
 	 foreign key (customer_Id) references Customer ON DELETE CASCADE
 	);

 create table Prescription_by_is_for
 	(service_id char(8) not null,
	 doctor_id int not null,
 	 customer_id char(8) not null,
 	 prescription_id char(8) not null, 
 	 date_prescribed date not null, 
	 primary key (service_id), 
 	 foreign key (doctor_id) references Doctor ON DELETE CASCADE, 
	 foreign key (customer_id) references Patient ON DELETE CASCADE
 	);

create table Prescription_item_has
	(item_id char(8) not null unique,
 	 prescription_id char(8) not null,
	 dose varchar2(16) not null,
 	 duration varchar2(32) not null,
 	 frequency varchar2(32) not null,
 	 primary key (item_id, prescription_id), 
 	 foreign key (prescription_id) references Prescription_by_is_for ON DELETE CASCADE
	);

create table Pharmacy_record_has 
 	(record_id char(10) not null,
 	 care_card_number char(16) not null,
 	 purchasing_history varchar2(128),
 	 primary key (record_id, care_card_number),
 	 foreign key (care_card_number) references Patient (care_card_number) ON DELETE CASCADE
 	);

create table Service_provides
	(service_id char(8) not null unique,
	 emp_id int not null,
	 primary key (service_id, emp_id), 
	 foreign key (emp_id) references Pharmacist ON DELETE CASCADE
	); 

create table Vaccination 
	(service_id char(8) not null, 
 	 vaccination_id char(8) null,
	 date_vaccinated char(10) null,
 	 dose varchar2(16) null,
 	 primary key (service_id), 
 	 foreign key (service_id) references Service_provides (service_id) ON DELETE CASCADE
 	); 

create table Drug
	(DIN int not null, 
	 drug_name_INN varchar2(512) not null,
	 drug_name_trade varchar2(512) not null,
	 drug_description varchar2(512) null,
	 contraindications varchar2(512) null,
	 primary key (DIN)); 

create table Over_the_counter_drug 
	(DIN int not null,
	 brand varchar2(32) null,
	 cost varchar2(16) null,
	 quantity int null,
	 primary key (DIN), 
	 foreign key (DIN) references Drug ON DELETE CASCADE
	);

create table Stock_drug
	(DIN int not null,
	 amount_g float(16) null,
	 cost_per_g varchar2(16) null,
	 primary key (DIN), 
	 foreign key (DIN) references Drug ON DELETE CASCADE
	);

create table Item_consistof_drug 
	(item_id char(8) not null,
	 DIN int not null,
	 primary key (item_id, DIN), 
	 foreign key (item_id) references Prescription_item_has (item_id) ON DELETE CASCADE, 
	 foreign key (DIN) references Drug ON DELETE CASCADE
	);

create table Payment_paid_by
 	(paymentId char(8) not null, 
 	customer_id char(8) not null,
 	transdate date not null,
 	total char(10) not null,
 	cardNumber char(12) not null,
 	cardExpDate date not null,
 	time char(5) not null,
 	primary key (paymentId), 
 	foreign key (customer_id) references Customer ON DELETE CASCADE 
 	); 

create table Insurance_coverage
 	(policyId char(8) not null,
	 expDate date null,
 	 maxAllowance int null,
   	 company varchar (40) null,
 	 primary key (policyId)
 	); 

create table Subsidizes
	(paymentId char(8) not null, 
	 policyId char(8) not null, 
 	 primary key (paymentId, policyId), 
 	 foreign key (paymentId) references Payment_paid_by ON DELETE CASCADE, 
 	 foreign key (policyId) references Insurance_coverage ON DELETE CASCADE
	); 

create table Walk_in_Client
	(customer_id char(8) not null, 
 	 primary key (customer_id), 
 	 foreign key (customer_id) references Customer ON DELETE CASCADE
	); 


--------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------------

insert into Employee (emp_id, email, date_of_birth, address, name, phone_number, gender, sin, username, password) values (1, 'rwilliamson0@shutterfly.com', '1984-08-22', '98 Northridge Circle', 'Ryan Williamson', '351-(575)100-8228', 'M', '356265250', 'rwilliamson0', 'r8IwO11v709');
insert into Employee (emp_id, email, date_of_birth, address, name, phone_number, gender, sin, username, password) values (2, 'ecunningham1@mayoclinic.com', '1977-08-12', '3639 Pond Court', 'Evelyn Cunningham', '56-(259)974-7710', 'F', '500235492', 'ecunningham1', 'bQipQg');
insert into Employee (emp_id, email, date_of_birth, address, name, phone_number, gender, sin, username, password) values (3, 'scampbell2@nifty.com', '1989-04-01', '0844 Esker Terrace', 'Stephanie Campbell', '1-(508)516-9879', 'F', '352897899', 'scampbell2', 'zDhvZLE');
insert into Employee (emp_id, email, date_of_birth, address, name, phone_number, gender, sin, username, password) values (4, 'agibson3@fc2.com', '1966-11-02', '7805 Arizona Plaza', 'Anna Gibson', '81-(573)167-8849', 'F', '300963289', 'agibson3', 'UYfcv0PVRQ');
insert into Employee (emp_id, email, date_of_birth, address, name, phone_number, gender, sin, username, password) values (5, 'ahall4@creativecommons.org', '1970-07-08', '90369 Ronald Regan Way', 'Anne Hall', '7-(899)540-2238', 'F', '502060915', 'ahall4', 'Rz5gTdUXZ');
insert into Employee (emp_id, email, date_of_birth, address, name, phone_number, gender, sin, username, password) values (6, 'dwillis5@hao123.com', '1958-03-10', '3441 Dexter Park', 'Doris Willis', '62-(749)173-8414', 'F', '560221657', 'dwillis5', 'oethNuw');
insert into Employee (emp_id, email, date_of_birth, address, name, phone_number, gender, sin, username, password) values (7, 'jbailey6@i2i.jp', '1989-03-29', '954 Hoard Street', 'Juan Bailey', '1-(770)606-6941', 'M', '342827872', 'jbailey6', 'bpXlTg1');
insert into Employee (emp_id, email, date_of_birth, address, name, phone_number, gender, sin, username, password) values (8, 'mfoster7@washingtonpost.com', '1960-01-06', '85 Oneill Center', 'Marie Foster', '86-(820)368-6765', 'F', '354987230', 'mfoster7', '9KQPDK');
insert into Employee (emp_id, email, date_of_birth, address, name, phone_number, gender, sin, username, password) values (9, 'asnyder8@biblegateway.com', '1975-01-01', '61776 Meadow Vale Alley', 'Arthur Snyder', '358-(266)565-8631', 'M', '352963008', 'asnyder8', 'QLkXJnizO');
insert into Employee (emp_id, email, date_of_birth, address, name, phone_number, gender, sin, username, password) values (10, 'jprice9@com.com', '1988-08-19', '907 Ridge Oak Pass', 'Jack Price', '86-(923)917-1600', 'M', '357043487', 'jprice9', 'QTh4DZ');
insert into Employee (emp_id, email, date_of_birth, address, name, phone_number, gender, sin, username, password) values (11, 'trogersa@msn.com', '1959-07-11', '46347 Monica Pass', 'Tina Rogers', '86-(587)223-2049', 'F', '364485398', 'trogersa', 'VDHmVQOT');
insert into Employee (emp_id, email, date_of_birth, address, name, phone_number, gender, sin, username, password) values (12, 'chunterb@house.gov', '1990-12-13', '14 Troy Way', 'Chris Hunter', '66-(538)122-7569', 'M', '355629687', 'chunterb', 'BUOCoRx');
insert into Employee (emp_id, email, date_of_birth, address, name, phone_number, gender, sin, username, password) values (13, 'bmartinezc@ycombinator.com', '1992-06-28', '55 Granby Crossing', 'Billy Martinez', '51-(557)421-6811', 'M', '356388272', 'bmartinezc', 'HdAt95lxdU');
insert into Employee (emp_id, email, date_of_birth, address, name, phone_number, gender, sin, username, password) values (14, 'acooperd@ucla.edu', '1962-11-06', '2 Sage Plaza', 'Arthur Cooper', '62-(931)473-0452', 'M', '450871781', 'acooperd', 'Sbyo2c');
insert into Employee (emp_id, email, date_of_birth, address, name, phone_number, gender, sin, username, password) values (15, 'bfoxe@oakley.com', '1985-04-01', '5 Loeprich Park', 'Bruce Fox', '33-(858)546-5434', 'M', '356465602', 'bfoxe', 'QyPZ0P');
insert into Employee (emp_id, email, date_of_birth, address, name, phone_number, gender, sin, username, password) values (16, 'jmedinaf@stanford.edu', '1969-08-16', '3 Dovetail Alley', 'Justin Medina', '51-(961)258-6470', 'M', '372301282', 'jmedinaf', 'MBAV9PdVkP');
insert into Employee (emp_id, email, date_of_birth, address, name, phone_number, gender, sin, username, password) values (17, 'jrossg@umn.edu', '1971-04-17', '6 6th Parkway', 'Janice Ross', '63-(663)607-8980', 'F', '670607261', 'jrossg', 'P0BBoRYOj2n');
insert into Employee (emp_id, email, date_of_birth, address, name, phone_number, gender, sin, username, password) values (18, 'mmartinezh@drupal.org', '1974-08-10', '91388 Thackeray Parkway', 'Margaret Martinez', '86-(602)223-4297', 'F', '493653355', 'mmartinezh', 'WobrnLdfjm');
insert into Employee (emp_id, email, date_of_birth, address, name, phone_number, gender, sin, username, password) values (19, 'rlanei@goodreads.com', '1985-12-04', '5636 David Crossing', 'Ruth Lane', '62-(854)711-6562', 'F', '440556591', 'rlanei', 'jpFD8v');
insert into Employee (emp_id, email, date_of_birth, address, name, phone_number, gender, sin, username, password) values (20, 'jhowardj@t.co', '1961-01-26', '5 Jana Trail', 'James Howard', '686-(947)832-7391', 'M', '358036426', 'jhowardj', '1NdK4AT');
insert into Employee (emp_id, email, date_of_birth, address, name, phone_number, gender, sin, username, password) values (21, 'hmoorek@google.cn', '1986-01-02', '69 Saint Paul Drive', 'Heather Moore', '62-(419)566-7963', 'F', '502044108', 'hmoorek', 'ArS4bbzut');
insert into Employee (emp_id, email, date_of_birth, address, name, phone_number, gender, sin, username, password) values (22, 'fkingl@addtoany.com', '1961-06-23', '24 Arkansas Road', 'Frank King', '258-(356)542-6076', 'M', '404159098', 'fkingl', 'Ve9rmV72yhg');
insert into Employee (emp_id, email, date_of_birth, address, name, phone_number, gender, sin, username, password) values (23, 'jwatsonm@artisteer.com', '1990-02-05', '11 Michigan Road', 'Judy Watson', '221-(743)641-8149', 'F', '366451339', 'jwatsonm', 'n9oa5z');
insert into Employee (emp_id, email, date_of_birth, address, name, phone_number, gender, sin, username, password) values (24, 'lhuntn@clickbank.net', '1976-04-18', '02 Larry Avenue', 'Lillian Hunt', '255-(398)879-8714', 'F', '201602860', 'lhuntn', 'WorY0YG');
insert into Employee (emp_id, email, date_of_birth, address, name, phone_number, gender, sin, username, password) values (25, 'jperkinso@etsy.com', '1964-05-10', '11 Stoughton Hill', 'Jimmy Perkins', '84-(485)716-7407', 'M', '354460588', 'jperkinso', '7ecqoE9Yv');
insert into Employee (emp_id, email, date_of_birth, address, name, phone_number, gender, sin, username, password) values (26, 'kcolemanp@opera.com', '1967-08-14', '7244 Del Mar Road', 'Kathleen Coleman', '63-(517)173-9460', 'F', '201540903', 'kcolemanp', 'rZEddlxa');
insert into Employee (emp_id, email, date_of_birth, address, name, phone_number, gender, sin, username, password) values (27, 'gstephensq@oakley.com', '1979-08-26', '72770 Kingsford Alley', 'Gerald Stephens', '48-(607)188-8793', 'M', '633437569', 'gstephensq', 'zszBl60A');
insert into Employee (emp_id, email, date_of_birth, address, name, phone_number, gender, sin, username, password) values (28, 'sburker@usda.gov', '1987-09-23', '5292 Anzinger Court', 'Sharon Burke', '30-(267)968-0659', 'F', '357307775', 'sburker', 'Wkg9Zin2');
insert into Employee (emp_id, email, date_of_birth, address, name, phone_number, gender, sin, username, password) values (29, 'rmitchells@lycos.com', '1985-02-16', '63 Surrey Way', 'Ralph Mitchell', '93-(438)831-6785', 'M', '491756416', 'rmitchells', 'FUa3CymhBqeN');
insert into Employee (emp_id, email, date_of_birth, address, name, phone_number, gender, sin, username, password) values (30, 'rmcdonaldt@sbwire.com', '1993-08-14', '8057 Florence Avenue', 'Rose Mcdonald', '7-(426)857-0279', 'F', '491345738', 'rmcdonaldt', 'iBQrFQTPM0b');
insert into Employee (emp_id, email, date_of_birth, address, name, phone_number, gender, sin, username, password) values (31, 'gberryu@spiegel.de', '1985-05-14', '14 Moulton Drive', 'George Berry', '55-(105)132-4069', 'M', '354104033', 'gberryu', '6MqS8ScIPf');
insert into Employee (emp_id, email, date_of_birth, address, name, phone_number, gender, sin, username, password) values (32, 'bjacksonv@disqus.com', '1983-05-20', '4 Thackeray Point', 'Bobby Jackson', '81-(679)597-3868', 'M', '356952388', 'bjacksonv', 'w8k1ns8');
insert into Employee (emp_id, email, date_of_birth, address, name, phone_number, gender, sin, username, password) values (33, 'smillsw@spotify.com', '1961-12-06', '5234 Hooker Circle', 'Sharon Mills', '86-(433)415-7449', 'F', '633351848', 'smillsw', 'vcxLvaakL');
insert into Employee (emp_id, email, date_of_birth, address, name, phone_number, gender, sin, username, password) values (34, 'adiazx@xinhuanet.com', '1967-01-25', '2 Grim Alley', 'Ann Diaz', '507-(406)686-5846', 'F', '455512837', 'adiazx', 'CL0NWvoAqfAE');
insert into Employee (emp_id, email, date_of_birth, address, name, phone_number, gender, sin, username, password) values (35, 'smarshally@miibeian.gov.cn', '1967-08-14', '89 Morrow Court', 'Stephanie Marshall', '46-(116)797-8256', 'F', '354716122', 'smarshally', 'RQsHK7xxzS');
insert into Employee (emp_id, email, date_of_birth, address, name, phone_number, gender, sin, username, password) values (36, 'callenz@unesco.org', '1992-10-31', '589 Summer Ridge Alley', 'Carl Allen', '62-(693)755-6631', 'M', '463678802', 'callenz', 'WOhrfDWBhiu');
insert into Employee (emp_id, email, date_of_birth, address, name, phone_number, gender, sin, username, password) values (37, 'jhicks10@about.com', '1979-07-07', '38 Loeprich Circle', 'Jason Hicks', '52-(309)621-4775', 'M', '355429863', 'jhicks10', 'Pw0QQjXZl');
insert into Employee (emp_id, email, date_of_birth, address, name, phone_number, gender, sin, username, password) values (38, 'sreynolds11@jalbum.net', '1967-11-22', '4690 Crest Line Trail', 'Steven Reynolds', '92-(590)175-1605', 'M', '639351224', 'sreynolds11', 'epgnScWJ6g9C');
insert into Employee (emp_id, email, date_of_birth, address, name, phone_number, gender, sin, username, password) values (39, 'egreene12@bloomberg.com', '1978-06-17', '16551 Troy Center', 'Evelyn Greene', '263-(405)955-2637', 'F', '490348476', 'egreene12', 'kJsj3tfOIAEn');
insert into Employee (emp_id, email, date_of_birth, address, name, phone_number, gender, sin, username, password) values (40, 'shenry13@princeton.edu', '1965-12-11', '65171 Bartillon Plaza', 'Sara Henry', '593-(714)904-2773', 'F', '352888191', 'shenry13', 'IbOISxR');
insert into Employee (emp_id, email, date_of_birth, address, name, phone_number, gender, sin, username, password) values (41, 'lmcdonald14@google.com.hk', '1962-08-29', '63 Susan Trail', 'Lori Mcdonald', '81-(542)699-8604', 'F', '491136429', 'lmcdonald14', 'jTMQMH5sl5');
insert into Employee (emp_id, email, date_of_birth, address, name, phone_number, gender, sin, username, password) values (42, 'pjacobs15@bluehost.com', '1995-05-01', '64524 Rowland Crossing', 'Paula Jacobs', '234-(700)146-0970', 'F', '361819558', 'pjacobs15', 'N3o5c5dJbt7');
insert into Employee (emp_id, email, date_of_birth, address, name, phone_number, gender, sin, username, password) values (43, 'sgarrett16@uol.com.br', '1984-10-29', '8 Sundown Lane', 'Stephen Garrett', '86-(814)357-2826', 'M', '357466154', 'sgarrett16', 'gGRNi04m');
insert into Employee (emp_id, email, date_of_birth, address, name, phone_number, gender, sin, username, password) values (44, 'ajackson17@163.com', '1969-06-27', '1 Victoria Lane', 'Amy Jackson', '268-(788)850-7299', 'F', '355380031', 'ajackson17', 'rUfwrzM');
insert into Employee (emp_id, email, date_of_birth, address, name, phone_number, gender, sin, username, password) values (45, 'lhunter18@prlog.org', '1972-12-03', '38017 Fulton Avenue', 'Lisa Hunter', '223-(461)698-0095', 'F', '417500665', 'lhunter18', 'Ii1eCO6Qunh8');
insert into Employee (emp_id, email, date_of_birth, address, name, phone_number, gender, sin, username, password) values (46, 'aburns19@tumblr.com', '1959-11-13', '3869 Elka Point', 'Alice Burns', '86-(810)882-8184', 'F', '353398143', 'aburns19', '4ylRmVJ');
insert into Employee (emp_id, email, date_of_birth, address, name, phone_number, gender, sin, username, password) values (47, 'lhudson1a@sciencedirect.com', '1989-09-11', '570 West Circle', 'Lillian Hudson', '52-(688)758-2347', 'F', '353994473', 'lhudson1a', 'Z53UIVvN');
insert into Employee (emp_id, email, date_of_birth, address, name, phone_number, gender, sin, username, password) values (48, 'jlawrence1b@mozilla.com', '1962-04-08', '824 Wayridge Parkway', 'Jimmy Lawrence', '62-(674)923-6196', 'M', '633358015', 'jlawrence1b', '7J9xMJ4PNwtR');
insert into Employee (emp_id, email, date_of_birth, address, name, phone_number, gender, sin, username, password) values (49, 'agordon1c@netscape.com', '1975-04-22', '2 Eastlawn Junction', 'Adam Gordon', '31-(522)316-0655', 'M', '354141065', 'agordon1c', 'Ruz1BPtx');
insert into Employee (emp_id, email, date_of_birth, address, name, phone_number, gender, sin, username, password) values (50, 'bhamilton1d@scribd.com', '1959-12-11', '9905 Oneill Way', 'Benjamin Hamilton', '421-(605)577-6245', 'M', '355086970', 'bhamilton1d', 'mwpelS56dD');
insert into Employee (emp_id, email, date_of_birth, address, name, phone_number, gender, sin, username, password) values (51, 'wfuller1e@instagram.com', '1985-08-03', '1975 Jana Hill', 'Walter Fuller', '269-(735)843-5466', 'M', '675913742', 'wfuller1e', 'phGTI5u28j');
insert into Employee (emp_id, email, date_of_birth, address, name, phone_number, gender, sin, username, password) values (52, 'khughes1f@unblog.fr', '1970-10-16', '536 Waxwing Hill', 'Kenneth Hughes', '381-(274)904-5651', 'M', '356091114', 'khughes1f', 'EGoRYfBPX0SB');
insert into Employee (emp_id, email, date_of_birth, address, name, phone_number, gender, sin, username, password) values (53, 'jgreen1g@jigsy.com', '1991-01-14', '8 Karstens Avenue', 'Janet Green', '20-(517)917-2908', 'F', '354534967', 'jgreen1g', 'E87bzq');
insert into Employee (emp_id, email, date_of_birth, address, name, phone_number, gender, sin, username, password) values (54, 'rhughes1h@smugmug.com', '1977-01-23', '1 1st Pass', 'Russell Hughes', '687-(721)556-9981', 'M', '305287851', 'rhughes1h', 'I6v0Cc7Xvo');
insert into Employee (emp_id, email, date_of_birth, address, name, phone_number, gender, sin, username, password) values (55, 'tmedina1i@scientificamerican.com', '1979-10-19', '85 Briar Crest Trail', 'Teresa Medina', '86-(247)851-0216', 'F', '510875634', 'tmedina1i', 'UuXPnfaE');
insert into Employee (emp_id, email, date_of_birth, address, name, phone_number, gender, sin, username, password) values (56, 'jprice1j@nba.com', '1982-12-15', '0 Pond Center', 'Jane Price', '86-(312)218-8252', 'F', '356666758', 'jprice1j', 'jHVQ0mKuS');
insert into Employee (emp_id, email, date_of_birth, address, name, phone_number, gender, sin, username, password) values (57, 'kgutierrez1k@cnn.com', '1982-12-29', '11 Lunder Lane', 'Kevin Gutierrez', '33-(134)781-9951', 'M', '677117740', 'kgutierrez1k', 'CiXu4a');
insert into Employee (emp_id, email, date_of_birth, address, name, phone_number, gender, sin, username, password) values (58, 'panderson1l@ftc.gov', '1992-11-08', '8 Summerview Way', 'Paul Anderson', '977-(658)185-1679', 'M', '356928766', 'panderson1l', 'tQnhoj');
insert into Employee (emp_id, email, date_of_birth, address, name, phone_number, gender, sin, username, password) values (59, 'rgardner1m@thetimes.co.uk', '1993-08-12', '5 Gateway Point', 'Roger Gardner', '48-(256)523-2462', 'M', '401795209', 'rgardner1m', 'ekFiYLutb');
insert into Employee (emp_id, email, date_of_birth, address, name, phone_number, gender, sin, username, password) values (60, 'lnguyen1n@phpbb.com', '1976-01-28', '38 Bayside Court', 'Linda Nguyen', '55-(838)625-0100', 'F', '361701079', 'lnguyen1n', 'RW0WCdOWW');
insert into Employee (emp_id, email, date_of_birth, address, name, phone_number, gender, sin, username, password) values (61, 'ahawkins1o@tuttocitta.it', '1985-07-21', '9 Shoshone Hill', 'Alice Hawkins', '86-(453)748-1014', 'F', '450811642', 'ahawkins1o', 'Fh0nOB');
insert into Employee (emp_id, email, date_of_birth, address, name, phone_number, gender, sin, username, password) values (62, 'twhite1p@nasa.gov', '1960-05-07', '378 Pankratz Place', 'Terry White', '86-(878)535-7064', 'M', '450811284', 'twhite1p', 't6WolQK65');
insert into Employee (emp_id, email, date_of_birth, address, name, phone_number, gender, sin, username, password) values (63, 'aryan1q@g.co', '1992-09-09', '574 Shelley Trail', 'Antonio Ryan', '7-(343)570-9030', 'M', '466556487', 'aryan1q', 'HygYDfF');
insert into Employee (emp_id, email, date_of_birth, address, name, phone_number, gender, sin, username, password) values (64, 'dwilson1r@eventbrite.com', '1962-06-05', '57 Hintze Lane', 'Donald Wilson', '86-(258)277-1593', 'M', '676262496', 'dwilson1r', 'zLECWC');

insert into Pharmacy_Assistant values (1);

insert into Pharmacist values (2, 'Westland Insurance', '00000000');
insert into Pharmacist values (3, 'Eastland Insurance', '00000001');

insert into Pharmacy_Technician values (4, '00000002');
insert into Pharmacy_Technician values (5, '00000003');

insert into Pharmacy_managed (store_id, emp_id, address, name, phone_number) values (1, 3, '5 Eagle Crest Park', 'Boyle, Mitchell and Lynch', '86-(616)156-6771');
insert into Pharmacy_managed (store_id, emp_id, address, name, phone_number) values (2, 6, '6803 Portage Center', 'Schmidt and Sons', '60-(904)278-2579');
insert into Pharmacy_managed (store_id, emp_id, address, name, phone_number) values (3, 9, '270 Graedel Drive', 'Muller and Sons', '62-(791)338-5236');
insert into Pharmacy_managed (store_id, emp_id, address, name, phone_number) values (4, 12, '4036 Longview Street', 'Altenwerth-Jaskolski', '48-(591)914-3482');
insert into Pharmacy_managed (store_id, emp_id, address, name, phone_number) values (5, 15, '142 Clarendon Place', 'Larkin, Tremblay and Gislason', '972-(416)202-1722');
insert into Pharmacy_managed (store_id, emp_id, address, name, phone_number) values (6, 18, '99344 Lakewood Crossing', 'Davis, Daniel and Davis', '63-(781)616-8390');
insert into Pharmacy_managed (store_id, emp_id, address, name, phone_number) values (7, 21, '64789 Jay Parkway', 'Nienow-Kessler', '57-(154)834-0106');
insert into Pharmacy_managed (store_id, emp_id, address, name, phone_number) values (8, 24, '4134 Thompson Crossing', 'Towne-Upton', '51-(138)186-9980');
insert into Pharmacy_managed (store_id, emp_id, address, name, phone_number) values (9, 27, '815 Southridge Lane', 'Reilly, Schulist and Padberg', '86-(889)805-7821');
insert into Pharmacy_managed (store_id, emp_id, address, name, phone_number) values (10, 30, '962 Dwight Avenue', 'Borer LLC', '359-(751)761-7881');

insert into Doctor (doctor_id, phone_number, name) values (1, '420-(551)118-3438', 'Dr. Earl Myers');
insert into Doctor (doctor_id, phone_number, name) values (2, '86-(670)500-6063', 'Dr. John Carr');
insert into Doctor (doctor_id, phone_number, name) values (3, '216-(399)229-3176', 'Dr. Andrew Hudson');
insert into Doctor (doctor_id, phone_number, name) values (4, '30-(636)316-4597', 'Dr. Jonathan Medina');
insert into Doctor (doctor_id, phone_number, name) values (5, '86-(512)534-2157', 'Dr. Frank Robinson');
insert into Doctor (doctor_id, phone_number, name) values (6, '7-(315)408-7400', 'Dr. Christine Davis');
insert into Doctor (doctor_id, phone_number, name) values (7, '598-(919)917-9778', 'Dr. Gregory Henry');
insert into Doctor (doctor_id, phone_number, name) values (8, '48-(674)105-4685', 'Dr. Clarence Dunn');
insert into Doctor (doctor_id, phone_number, name) values (9, '47-(972)989-4515', 'Dr. Stephanie Lawrence');
insert into Doctor (doctor_id, phone_number, name) values (10, '7-(238)240-7374', 'Dr. Judith Fisher');
insert into Doctor (doctor_id, phone_number, name) values (11, '62-(276)618-7753', 'Dr. Henry Young');
insert into Doctor (doctor_id, phone_number, name) values (12, '55-(275)556-0303', 'Dr. Carlos Anderson');
insert into Doctor (doctor_id, phone_number, name) values (13, '55-(259)603-0640', 'Dr. Jennifer Graham');
insert into Doctor (doctor_id, phone_number, name) values (14, '60-(232)642-0445', 'Dr. Frances Wheeler');
insert into Doctor (doctor_id, phone_number, name) values (15, '7-(169)377-5573', 'Dr. David Snyder');
insert into Doctor (doctor_id, phone_number, name) values (16, '234-(848)956-6570', 'Dr. Barbara Johnston');
insert into Doctor (doctor_id, phone_number, name) values (17, '39-(454)687-3125', 'Dr. Julia Sanchez');
insert into Doctor (doctor_id, phone_number, name) values (18, '55-(535)395-3986', 'Dr. Donna Lewis');
insert into Doctor (doctor_id, phone_number, name) values (19, '62-(187)666-9045', 'Dr. Julie Morgan');
insert into Doctor (doctor_id, phone_number, name) values (20, '86-(884)291-7131', 'Dr. Ruth Cole');
insert into Doctor (doctor_id, phone_number, name) values (21, '62-(451)936-0769', 'Dr. Maria Burke');
insert into Doctor (doctor_id, phone_number, name) values (22, '86-(164)288-1242', 'Dr. John Lawrence');
insert into Doctor (doctor_id, phone_number, name) values (23, '48-(371)684-0196', 'Dr. Mildred Stanley');
insert into Doctor (doctor_id, phone_number, name) values (24, '54-(625)198-9732', 'Dr. Frances Nguyen');
insert into Doctor (doctor_id, phone_number, name) values (25, '48-(617)324-7182', 'Dr. John Brown');
insert into Doctor (doctor_id, phone_number, name) values (26, '380-(695)517-4806', 'Dr. Ann Dunn');
insert into Doctor (doctor_id, phone_number, name) values (27, '509-(235)307-1786', 'Dr. Gloria Evans');
insert into Doctor (doctor_id, phone_number, name) values (28, '86-(624)143-0324', 'Dr. Johnny Ortiz');
insert into Doctor (doctor_id, phone_number, name) values (29, '33-(304)952-2368', 'Dr. Christina Martin');
insert into Doctor (doctor_id, phone_number, name) values (30, '47-(915)758-2797', 'Dr. Jose Green');
insert into Doctor (doctor_id, phone_number, name) values (31, '269-(393)997-4413', 'Dr. Charles Morris');
insert into Doctor (doctor_id, phone_number, name) values (32, '63-(464)764-0419', 'Dr. Brandon Bryant');

insert into Customer values ('00000000', 'Harry Potter', '7781129876', 'Westland Insurance');
insert into Customer values ('00000001', 'Pikachu Chu', '6045525673', 'Westland Insurance');
insert into Customer values ('00000002', 'Angelina Jolie', '6042346754', 'Blue Cross');
insert into Customer values ('00000003', 'Ken Bone', '7783324326', 'Eastland Insurance');
insert into Customer values ('00000004', 'Oprah Winfrey', '6048320986', 'Blue Cross');

insert into Patient values ('00000000', '9123456798342343', '22B Baker Street', '1954-01-29', 'F');
insert into Patient values ('00000001', '9100567832130097', '1766 Willow St.', '1975-06-04', 'F');
insert into Patient values ('00000002', '9322998812344631', '567 Evergreen Ave.', '1980-07-31', 'M');

insert into Prescription_by_is_for values ('00000000', 1, '00000000', '00000000', '2016-10-16');
insert into Prescription_by_is_for values ('00000001', 1, '00000001', '00000001', '2016-10-16');
insert into Prescription_by_is_for values ('00000002', 2, '00000002', '00000002', '2016-10-16');
insert into Prescription_by_is_for values ('00000003', 2, '00000002', '00000003', '2016-10-16');
insert into Prescription_by_is_for values ('00000004', 2, '00000000', '00000004', '2016-10-16');

insert into Prescription_item_has values ('00000000', '00000000', '20 mg', '3 weeks', '1 capsule QID');
insert into Prescription_item_has values ('00000001', '00000000', '80 mg', '2 weeks', '3 pills QD');
insert into Prescription_item_has values ('00000002', '00000000', '100 mg', '2 weeks', '2 capsules TID');
insert into Prescription_item_has values ('00000003', '00000001', '15 mg', '5 days', '1 pill every 3 hours');
insert into Prescription_item_has values ('00000004', '00000001', '180 mg', '5 days', '2 tablets every 8 hours');

insert into Pharmacy_record_has values ('0000000000', '9123456798342343', 'Patient is up to date with all medication');
insert into Pharmacy_record_has values ('0000000001', '9100567832130097', 'Patient switched brand of birth control');
insert into Pharmacy_record_has values ('0000000002', '9322998812344631', 'Patient is up to date with all medication');

insert into Service_provides values ('00000000', 2);
insert into Service_provides values ('00000001', 3);
insert into Service_provides values ('00000002', 2);
insert into Service_provides values ('00000003', 3);
insert into Service_provides values ('00000004', 3);

insert into Vaccination values ('00000000', '10000000', '2016-02-23', '3ml');
insert into Vaccination values ('00000001', '20000000', '2015-12-03', '2ml'); 
insert into Vaccination values ('00000002', '30000000', '2016-06-03', '1ml');

insert into Drug (DIN, drug_name_INN, drug_name_trade, drug_description, contraindications) values (1, 'Dimethicone', 'Photocil', 'Vestibulum ac est lacinia nisi venenatis tristique. Fusce congue, diam id ornare imperdiet, sapien urna pretium nisl, ut volutpat sapien arcu sed augue. Aliquam erat volutpat.', 'Praesent blandit. Nam nulla. Integer pede justo, lacinia eget, tincidunt eget, tempus vel, pede.');
insert into Drug (DIN, drug_name_INN, drug_name_trade, drug_description, contraindications) values (2, 'Eucalyptol, menthol, methyl salicylate, thymol', 'Tartar control plus', 'Quisque id justo sit amet sapien dignissim vestibulum. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Nulla dapibus dolor vel est. Donec odio justo, sollicitudin ut, suscipit a, feugiat et, eros.', 'Nam ultrices, libero non mattis pulvinar, nulla pede ullamcorper augue, a suscipit nulla elit ac nulla. Sed vel enim sit amet nunc viverra dapibus. Nulla suscipit ligula in lacus.');
insert into Drug (DIN, drug_name_INN, drug_name_trade, drug_description, contraindications) values (3, 'nystatin', 'Nystatin', 'Nam ultrices, libero non mattis pulvinar, nulla pede ullamcorper augue, a suscipit nulla elit ac nulla. Sed vel enim sit amet nunc viverra dapibus. Nulla suscipit ligula in lacus.', 'Integer ac leo. Pellentesque ultrices mattis odio. Donec vitae nisi.');
insert into Drug (DIN, drug_name_INN, drug_name_trade, drug_description, contraindications) values (4, 'lanthanum carbonate', 'Fosrenol', 'Curabitur gravida nisi at nibh. In hac habitasse platea dictumst. Aliquam augue quam, sollicitudin vitae, consectetuer eget, rutrum at, lorem.', 'Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Proin risus. Praesent lectus.');
insert into Drug (DIN, drug_name_INN, drug_name_trade, drug_description, contraindications) values (5, 'Mesalamine', 'Pentasa', 'Fusce posuere felis sed lacus. Morbi sem mauris, laoreet ut, rhoncus aliquet, pulvinar sed, nisl. Nunc rhoncus dui vel sem.', 'Morbi porttitor lorem id ligula. Suspendisse ornare consequat lectus. In est risus, auctor sed, tristique in, tempus sit amet, sem.');
insert into Drug (DIN, drug_name_INN, drug_name_trade, drug_description, contraindications) values (6, 'OCTINOXATE', 'flormar Concealer Sunscreen Broad Spectrum SPF 20 LC01 PURE BEIGE', 'Nullam porttitor lacus at turpis. Donec posuere metus vitae ipsum. Aliquam non mauris.', 'Integer ac leo. Pellentesque ultrices mattis odio. Donec vitae nisi.');
insert into Drug (DIN, drug_name_INN, drug_name_trade, drug_description, contraindications) values (7, 'Omeprazole', 'Omeprazole', 'Duis aliquam convallis nunc. Proin at turpis a pede posuere nonummy. Integer non velit.', 'Duis consequat dui nec nisi volutpat eleifend. Donec ut dolor. Morbi vel lectus in quam fringilla rhoncus.');
insert into Drug (DIN, drug_name_INN, drug_name_trade, drug_description, contraindications) values (8, 'Paroxetine', 'Paroxetine', 'Sed ante. Vivamus tortor. Duis mattis egestas metus.', 'Donec diam neque, vestibulum eget, vulputate ut, ultrices vel, augue. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Donec pharetra, magna vestibulum aliquet ultrices, erat tortor sollicitudin mi, sit amet lobortis sapien sapien non mi. Integer ac neque.');
insert into Drug (DIN, drug_name_INN, drug_name_trade, drug_description, contraindications) values (9, 'CHLORHEXIDINE GLUCONATE and HYDROGEN PEROXIDE', 'Oral Cleansing and Suctioning System, q2', 'Fusce posuere felis sed lacus. Morbi sem mauris, laoreet ut, rhoncus aliquet, pulvinar sed, nisl. Nunc rhoncus dui vel sem.', 'Integer ac leo. Pellentesque ultrices mattis odio. Donec vitae nisi.');
insert into Drug (DIN, drug_name_INN, drug_name_trade, drug_description, contraindications) values (10, 'METFORMIN HYDROCHLORIDE', 'METFORMIN HYDROCHLORIDE', 'Aenean fermentum. Donec ut mauris eget massa tempor convallis. Nulla neque libero, convallis eget, eleifend luctus, ultricies eu, nibh.', 'Aenean lectus. Pellentesque eget nunc. Donec quis orci eget orci vehicula condimentum.');
insert into Drug (DIN, drug_name_INN, drug_name_trade, drug_description, contraindications) values (11, 'loratadine', 'LEADER Loratadine', 'Fusce consequat. Nulla nisl. Nunc nisl.', 'Cras non velit nec nisi vulputate nonummy. Maecenas tincidunt lacus at velit. Vivamus vel nulla eget eros elementum pellentesque.');
insert into Drug (DIN, drug_name_INN, drug_name_trade, drug_description, contraindications) values (12, 'loratadine', 'allergy relief medication', 'Cras non velit nec nisi vulputate nonummy. Maecenas tincidunt lacus at velit. Vivamus vel nulla eget eros elementum pellentesque.', 'Mauris enim leo, rhoncus sed, vestibulum sit amet, cursus id, turpis. Integer aliquet, massa id lobortis convallis, tortor risus dapibus augue, vel accumsan tellus nisi eu orci. Mauris lacinia sapien quis libero.');
insert into Drug (DIN, drug_name_INN, drug_name_trade, drug_description, contraindications) values (13, 'Tramadol Hydrochloride', 'Tramadol Hydrochloride', 'In hac habitasse platea dictumst. Etiam faucibus cursus urna. Ut tellus.', 'Curabitur at ipsum ac tellus semper interdum. Mauris ullamcorper purus sit amet nulla. Quisque arcu libero, rutrum ac, lobortis vel, dapibus at, diam.');
insert into Drug (DIN, drug_name_INN, drug_name_trade, drug_description, contraindications) values (14, 'Benzocaine and Menthol', 'Cepacol', 'Suspendisse potenti. In eleifend quam a odio. In hac habitasse platea dictumst.', 'Phasellus sit amet erat. Nulla tempus. Vivamus in felis eu sapien cursus vestibulum.');
insert into Drug (DIN, drug_name_INN, drug_name_trade, drug_description, contraindications) values (15, 'Ibuprofen', 'Ibuprofen', 'Quisque id justo sit amet sapien dignissim vestibulum. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Nulla dapibus dolor vel est. Donec odio justo, sollicitudin ut, suscipit a, feugiat et, eros.', 'Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Proin risus. Praesent lectus.');
insert into Drug (DIN, drug_name_INN, drug_name_trade, drug_description, contraindications) values (16, 'Cephalexin', 'Cephalexin', 'Quisque porta volutpat erat. Quisque erat eros, viverra eget, congue eget, semper rutrum, nulla. Nunc purus.', 'Aenean fermentum. Donec ut mauris eget massa tempor convallis. Nulla neque libero, convallis eget, eleifend luctus, ultricies eu, nibh.');
insert into Drug (DIN, drug_name_INN, drug_name_trade, drug_description, contraindications) values (17, 'Allium cepa, Amrbosia artemisiifolia, Arsenicum album, Euphrasia officinalis, Galphimia glauca, Histaminum hydrochloricum, Lemna minor, Linum usitatissimum, Luffa operculata, Natrum muriaticum, Polyporus pinicola, Sabadilla', 'Triple Allergy Defense', 'Aenean lectus. Pellentesque eget nunc. Donec quis orci eget orci vehicula condimentum.', 'Morbi porttitor lorem id ligula. Suspendisse ornare consequat lectus. In est risus, auctor sed, tristique in, tempus sit amet, sem.');
insert into Drug (DIN, drug_name_INN, drug_name_trade, drug_description, contraindications) values (18, 'Isopropyl Alcohol', 'Isopropyl Alcohol', 'Etiam vel augue. Vestibulum rutrum rutrum neque. Aenean auctor gravida sem.', 'Quisque porta volutpat erat. Quisque erat eros, viverra eget, congue eget, semper rutrum, nulla. Nunc purus.');
insert into Drug (DIN, drug_name_INN, drug_name_trade, drug_description, contraindications) values (19, 'Diphenhydramine hydrochloride, ibuprofen', 'Ibuprofen PM', 'Duis aliquam convallis nunc. Proin at turpis a pede posuere nonummy. Integer non velit.', 'Curabitur in libero ut massa volutpat convallis. Morbi odio odio, elementum eu, interdum eu, tincidunt in, leo. Maecenas pulvinar lobortis est.');
insert into Drug (DIN, drug_name_INN, drug_name_trade, drug_description, contraindications) values (20, 'adenosine', 'IASO progressive age care', 'Curabitur gravida nisi at nibh. In hac habitasse platea dictumst. Aliquam augue quam, sollicitudin vitae, consectetuer eget, rutrum at, lorem.', 'Proin eu mi. Nulla ac enim. In tempor, turpis nec euismod scelerisque, quam turpis adipiscing lorem, vitae mattis nibh ligula nec sem.');
insert into Drug (DIN, drug_name_INN, drug_name_trade, drug_description, contraindications) values (21, 'DIPHENHYDRAMINE HYDROCHLORIDE, ZINC ACETATE', 'Anti-Itch', 'Nam ultrices, libero non mattis pulvinar, nulla pede ullamcorper augue, a suscipit nulla elit ac nulla. Sed vel enim sit amet nunc viverra dapibus. Nulla suscipit ligula in lacus.', 'In congue. Etiam justo. Etiam pretium iaculis justo.');
insert into Drug (DIN, drug_name_INN, drug_name_trade, drug_description, contraindications) values (22, 'Adenosine Triphosphate(ATP), Coenzyme A, Coenzyme Q10, Pineal gland (suis), Sarcolacticum acidum, Melatonin, Pyrrole, Tryptophan, Arsenicum album, Avena sativa, Chamomilla, Coffea cruda, Mercurius corrosivus,', 'Perfect Sleep', 'Fusce posuere felis sed lacus. Morbi sem mauris, laoreet ut, rhoncus aliquet, pulvinar sed, nisl. Nunc rhoncus dui vel sem.', 'Curabitur in libero ut massa volutpat convallis. Morbi odio odio, elementum eu, interdum eu, tincidunt in, leo. Maecenas pulvinar lobortis est.');
insert into Drug (DIN, drug_name_INN, drug_name_trade, drug_description, contraindications) values (23, 'Hydrocortisone Acetate', 'Cortaid', 'Vestibulum ac est lacinia nisi venenatis tristique. Fusce congue, diam id ornare imperdiet, sapien urna pretium nisl, ut volutpat sapien arcu sed augue. Aliquam erat volutpat.', 'Cras mi pede, malesuada in, imperdiet et, commodo vulputate, justo. In blandit ultrices enim. Lorem ipsum dolor sit amet, consectetuer adipiscing elit.');
insert into Drug (DIN, drug_name_INN, drug_name_trade, drug_description, contraindications) values (24, 'Arnica e pl. tota 3', 'Arnica e pl. tota 3', 'In congue. Etiam justo. Etiam pretium iaculis justo.', 'Quisque id justo sit amet sapien dignissim vestibulum. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Nulla dapibus dolor vel est. Donec odio justo, sollicitudin ut, suscipit a, feugiat et, eros.');
insert into Drug (DIN, drug_name_INN, drug_name_trade, drug_description, contraindications) values (25, 'MORPHINE SULFATE', 'MORPHINE SULFATE', 'Integer tincidunt ante vel ipsum. Praesent blandit lacinia erat. Vestibulum sed magna at nunc commodo placerat.', 'Phasellus sit amet erat. Nulla tempus. Vivamus in felis eu sapien cursus vestibulum.');
insert into Drug (DIN, drug_name_INN, drug_name_trade, drug_description, contraindications) values (26, 'irbesartan and hydrochlorothiazide', 'Avalide', 'Nullam porttitor lacus at turpis. Donec posuere metus vitae ipsum. Aliquam non mauris.', 'Nam ultrices, libero non mattis pulvinar, nulla pede ullamcorper augue, a suscipit nulla elit ac nulla. Sed vel enim sit amet nunc viverra dapibus. Nulla suscipit ligula in lacus.');
insert into Drug (DIN, drug_name_INN, drug_name_trade, drug_description, contraindications) values (27, 'Phentermine Hydrochloride', 'Phentermine Hydrochloride', 'Maecenas tristique, est et tempus semper, est quam pharetra magna, ac consequat metus sapien ut nunc. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Mauris viverra diam vitae quam. Suspendisse potenti.', 'Morbi porttitor lorem id ligula. Suspendisse ornare consequat lectus. In est risus, auctor sed, tristique in, tempus sit amet, sem.');
insert into Drug (DIN, drug_name_INN, drug_name_trade, drug_description, contraindications) values (28, 'ALCOHOL', 'Fresh Up Antiseptic Hand', 'Aliquam quis turpis eget elit sodales scelerisque. Mauris sit amet eros. Suspendisse accumsan tortor quis turpis.', 'Morbi porttitor lorem id ligula. Suspendisse ornare consequat lectus. In est risus, auctor sed, tristique in, tempus sit amet, sem.');
insert into Drug (DIN, drug_name_INN, drug_name_trade, drug_description, contraindications) values (29, 'CLOTRIMAZOLE', 'Dermatin', 'Curabitur in libero ut massa volutpat convallis. Morbi odio odio, elementum eu, interdum eu, tincidunt in, leo. Maecenas pulvinar lobortis est.', 'Proin leo odio, porttitor id, consequat in, consequat ut, nulla. Sed accumsan felis. Ut at dolor quis odio consequat varius.');
insert into Drug (DIN, drug_name_INN, drug_name_trade, drug_description, contraindications) values (30, 'insulin aspart', 'NovoLog Mix 70/30', 'Vestibulum ac est lacinia nisi venenatis tristique. Fusce congue, diam id ornare imperdiet, sapien urna pretium nisl, ut volutpat sapien arcu sed augue. Aliquam erat volutpat.', 'Duis bibendum, felis sed interdum venenatis, turpis enim blandit mi, in porttitor pede justo eu massa. Donec dapibus. Duis at velit eu est congue elementum.');
insert into Drug (DIN, drug_name_INN, drug_name_trade, drug_description, contraindications) values (31, 'Dextromethorphan', 'Delsym', 'Praesent blandit. Nam nulla. Integer pede justo, lacinia eget, tincidunt eget, tempus vel, pede.', 'Nulla ut erat id mauris vulputate elementum. Nullam varius. Nulla facilisi.');
insert into Drug (DIN, drug_name_INN, drug_name_trade, drug_description, contraindications) values (32, 'Camphor', 'Walgreens Cold Sore Treatment', 'Duis aliquam convallis nunc. Proin at turpis a pede posuere nonummy. Integer non velit.', 'Proin eu mi. Nulla ac enim. In tempor, turpis nec euismod scelerisque, quam turpis adipiscing lorem, vitae mattis nibh ligula nec sem.');
insert into Drug (DIN, drug_name_INN, drug_name_trade, drug_description, contraindications) values (33, 'Diphenhydramine hydrochloride', 'Wal-Som', 'Duis bibendum, felis sed interdum venenatis, turpis enim blandit mi, in porttitor pede justo eu massa. Donec dapibus. Duis at velit eu est congue elementum.', 'Praesent blandit. Nam nulla. Integer pede justo, lacinia eget, tincidunt eget, tempus vel, pede.');
insert into Drug (DIN, drug_name_INN, drug_name_trade, drug_description, contraindications) values (34, 'Lisinopril', 'Lisinopril', 'Maecenas tristique, est et tempus semper, est quam pharetra magna, ac consequat metus sapien ut nunc. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Mauris viverra diam vitae quam. Suspendisse potenti.', 'Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Vivamus vestibulum sagittis sapien. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus.');
insert into Drug (DIN, drug_name_INN, drug_name_trade, drug_description, contraindications) values (35, 'docusate sodium', 'Colace', 'Duis bibendum, felis sed interdum venenatis, turpis enim blandit mi, in porttitor pede justo eu massa. Donec dapibus. Duis at velit eu est congue elementum.', 'In hac habitasse platea dictumst. Morbi vestibulum, velit id pretium iaculis, diam erat fermentum justo, nec condimentum neque sapien placerat ante. Nulla justo.');
insert into Drug (DIN, drug_name_INN, drug_name_trade, drug_description, contraindications) values (36, 'Sertraline', 'SERTRALINE', 'Maecenas ut massa quis augue luctus tincidunt. Nulla mollis molestie lorem. Quisque ut erat.', 'Duis bibendum. Morbi non quam nec dui luctus rutrum. Nulla tellus.');
insert into Drug (DIN, drug_name_INN, drug_name_trade, drug_description, contraindications) values (37, 'OCTINOXATE, TITANIUM DIOXIDE', 'Lumene Time Freeze Anti-Age CC Color Correcting SPF 20 Sunscreen Broad Spectrum MEDIUM', 'Duis bibendum. Morbi non quam nec dui luctus rutrum. Nulla tellus.', 'Etiam vel augue. Vestibulum rutrum rutrum neque. Aenean auctor gravida sem.');
insert into Drug (DIN, drug_name_INN, drug_name_trade, drug_description, contraindications) values (38, 'Acetaminophen', 'good neighbor pharmacy pain relief', 'Duis consequat dui nec nisi volutpat eleifend. Donec ut dolor. Morbi vel lectus in quam fringilla rhoncus.', 'Praesent blandit. Nam nulla. Integer pede justo, lacinia eget, tincidunt eget, tempus vel, pede.');
insert into Drug (DIN, drug_name_INN, drug_name_trade, drug_description, contraindications) values (39, 'Calcium Gluconate', 'Calcium Gluconate', 'Sed ante. Vivamus tortor. Duis mattis egestas metus.', 'Aenean fermentum. Donec ut mauris eget massa tempor convallis. Nulla neque libero, convallis eget, eleifend luctus, ultricies eu, nibh.');
insert into Drug (DIN, drug_name_INN, drug_name_trade, drug_description, contraindications) values (40, 'Candesartan cilexetil', 'Candesartan cilexetil', 'Phasellus sit amet erat. Nulla tempus. Vivamus in felis eu sapien cursus vestibulum.', 'Fusce posuere felis sed lacus. Morbi sem mauris, laoreet ut, rhoncus aliquet, pulvinar sed, nisl. Nunc rhoncus dui vel sem.');
insert into Drug (DIN, drug_name_INN, drug_name_trade, drug_description, contraindications) values (41, 'Levothyroxine Sodium', 'Levothyroxine Sodium', 'Quisque porta volutpat erat. Quisque erat eros, viverra eget, congue eget, semper rutrum, nulla. Nunc purus.', 'Sed ante. Vivamus tortor. Duis mattis egestas metus.');
insert into Drug (DIN, drug_name_INN, drug_name_trade, drug_description, contraindications) values (42, 'BISMUTH SUBSALICYLATE', 'Peptic Relief', 'In quis justo. Maecenas rhoncus aliquam lacus. Morbi quis tortor id nulla ultrices aliquet.', 'Phasellus sit amet erat. Nulla tempus. Vivamus in felis eu sapien cursus vestibulum.');
insert into Drug (DIN, drug_name_INN, drug_name_trade, drug_description, contraindications) values (43, 'Aluminum Zirconium Tetrachlorohydrex GLY', 'Degree', 'Quisque id justo sit amet sapien dignissim vestibulum. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Nulla dapibus dolor vel est. Donec odio justo, sollicitudin ut, suscipit a, feugiat et, eros.', 'Vestibulum ac est lacinia nisi venenatis tristique. Fusce congue, diam id ornare imperdiet, sapien urna pretium nisl, ut volutpat sapien arcu sed augue. Aliquam erat volutpat.');
insert into Drug (DIN, drug_name_INN, drug_name_trade, drug_description, contraindications) values (44, 'ALUMINUM ZIRCONIUM TETRACHLOROHYDREX GLY', 'Ban', 'Duis consequat dui nec nisi volutpat eleifend. Donec ut dolor. Morbi vel lectus in quam fringilla rhoncus.', 'Sed sagittis. Nam congue, risus semper porta volutpat, quam pede lobortis ligula, sit amet eleifend pede libero quis orci. Nullam molestie nibh in lectus.');
insert into Drug (DIN, drug_name_INN, drug_name_trade, drug_description, contraindications) values (45, 'AMOXICILLIN', 'AMOXICILLIN', 'Sed ante. Vivamus tortor. Duis mattis egestas metus.', 'Integer tincidunt ante vel ipsum. Praesent blandit lacinia erat. Vestibulum sed magna at nunc commodo placerat.');
insert into Drug (DIN, drug_name_INN, drug_name_trade, drug_description, contraindications) values (46, 'pioglitazone and metformin hydrochloride', 'Actoplus Met', 'Proin interdum mauris non ligula pellentesque ultrices. Phasellus id sapien in sapien iaculis congue. Vivamus metus arcu, adipiscing molestie, hendrerit at, vulputate vitae, nisl.', 'Phasellus in felis. Donec semper sapien a libero. Nam dui.');
insert into Drug (DIN, drug_name_INN, drug_name_trade, drug_description, contraindications) values (47, 'Nicotine Polacrilex', 'Health Mart nicotine polacrilex', 'Aenean lectus. Pellentesque eget nunc. Donec quis orci eget orci vehicula condimentum.', 'In congue. Etiam justo. Etiam pretium iaculis justo.');
insert into Drug (DIN, drug_name_INN, drug_name_trade, drug_description, contraindications) values (48, 'Neomycin sulfate, Polymyxin B Sulfate and Bacitracin Zinc', 'Triple Antibiotic', 'Vestibulum quam sapien, varius ut, blandit non, interdum in, ante. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Duis faucibus accumsan odio. Curabitur convallis.', 'In quis justo. Maecenas rhoncus aliquam lacus. Morbi quis tortor id nulla ultrices aliquet.');
insert into Drug (DIN, drug_name_INN, drug_name_trade, drug_description, contraindications) values (49, 'HYDROXYZINE PAMOATE', 'Hydroxyzine Pamoate', 'Aenean fermentum. Donec ut mauris eget massa tempor convallis. Nulla neque libero, convallis eget, eleifend luctus, ultricies eu, nibh.', 'Nulla ut erat id mauris vulputate elementum. Nullam varius. Nulla facilisi.');
insert into Drug (DIN, drug_name_INN, drug_name_trade, drug_description, contraindications) values (50, 'Ondansetron Hydrochloride', 'Ondansetron', 'Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Vivamus vestibulum sagittis sapien. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus.', 'In hac habitasse platea dictumst. Morbi vestibulum, velit id pretium iaculis, diam erat fermentum justo, nec condimentum neque sapien placerat ante. Nulla justo.');
insert into Drug (DIN, drug_name_INN, drug_name_trade, drug_description, contraindications) values (51, 'Acetaminophen,Dextromethorphan,Phenylephrine', 'Acetaminophen,Dextromethorphan,Phenylephrine', 'In hac habitasse platea dictumst. Etiam faucibus cursus urna. Ut tellus.', 'Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Vivamus vestibulum sagittis sapien. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus.');
insert into Drug (DIN, drug_name_INN, drug_name_trade, drug_description, contraindications) values (52, 'calcium carbonate', 'TUMS', 'Nulla ut erat id mauris vulputate elementum. Nullam varius. Nulla facilisi.', 'Morbi porttitor lorem id ligula. Suspendisse ornare consequat lectus. In est risus, auctor sed, tristique in, tempus sit amet, sem.');
insert into Drug (DIN, drug_name_INN, drug_name_trade, drug_description, contraindications) values (53, 'Allantoin, Benzethonium Chloride', 'Terrasil Skin Repair', 'Phasellus in felis. Donec semper sapien a libero. Nam dui.', 'Fusce consequat. Nulla nisl. Nunc nisl.');
insert into Drug (DIN, drug_name_INN, drug_name_trade, drug_description, contraindications) values (54, 'Doxazosin', 'Doxazosin', 'Phasellus in felis. Donec semper sapien a libero. Nam dui.', 'Quisque id justo sit amet sapien dignissim vestibulum. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Nulla dapibus dolor vel est. Donec odio justo, sollicitudin ut, suscipit a, feugiat et, eros.');
insert into Drug (DIN, drug_name_INN, drug_name_trade, drug_description, contraindications) values (55, 'Cetirizine Hydrochloride', 'up and up', 'Proin interdum mauris non ligula pellentesque ultrices. Phasellus id sapien in sapien iaculis congue. Vivamus metus arcu, adipiscing molestie, hendrerit at, vulputate vitae, nisl.', 'Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Proin risus. Praesent lectus.');
insert into Drug (DIN, drug_name_INN, drug_name_trade, drug_description, contraindications) values (56, 'sodium phosphate, dibasic and sodium phosphate, monobasic', 'Fleet', 'Maecenas leo odio, condimentum id, luctus nec, molestie sed, justo. Pellentesque viverra pede ac diam. Cras pellentesque volutpat dui.', 'Nullam sit amet turpis elementum ligula vehicula consequat. Morbi a ipsum. Integer a nibh.');
insert into Drug (DIN, drug_name_INN, drug_name_trade, drug_description, contraindications) values (57, 'Sulindac', 'Sulindac', 'Nam ultrices, libero non mattis pulvinar, nulla pede ullamcorper augue, a suscipit nulla elit ac nulla. Sed vel enim sit amet nunc viverra dapibus. Nulla suscipit ligula in lacus.', 'Phasellus in felis. Donec semper sapien a libero. Nam dui.');
insert into Drug (DIN, drug_name_INN, drug_name_trade, drug_description, contraindications) values (58, 'Triclosan', 'Fresh Blueberry Antibacterial Foaming Hand Wash', 'Morbi porttitor lorem id ligula. Suspendisse ornare consequat lectus. In est risus, auctor sed, tristique in, tempus sit amet, sem.', 'Proin eu mi. Nulla ac enim. In tempor, turpis nec euismod scelerisque, quam turpis adipiscing lorem, vitae mattis nibh ligula nec sem.');
insert into Drug (DIN, drug_name_INN, drug_name_trade, drug_description, contraindications) values (59, 'Anti-Dark Moisturizing Cream', 'PONDS', 'Duis consequat dui nec nisi volutpat eleifend. Donec ut dolor. Morbi vel lectus in quam fringilla rhoncus.', 'Cras non velit nec nisi vulputate nonummy. Maecenas tincidunt lacus at velit. Vivamus vel nulla eget eros elementum pellentesque.');
insert into Drug (DIN, drug_name_INN, drug_name_trade, drug_description, contraindications) values (60, 'Tretinoin', 'Tretinoin', 'Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Proin risus. Praesent lectus.', 'Curabitur in libero ut massa volutpat convallis. Morbi odio odio, elementum eu, interdum eu, tincidunt in, leo. Maecenas pulvinar lobortis est.');
insert into Drug (DIN, drug_name_INN, drug_name_trade, drug_description, contraindications) values (61, 'ARNICA MONTANA', 'Arnica 6c', 'Cras non velit nec nisi vulputate nonummy. Maecenas tincidunt lacus at velit. Vivamus vel nulla eget eros elementum pellentesque.', 'Phasellus sit amet erat. Nulla tempus. Vivamus in felis eu sapien cursus vestibulum.');
insert into Drug (DIN, drug_name_INN, drug_name_trade, drug_description, contraindications) values (62, 'Aminophylline', 'Aminophylline', 'Curabitur at ipsum ac tellus semper interdum. Mauris ullamcorper purus sit amet nulla. Quisque arcu libero, rutrum ac, lobortis vel, dapibus at, diam.', 'Maecenas ut massa quis augue luctus tincidunt. Nulla mollis molestie lorem. Quisque ut erat.');
insert into Drug (DIN, drug_name_INN, drug_name_trade, drug_description, contraindications) values (63, 'Citalopram Hydrobromide', 'Citalopram', 'Curabitur at ipsum ac tellus semper interdum. Mauris ullamcorper purus sit amet nulla. Quisque arcu libero, rutrum ac, lobortis vel, dapibus at, diam.', 'Sed sagittis. Nam congue, risus semper porta volutpat, quam pede lobortis ligula, sit amet eleifend pede libero quis orci. Nullam molestie nibh in lectus.');
insert into Drug (DIN, drug_name_INN, drug_name_trade, drug_description, contraindications) values (64, 'Nicotine Polacrilex', 'smart sense nicotine polacrilex', 'Proin eu mi. Nulla ac enim. In tempor, turpis nec euismod scelerisque, quam turpis adipiscing lorem, vitae mattis nibh ligula nec sem.', 'Curabitur at ipsum ac tellus semper interdum. Mauris ullamcorper purus sit amet nulla. Quisque arcu libero, rutrum ac, lobortis vel, dapibus at, diam.');
insert into Drug (DIN, drug_name_INN, drug_name_trade, drug_description, contraindications) values (65, 'Cephalexin', 'Cephalexin', 'Phasellus in felis. Donec semper sapien a libero. Nam dui.', 'In congue. Etiam justo. Etiam pretium iaculis justo.');
insert into Drug (DIN, drug_name_INN, drug_name_trade, drug_description, contraindications) values (66, 'Tadalafil', 'Cialis', 'Nulla ut erat id mauris vulputate elementum. Nullam varius. Nulla facilisi.', 'Duis bibendum. Morbi non quam nec dui luctus rutrum. Nulla tellus.');
insert into Drug (DIN, drug_name_INN, drug_name_trade, drug_description, contraindications) values (67, 'Baryta carbonica, Calcarea carbonica, Calcarea iodata', 'Thyroid', 'Cras mi pede, malesuada in, imperdiet et, commodo vulputate, justo. In blandit ultrices enim. Lorem ipsum dolor sit amet, consectetuer adipiscing elit.', 'Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Vivamus vestibulum sagittis sapien. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus.');
insert into Drug (DIN, drug_name_INN, drug_name_trade, drug_description, contraindications) values (68, 'Menthol', 'Absorbine Jr.', 'Phasellus sit amet erat. Nulla tempus. Vivamus in felis eu sapien cursus vestibulum.', 'In quis justo. Maecenas rhoncus aliquam lacus. Morbi quis tortor id nulla ultrices aliquet.');
insert into Drug (DIN, drug_name_INN, drug_name_trade, drug_description, contraindications) values (69, 'selenium sulfide', 'TERSI', 'Duis consequat dui nec nisi volutpat eleifend. Donec ut dolor. Morbi vel lectus in quam fringilla rhoncus.', 'Integer tincidunt ante vel ipsum. Praesent blandit lacinia erat. Vestibulum sed magna at nunc commodo placerat.');
insert into Drug (DIN, drug_name_INN, drug_name_trade, drug_description, contraindications) values (70, 'AZITHROMYCIN', 'AZITHROMYCIN', 'Quisque porta volutpat erat. Quisque erat eros, viverra eget, congue eget, semper rutrum, nulla. Nunc purus.', 'Vestibulum quam sapien, varius ut, blandit non, interdum in, ante. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Duis faucibus accumsan odio. Curabitur convallis.');
insert into Drug (DIN, drug_name_INN, drug_name_trade, drug_description, contraindications) values (71, 'Ursodiol', 'Ursodiol', 'Fusce consequat. Nulla nisl. Nunc nisl.', 'Maecenas ut massa quis augue luctus tincidunt. Nulla mollis molestie lorem. Quisque ut erat.');
insert into Drug (DIN, drug_name_INN, drug_name_trade, drug_description, contraindications) values (72, 'diclofenac potassium', 'Zipsor', 'Morbi non lectus. Aliquam sit amet diam in magna bibendum imperdiet. Nullam orci pede, venenatis non, sodales sed, tincidunt eu, felis.', 'Aliquam quis turpis eget elit sodales scelerisque. Mauris sit amet eros. Suspendisse accumsan tortor quis turpis.');
insert into Drug (DIN, drug_name_INN, drug_name_trade, drug_description, contraindications) values (73, 'Petrolatum', 'A and D', 'Vestibulum quam sapien, varius ut, blandit non, interdum in, ante. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Duis faucibus accumsan odio. Curabitur convallis.', 'Sed sagittis. Nam congue, risus semper porta volutpat, quam pede lobortis ligula, sit amet eleifend pede libero quis orci. Nullam molestie nibh in lectus.');
insert into Drug (DIN, drug_name_INN, drug_name_trade, drug_description, contraindications) values (74, 'morphine sulfate', 'Kadian', 'Proin eu mi. Nulla ac enim. In tempor, turpis nec euismod scelerisque, quam turpis adipiscing lorem, vitae mattis nibh ligula nec sem.', 'Sed ante. Vivamus tortor. Duis mattis egestas metus.');
insert into Drug (DIN, drug_name_INN, drug_name_trade, drug_description, contraindications) values (75, 'Cetirizine Hydrochloride', 'Cetirizine', 'Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Vivamus vestibulum sagittis sapien. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus.', 'Phasellus in felis. Donec semper sapien a libero. Nam dui.');
insert into Drug (DIN, drug_name_INN, drug_name_trade, drug_description, contraindications) values (76, 'SODIUM FLUORIDE', 'MegaFresh', 'Pellentesque at nulla. Suspendisse potenti. Cras in purus eu magna vulputate luctus.', 'Integer tincidunt ante vel ipsum. Praesent blandit lacinia erat. Vestibulum sed magna at nunc commodo placerat.');
insert into Drug (DIN, drug_name_INN, drug_name_trade, drug_description, contraindications) values (77, 'Calendula officinalis', 'Seven', 'Aenean fermentum. Donec ut mauris eget massa tempor convallis. Nulla neque libero, convallis eget, eleifend luctus, ultricies eu, nibh.', 'Fusce consequat. Nulla nisl. Nunc nisl.');
insert into Drug (DIN, drug_name_INN, drug_name_trade, drug_description, contraindications) values (78, 'Acetaminophen, Chlorpheniramine Maleate, Dextromethorphan Hydrobromide, Phenylephrine Hydrochloride', 'good neighbor pharmacy cold', 'Phasellus sit amet erat. Nulla tempus. Vivamus in felis eu sapien cursus vestibulum.', 'Proin eu mi. Nulla ac enim. In tempor, turpis nec euismod scelerisque, quam turpis adipiscing lorem, vitae mattis nibh ligula nec sem.');
insert into Drug (DIN, drug_name_INN, drug_name_trade, drug_description, contraindications) values (79, 'Octinoxate', 'LOreal Paris True Match Lumi Healthy Luminous Makeup Broad Spectrum SPF 20', 'Nulla ut erat id mauris vulputate elementum. Nullam varius. Nulla facilisi.', 'In sagittis dui vel nisl. Duis ac nibh. Fusce lacus purus, aliquet at, feugiat non, pretium quis, lectus.');
insert into Drug (DIN, drug_name_INN, drug_name_trade, drug_description, contraindications) values (80, 'escitalopram', 'Escitalopram oxalate', 'Quisque id justo sit amet sapien dignissim vestibulum. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Nulla dapibus dolor vel est. Donec odio justo, sollicitudin ut, suscipit a, feugiat et, eros.', 'Nullam sit amet turpis elementum ligula vehicula consequat. Morbi a ipsum. Integer a nibh.');
insert into Drug (DIN, drug_name_INN, drug_name_trade, drug_description, contraindications) values (81, 'California Black Walnut', 'California Black Walnut', 'In hac habitasse platea dictumst. Etiam faucibus cursus urna. Ut tellus.', 'Duis consequat dui nec nisi volutpat eleifend. Donec ut dolor. Morbi vel lectus in quam fringilla rhoncus.');
insert into Drug (DIN, drug_name_INN, drug_name_trade, drug_description, contraindications) values (82, 'Ephedrine Sulfate', 'Ephedrine Sulfate', 'Integer tincidunt ante vel ipsum. Praesent blandit lacinia erat. Vestibulum sed magna at nunc commodo placerat.', 'In hac habitasse platea dictumst. Morbi vestibulum, velit id pretium iaculis, diam erat fermentum justo, nec condimentum neque sapien placerat ante. Nulla justo.');
insert into Drug (DIN, drug_name_INN, drug_name_trade, drug_description, contraindications) values (83, 'Abrotanum, Aesculus hipp., Allium sativum, Arsenicum alb., Artemisia, Baptisia, Cina, Cuprum met., Filix mas, Granatum, Ipecac, Lachesis, Lycopodium, Merc. viv, Naphthalinum, Nat. mur., Nux vom., Pulsatilla, Ratanhia, Ruta, Sabadilla, Santoninum, Silicea, Spigelia anth., Terebinthina, Teucrium marum, Thymolum, Zingiber, Juglans regia', 'Parasites', 'Curabitur gravida nisi at nibh. In hac habitasse platea dictumst. Aliquam augue quam, sollicitudin vitae, consectetuer eget, rutrum at, lorem.', 'Duis consequat dui nec nisi volutpat eleifend. Donec ut dolor. Morbi vel lectus in quam fringilla rhoncus.');
insert into Drug (DIN, drug_name_INN, drug_name_trade, drug_description, contraindications) values (84, 'Diclofenac Sodium', 'Diclofenac Sodium', 'Nullam sit amet turpis elementum ligula vehicula consequat. Morbi a ipsum. Integer a nibh.', 'Duis bibendum, felis sed interdum venenatis, turpis enim blandit mi, in porttitor pede justo eu massa. Donec dapibus. Duis at velit eu est congue elementum.');
insert into Drug (DIN, drug_name_INN, drug_name_trade, drug_description, contraindications) values (85, 'Avena Sativa, Lobelia Inflata, Cactus Grandiflorus, Tabacum, Gelsemium Sempervirens, Selenium Metallicum, Staphysagria', 'Tobacco', 'Praesent id massa id nisl venenatis lacinia. Aenean sit amet justo. Morbi ut odio.', 'Etiam vel augue. Vestibulum rutrum rutrum neque. Aenean auctor gravida sem.');
insert into Drug (DIN, drug_name_INN, drug_name_trade, drug_description, contraindications) values (86, 'Amoxicillin and Clavulanate Potassium', 'Amoxicillin and Calvulanate Potassium', 'Duis bibendum. Morbi non quam nec dui luctus rutrum. Nulla tellus.', 'Mauris enim leo, rhoncus sed, vestibulum sit amet, cursus id, turpis. Integer aliquet, massa id lobortis convallis, tortor risus dapibus augue, vel accumsan tellus nisi eu orci. Mauris lacinia sapien quis libero.');
insert into Drug (DIN, drug_name_INN, drug_name_trade, drug_description, contraindications) values (87, 'Menthol, Methyl salicylate', 'Salonpas pain relieving MASSAGE', 'Maecenas ut massa quis augue luctus tincidunt. Nulla mollis molestie lorem. Quisque ut erat.', 'Integer tincidunt ante vel ipsum. Praesent blandit lacinia erat. Vestibulum sed magna at nunc commodo placerat.');
insert into Drug (DIN, drug_name_INN, drug_name_trade, drug_description, contraindications) values (88, 'methocarbamol', 'Methocarbamol', 'In sagittis dui vel nisl. Duis ac nibh. Fusce lacus purus, aliquet at, feugiat non, pretium quis, lectus.', 'Quisque porta volutpat erat. Quisque erat eros, viverra eget, congue eget, semper rutrum, nulla. Nunc purus.');
insert into Drug (DIN, drug_name_INN, drug_name_trade, drug_description, contraindications) values (89, 'CEFPODOXIME PROXETIL', 'CEFPODOXIME PROXETIL', 'Maecenas ut massa quis augue luctus tincidunt. Nulla mollis molestie lorem. Quisque ut erat.', 'Praesent id massa id nisl venenatis lacinia. Aenean sit amet justo. Morbi ut odio.');
insert into Drug (DIN, drug_name_INN, drug_name_trade, drug_description, contraindications) values (90, 'Torsemide', 'Torsemide', 'Fusce posuere felis sed lacus. Morbi sem mauris, laoreet ut, rhoncus aliquet, pulvinar sed, nisl. Nunc rhoncus dui vel sem.', 'Proin interdum mauris non ligula pellentesque ultrices. Phasellus id sapien in sapien iaculis congue. Vivamus metus arcu, adipiscing molestie, hendrerit at, vulputate vitae, nisl.');
insert into Drug (DIN, drug_name_INN, drug_name_trade, drug_description, contraindications) values (91, 'Agaricus 30c, Belladonna 30c, Hyoscyamus 30c, Kali Brom 30c, Natrum Mur 30c, Nux Vomica 30c', 'Speech Therapy', 'Cras mi pede, malesuada in, imperdiet et, commodo vulputate, justo. In blandit ultrices enim. Lorem ipsum dolor sit amet, consectetuer adipiscing elit.', 'Phasellus sit amet erat. Nulla tempus. Vivamus in felis eu sapien cursus vestibulum.');
insert into Drug (DIN, drug_name_INN, drug_name_trade, drug_description, contraindications) values (92, 'Anastrozole', 'Anastrozole', 'Curabitur gravida nisi at nibh. In hac habitasse platea dictumst. Aliquam augue quam, sollicitudin vitae, consectetuer eget, rutrum at, lorem.', 'Proin eu mi. Nulla ac enim. In tempor, turpis nec euismod scelerisque, quam turpis adipiscing lorem, vitae mattis nibh ligula nec sem.');
insert into Drug (DIN, drug_name_INN, drug_name_trade, drug_description, contraindications) values (93, 'OCTINOXATE, OXYBENZONE', 'LBEL EFFET PARFAIT Spots Reducing Effect Foundation SPF 18 - MEDIUM 6', 'Phasellus in felis. Donec semper sapien a libero. Nam dui.', 'Duis aliquam convallis nunc. Proin at turpis a pede posuere nonummy. Integer non velit.');
insert into Drug (DIN, drug_name_INN, drug_name_trade, drug_description, contraindications) values (94, 'DIPHENHYDRAMINE HYDROCHLORIDE', 'APHENAP', 'Curabitur gravida nisi at nibh. In hac habitasse platea dictumst. Aliquam augue quam, sollicitudin vitae, consectetuer eget, rutrum at, lorem.', 'Fusce consequat. Nulla nisl. Nunc nisl.');
insert into Drug (DIN, drug_name_INN, drug_name_trade, drug_description, contraindications) values (95, 'Ranitidine', 'Acid Reducer', 'Duis bibendum. Morbi non quam nec dui luctus rutrum. Nulla tellus.', 'In sagittis dui vel nisl. Duis ac nibh. Fusce lacus purus, aliquet at, feugiat non, pretium quis, lectus.');
insert into Drug (DIN, drug_name_INN, drug_name_trade, drug_description, contraindications) values (96, 'Spironolactone', 'Spironolactone', 'Donec diam neque, vestibulum eget, vulputate ut, ultrices vel, augue. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Donec pharetra, magna vestibulum aliquet ultrices, erat tortor sollicitudin mi, sit amet lobortis sapien sapien non mi. Integer ac neque.', 'Duis bibendum. Morbi non quam nec dui luctus rutrum. Nulla tellus.');
insert into Drug (DIN, drug_name_INN, drug_name_trade, drug_description, contraindications) values (97, 'BENZALKONIUM CHLORIDE', 'GOLDSHIELD 24', 'Aenean fermentum. Donec ut mauris eget massa tempor convallis. Nulla neque libero, convallis eget, eleifend luctus, ultricies eu, nibh.', 'Proin eu mi. Nulla ac enim. In tempor, turpis nec euismod scelerisque, quam turpis adipiscing lorem, vitae mattis nibh ligula nec sem.');
insert into Drug (DIN, drug_name_INN, drug_name_trade, drug_description, contraindications) values (98, 'Piperonyl butoxide, Pyrethrum extract', 'smart sense lice killing', 'Maecenas leo odio, condimentum id, luctus nec, molestie sed, justo. Pellentesque viverra pede ac diam. Cras pellentesque volutpat dui.', 'Aliquam quis turpis eget elit sodales scelerisque. Mauris sit amet eros. Suspendisse accumsan tortor quis turpis.');
insert into Drug (DIN, drug_name_INN, drug_name_trade, drug_description, contraindications) values (99, 'Acetaminophen, dextromethorphan HBr, guaifenesin, phenylephrine HCl, diphenhydramine HCl', 'TopCare Mucus Relief and Cold and Flu', 'Maecenas ut massa quis augue luctus tincidunt. Nulla mollis molestie lorem. Quisque ut erat.', 'Proin eu mi. Nulla ac enim. In tempor, turpis nec euismod scelerisque, quam turpis adipiscing lorem, vitae mattis nibh ligula nec sem.');
insert into Drug (DIN, drug_name_INN, drug_name_trade, drug_description, contraindications) values (100, 'Iron, Cyanocobalamin and Folic Acid', 'Iferex 150 Forte', 'Etiam vel augue. Vestibulum rutrum rutrum neque. Aenean auctor gravida sem.', 'Proin leo odio, porttitor id, consequat in, consequat ut, nulla. Sed accumsan felis. Ut at dolor quis odio consequat varius.');

insert into Over_the_counter_drug (DIN, brand, cost, quantity) values (1, 'Topco Associates LLC', '$9.93', 95);
insert into Over_the_counter_drug (DIN, brand, cost, quantity) values (2, 'Dollar General', '$8.67', 167);
insert into Over_the_counter_drug (DIN, brand, cost, quantity) values (3, 'Conopco Inc. d/b/a Unilever', '$15.58', 68);
insert into Over_the_counter_drug (DIN, brand, cost, quantity) values (4, 'Navarro Discount Pharmacies,LLC', '$7.38', 109);
insert into Over_the_counter_drug (DIN, brand, cost, quantity) values (5, 'AMOREPACIFIC', '$15.24', 140);
insert into Over_the_counter_drug (DIN, brand, cost, quantity) values (6, 'UDL Laboratories, Inc.', '$10.22', 49);
insert into Over_the_counter_drug (DIN, brand, cost, quantity) values (7, 'Mallinckrodt, Inc.', '$26.01', 152);
insert into Over_the_counter_drug (DIN, brand, cost, quantity) values (8, 'STAT RX USA LLC', '$26.22', 25);
insert into Over_the_counter_drug (DIN, brand, cost, quantity) values (9, 'Ventura Corporation, Ltd.', '$15.93', 144);
insert into Over_the_counter_drug (DIN, brand, cost, quantity) values (10, 'KAS Direct LLC dba BabyGanics', '$27.95', 70);
insert into Over_the_counter_drug (DIN, brand, cost, quantity) values (11, 'Kroger Company', '$22.51', 15);
insert into Over_the_counter_drug (DIN, brand, cost, quantity) values (12, 'Walgreen Company', '$22.64', 135);
insert into Over_the_counter_drug (DIN, brand, cost, quantity) values (13, 'Pharmacia and Upjohn Company', '$6.94', 200);
insert into Over_the_counter_drug (DIN, brand, cost, quantity) values (14, 'St Marys Medical Park Pharmacy', '$16.35', 39);
insert into Over_the_counter_drug (DIN, brand, cost, quantity) values (15, 'Cardinal Health', '$23.15', 55);
insert into Over_the_counter_drug (DIN, brand, cost, quantity) values (16, 'Aidarex Pharmaceuticals LLC', '$19.33', 78);
insert into Over_the_counter_drug (DIN, brand, cost, quantity) values (17, 'JHP Pharmaceuticals, LLC', '$14.65', 103);
insert into Over_the_counter_drug (DIN, brand, cost, quantity) values (18, 'Cederroth AB', '$5.03', 22);
insert into Over_the_counter_drug (DIN, brand, cost, quantity) values (19, 'Piramal Critical Care Inc.', '$24.17', 21);
insert into Over_the_counter_drug (DIN, brand, cost, quantity) values (20, 'Galderma Laboratories, L.P.', '$17.23', 21);
insert into Over_the_counter_drug (DIN, brand, cost, quantity) values (21, 'Sun Pharma Global Inc.', '$23.27', 167);
insert into Over_the_counter_drug (DIN, brand, cost, quantity) values (22, 'Allergy Laboratories, Inc.', '$15.50', 52);
insert into Over_the_counter_drug (DIN, brand, cost, quantity) values (23, 'AMERICAN SALES COMPANY', '$29.24', 14);
insert into Over_the_counter_drug (DIN, brand, cost, quantity) values (24, 'H E B', '$26.69', 190);
insert into Over_the_counter_drug (DIN, brand, cost, quantity) values (25, 'GOWOONSESANG COSMETICS CO., LTD.', '$10.45', 15);

insert into Stock_drug (DIN, amount_g, cost_per_g) values (26, 636.694, '$0.58');
insert into Stock_drug (DIN, amount_g, cost_per_g) values (27, 532.452, '$0.32');
insert into Stock_drug (DIN, amount_g, cost_per_g) values (28, 1776.931, '$3.86');
insert into Stock_drug (DIN, amount_g, cost_per_g) values (29, 448.076, '$0.76');
insert into Stock_drug (DIN, amount_g, cost_per_g) values (30, 407.492, '$1.19');
insert into Stock_drug (DIN, amount_g, cost_per_g) values (31, 262.36, '$3.25');
insert into Stock_drug (DIN, amount_g, cost_per_g) values (32, 207.774, '$4.57');
insert into Stock_drug (DIN, amount_g, cost_per_g) values (33, 1159.894, '$3.15');
insert into Stock_drug (DIN, amount_g, cost_per_g) values (34, 1333.352, '$2.29');
insert into Stock_drug (DIN, amount_g, cost_per_g) values (35, 270.821, '$1.37');
insert into Stock_drug (DIN, amount_g, cost_per_g) values (36, 1215.134, '$0.70');
insert into Stock_drug (DIN, amount_g, cost_per_g) values (37, 379.333, '$1.69');
insert into Stock_drug (DIN, amount_g, cost_per_g) values (38, 768.871, '$0.60');
insert into Stock_drug (DIN, amount_g, cost_per_g) values (39, 1762.674, '$4.62');
insert into Stock_drug (DIN, amount_g, cost_per_g) values (40, 1062.691, '$0.42');
insert into Stock_drug (DIN, amount_g, cost_per_g) values (41, 1564.646, '$2.61');
insert into Stock_drug (DIN, amount_g, cost_per_g) values (42, 1330.503, '$4.86');
insert into Stock_drug (DIN, amount_g, cost_per_g) values (43, 1734.498, '$2.25');
insert into Stock_drug (DIN, amount_g, cost_per_g) values (44, 1274.059, '$3.62');
insert into Stock_drug (DIN, amount_g, cost_per_g) values (45, 1666.156, '$1.11');
insert into Stock_drug (DIN, amount_g, cost_per_g) values (46, 642.549, '$3.33');
insert into Stock_drug (DIN, amount_g, cost_per_g) values (47, 1787.179, '$2.60');
insert into Stock_drug (DIN, amount_g, cost_per_g) values (48, 275.032, '$0.33');
insert into Stock_drug (DIN, amount_g, cost_per_g) values (49, 739.586, '$0.78');
insert into Stock_drug (DIN, amount_g, cost_per_g) values (50, 1335.879, '$4.07');
insert into Stock_drug (DIN, amount_g, cost_per_g) values (51, 672.19, '$1.62');
insert into Stock_drug (DIN, amount_g, cost_per_g) values (52, 1478.965, '$3.93');
insert into Stock_drug (DIN, amount_g, cost_per_g) values (53, 302.73, '$1.19');
insert into Stock_drug (DIN, amount_g, cost_per_g) values (54, 542.667, '$0.90');
insert into Stock_drug (DIN, amount_g, cost_per_g) values (55, 733.841, '$4.62');
insert into Stock_drug (DIN, amount_g, cost_per_g) values (56, 786.528, '$3.36');
insert into Stock_drug (DIN, amount_g, cost_per_g) values (57, 496.97, '$2.38');
insert into Stock_drug (DIN, amount_g, cost_per_g) values (58, 1371.204, '$4.23');
insert into Stock_drug (DIN, amount_g, cost_per_g) values (59, 1938.016, '$1.74');
insert into Stock_drug (DIN, amount_g, cost_per_g) values (60, 1030.642, '$1.65');
insert into Stock_drug (DIN, amount_g, cost_per_g) values (61, 1059.618, '$4.97');
insert into Stock_drug (DIN, amount_g, cost_per_g) values (62, 1569.22, '$3.51');
insert into Stock_drug (DIN, amount_g, cost_per_g) values (63, 734.286, '$0.48');
insert into Stock_drug (DIN, amount_g, cost_per_g) values (64, 891.191, '$2.22');
insert into Stock_drug (DIN, amount_g, cost_per_g) values (65, 1543.677, '$0.40');
insert into Stock_drug (DIN, amount_g, cost_per_g) values (66, 1559.45, '$4.10');
insert into Stock_drug (DIN, amount_g, cost_per_g) values (67, 1544.774, '$4.77');
insert into Stock_drug (DIN, amount_g, cost_per_g) values (68, 281.328, '$3.61');
insert into Stock_drug (DIN, amount_g, cost_per_g) values (69, 867.676, '$1.76');
insert into Stock_drug (DIN, amount_g, cost_per_g) values (70, 799.758, '$3.12');
insert into Stock_drug (DIN, amount_g, cost_per_g) values (71, 717.561, '$1.31');
insert into Stock_drug (DIN, amount_g, cost_per_g) values (72, 688.873, '$1.92');
insert into Stock_drug (DIN, amount_g, cost_per_g) values (73, 1894.478, '$4.60');
insert into Stock_drug (DIN, amount_g, cost_per_g) values (74, 1849.906, '$2.83');
insert into Stock_drug (DIN, amount_g, cost_per_g) values (75, 1132.724, '$3.24');
insert into Stock_drug (DIN, amount_g, cost_per_g) values (76, 378.11, '$0.78');
insert into Stock_drug (DIN, amount_g, cost_per_g) values (77, 194.444, '$1.03');
insert into Stock_drug (DIN, amount_g, cost_per_g) values (78, 323.182, '$2.58');
insert into Stock_drug (DIN, amount_g, cost_per_g) values (79, 1101.888, '$2.60');
insert into Stock_drug (DIN, amount_g, cost_per_g) values (80, 1416.001, '$1.24');
insert into Stock_drug (DIN, amount_g, cost_per_g) values (81, 492.223, '$4.11');
insert into Stock_drug (DIN, amount_g, cost_per_g) values (82, 1337.578, '$4.41');
insert into Stock_drug (DIN, amount_g, cost_per_g) values (83, 1113.343, '$2.58');
insert into Stock_drug (DIN, amount_g, cost_per_g) values (84, 596.86, '$0.16');
insert into Stock_drug (DIN, amount_g, cost_per_g) values (85, 935.459, '$1.70');
insert into Stock_drug (DIN, amount_g, cost_per_g) values (86, 1647.581, '$2.20');
insert into Stock_drug (DIN, amount_g, cost_per_g) values (87, 1292.904, '$3.68');
insert into Stock_drug (DIN, amount_g, cost_per_g) values (88, 1628.029, '$3.14');
insert into Stock_drug (DIN, amount_g, cost_per_g) values (89, 1896.873, '$0.21');
insert into Stock_drug (DIN, amount_g, cost_per_g) values (90, 1731.927, '$1.73');
insert into Stock_drug (DIN, amount_g, cost_per_g) values (91, 1691.696, '$4.80');
insert into Stock_drug (DIN, amount_g, cost_per_g) values (92, 344.484, '$0.69');
insert into Stock_drug (DIN, amount_g, cost_per_g) values (93, 1484.625, '$2.94');
insert into Stock_drug (DIN, amount_g, cost_per_g) values (94, 798.978, '$0.64');
insert into Stock_drug (DIN, amount_g, cost_per_g) values (95, 1393.552, '$3.74');
insert into Stock_drug (DIN, amount_g, cost_per_g) values (96, 1784.968, '$4.05');
insert into Stock_drug (DIN, amount_g, cost_per_g) values (97, 1411.892, '$0.37');
insert into Stock_drug (DIN, amount_g, cost_per_g) values (98, 1113.438, '$1.70');
insert into Stock_drug (DIN, amount_g, cost_per_g) values (99, 1516.43, '$4.74');
insert into Stock_drug (DIN, amount_g, cost_per_g) values (100, 453.487, '$0.65');

insert into Item_consistof_drug (item_id, DIN) values ('00000000', 1);
insert into Item_consistof_drug (item_id, DIN) values ('00000001', 2);
insert into Item_consistof_drug (item_id, DIN) values ('00000002', 3);
insert into Item_consistof_drug (item_id, DIN) values ('00000003', 4);
insert into Item_consistof_drug (item_id, DIN) values ('00000004', 5);

insert into Payment_paid_by values ('11111111', '00000000', '2016-11-23', '$22.30', '123456789012', '2018-08-29', '13:00');
insert into Payment_paid_by values ('22222222', '00000001', '2016-01-03', '$2.30', '412398792345', '2020-01-31', '14:45');
insert into Payment_paid_by values ('33333333', '00000002', '2016-04-20', '$11.02', '543098672345', '2016-12-14', '09:11');
insert into Payment_paid_by values ('44444444', '00000003', '2015-12-31', '$44.44', '432898761239', '2018-08-11', '11:37');
insert into Payment_paid_by values ('55555555', '00000004', '2016-10-18', '$9.35', '543687931112', '2017-02-01', '16:07');

insert into Walk_in_Client (customer_Id) values ('00000003');
insert into Walk_in_Client (customer_Id) values ('00000004');