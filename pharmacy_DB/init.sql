drop table Vaccination;
drop table Service_provides;
drop table Pharmacy_Assistant;
drop table Pharmacist;
drop table Pharmacy_Technician;
drop table Employee;
drop table Item_consistof_drug;
drop table Prescription_item_has;
drop table Prescription_by_is_for;
drop table Over_the_counter_drug;
drop table Stock_drug;
drop table Doctor;
drop table Purchase_record;
drop table Patient;
drop table Walk_in_Client;
drop table Drug;
drop table Subsidizes;
drop table Payment_paid_by;
drop table Customer;
drop table Insurance_coverage;

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

 create table Doctor 
 	(doctor_id int not null,
 	 phone_number varchar2(32) not null,
 	 name varchar2(32),
 	 primary key (doctor_id)
 	);

 create table Insurance_coverage
 	(policy_id int not null,
	 expDate date null,
 	 maxAllowance_cents int null,
   	 company varchar (40) null,
 	 primary key (policy_id)
 	); 

create table Customer
	(customer_id int not null,
	 name varchar2(32) null,
 	 phone_number varchar2(32) null,
	 insurance_policy_id int null,
 	 primary key (customer_id),
 	 foreign key (insurance_policy_id) references Insurance_coverage
 	);

 create table Patient
 	(customer_id int not null,
 	 care_card_number char(16) not null,
 	 address char(32) null,
 	 birthdate date null,
 	 gender char(1) null,
 	 primary key (customer_id), 
 	 foreign key (customer_id) references Customer ON DELETE CASCADE
 	);

 create table Prescription_by_is_for
 	(service_id int not null,
	 doctor_id int not null,
 	 customer_id int not null,
 	 prescription_id int not null, 
 	 date_prescribed date not null, 
	 primary key (service_id), 
 	 foreign key (doctor_id) references Doctor ON DELETE CASCADE, 
	 foreign key (customer_id) references Patient ON DELETE CASCADE
 	);

create table Prescription_item_has
	(item_id int not null unique,
 	 prescription_id int not null,
	 dose varchar2(16) not null,
 	 duration varchar2(32) not null,
 	 frequency varchar2(32) not null,
 	 primary key (item_id, prescription_id), 
 	 foreign key (prescription_id) references Prescription_by_is_for ON DELETE CASCADE
	);


create table Service_provides
	(service_id int not null unique,
	 emp_id int not null,
	 primary key (service_id, emp_id), 
	 foreign key (emp_id) references Pharmacist ON DELETE CASCADE
	); 

create table Vaccination 
	(service_id int not null, 
 	 vaccination_id int null,
	 date_vaccinated date null,
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
	 brand varchar2(64) null,
	 cost_cents int null,
	 quantity int null,
	 primary key (DIN), 
	 foreign key (DIN) references Drug ON DELETE CASCADE
	);

create table Stock_drug
	(DIN int not null,
	 amount_mg int null,
	 cost_per_mg_cents int null,
	 primary key (DIN), 
	 foreign key (DIN) references Drug ON DELETE CASCADE
	);

create table Item_consistof_drug 
	(item_id int not null,
	 DIN int not null,
	 primary key (item_id, DIN), 
	 foreign key (item_id) references Prescription_item_has (item_id) ON DELETE CASCADE, 
	 foreign key (DIN) references Drug ON DELETE CASCADE
	);

create table Payment_paid_by
 	(paymentId int not null, 
 	customer_id int not null,
 	transdate date not null,
 	total char(10) not null,
 	cardNumber char(12) not null,
 	cardExpDate date not null,
 	time char(5) not null,
 	primary key (paymentId), 
 	foreign key (customer_id) references Customer ON DELETE CASCADE 
 	); 

create table Purchase_record
 	(record_id int not null,
 	 customer_id int not null,
 	 din int not null,
 	 quantity int null,
 	 primary key (record_id, customer_id),
 	 foreign key (customer_id) references Customer ON DELETE CASCADE,
 	 foreign key (din) references Drug ON DELETE CASCADE
 	);

create table Subsidizes
	(paymentId int not null, 
	 policyId int not null, 
 	 primary key (paymentId, policyId), 
 	 foreign key (paymentId) references Payment_paid_by ON DELETE CASCADE, 
 	 foreign key (policyId) references Insurance_coverage ON DELETE CASCADE
	); 

create table Walk_in_Client
	(customer_id int not null, 
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

insert into Over_the_counter_drug (DIN, brand, cost_cents, quantity) values (2, 'Kinray Inc.', 2178, 40);
insert into Over_the_counter_drug (DIN, brand, cost_cents, quantity) values (4, 'Paddock Laboratories, LLC', 1894, 72);
insert into Over_the_counter_drug (DIN, brand, cost_cents, quantity) values (6, 'Paddock Laboratories, LLC', 1183, 142);
insert into Over_the_counter_drug (DIN, brand, cost_cents, quantity) values (8, 'Erno Laszlo, Inc.', 2802, 97);
insert into Over_the_counter_drug (DIN, brand, cost_cents, quantity) values (10, 'Natural Health Supply', 686, 64);
insert into Over_the_counter_drug (DIN, brand, cost_cents, quantity) values (12, 'STAT Rx USA LLC', 1715, 77);
insert into Over_the_counter_drug (DIN, brand, cost_cents, quantity) values (14, 'State of Florida DOH Central Pharmacy', 2918, 68);
insert into Over_the_counter_drug (DIN, brand, cost_cents, quantity) values (16, 'APP Pharmaceuticals, LLC', 805, 49);
insert into Over_the_counter_drug (DIN, brand, cost_cents, quantity) values (18, 'STAT Rx USA LLC', 2683, 82);
insert into Over_the_counter_drug (DIN, brand, cost_cents, quantity) values (20, 'American Health Packaging', 2054, 193);
insert into Over_the_counter_drug (DIN, brand, cost_cents, quantity) values (22, 'Procter Manufacturing Co.', 1980, 185);
insert into Over_the_counter_drug (DIN, brand, cost_cents, quantity) values (24, 'PUREMEDY', 1932, 180);
insert into Over_the_counter_drug (DIN, brand, cost_cents, quantity) values (26, 'CVS Pharmacy', 783, 37);
insert into Over_the_counter_drug (DIN, brand, cost_cents, quantity) values (28, 'Hospira, Inc.', 1518, 167);
insert into Over_the_counter_drug (DIN, brand, cost_cents, quantity) values (30, 'Ricola USA Inc.', 2814, 83);
insert into Over_the_counter_drug (DIN, brand, cost_cents, quantity) values (32, 'Hi-Tech Pharmacal Co., Inc.', 1557, 140);
insert into Over_the_counter_drug (DIN, brand, cost_cents, quantity) values (34, 'Torrent Pharmaceuticals Limited', 2932, 187);
insert into Over_the_counter_drug (DIN, brand, cost_cents, quantity) values (36, 'Sandoz Inc', 794, 23);
insert into Over_the_counter_drug (DIN, brand, cost_cents, quantity) values (38, 'Watson Laboratories, Inc.', 2661, 59);
insert into Over_the_counter_drug (DIN, brand, cost_cents, quantity) values (40, 'Walgreens', 1472, 173);
insert into Over_the_counter_drug (DIN, brand, cost_cents, quantity) values (42, 'Integrative Healing Institute, LLC', 2450, 41);
insert into Over_the_counter_drug (DIN, brand, cost_cents, quantity) values (44, 'Physicians Total Care, Inc.', 2288, 177);
insert into Over_the_counter_drug (DIN, brand, cost_cents, quantity) values (46, 'Biocosmetic Research Labs', 1585, 137);
insert into Over_the_counter_drug (DIN, brand, cost_cents, quantity) values (48, 'Par Pharmaceutical Inc.', 1015, 199);
insert into Over_the_counter_drug (DIN, brand, cost_cents, quantity) values (50, 'Amerisource Bergen', 1529, 137);
insert into Over_the_counter_drug (DIN, brand, cost_cents, quantity) values (52, 'Barr Laboratories Inc.', 1213, 131);
insert into Over_the_counter_drug (DIN, brand, cost_cents, quantity) values (54, 'Preferred Pharmaceuticals, Inc.', 1893, 87);
insert into Over_the_counter_drug (DIN, brand, cost_cents, quantity) values (56, 'Wal-Mart Stores Inc', 2521, 169);
insert into Over_the_counter_drug (DIN, brand, cost_cents, quantity) values (58, 'Supervalu Inc', 1566, 38);
insert into Over_the_counter_drug (DIN, brand, cost_cents, quantity) values (60, 'Hospira, Inc.', 1549, 134);
insert into Over_the_counter_drug (DIN, brand, cost_cents, quantity) values (62, 'Ventura International LTD', 1736, 182);
insert into Over_the_counter_drug (DIN, brand, cost_cents, quantity) values (64, 'AvKARE, Inc.', 1284, 35);
insert into Over_the_counter_drug (DIN, brand, cost_cents, quantity) values (66, 'Gurwitch Products', 1647, 54);
insert into Over_the_counter_drug (DIN, brand, cost_cents, quantity) values (68, 'Meijer Distribution Inc', 2162, 142);
insert into Over_the_counter_drug (DIN, brand, cost_cents, quantity) values (70, 'Nelco Laboratories, Inc.', 2583, 136);
insert into Over_the_counter_drug (DIN, brand, cost_cents, quantity) values (72, 'Deseret Biologicals, Inc.', 629, 24);
insert into Over_the_counter_drug (DIN, brand, cost_cents, quantity) values (74, 'ALK-Abello, Inc.', 2361, 18);
insert into Over_the_counter_drug (DIN, brand, cost_cents, quantity) values (76, 'L Perrigo Company', 2346, 69);
insert into Over_the_counter_drug (DIN, brand, cost_cents, quantity) values (78, 'NUGA MEDICAL CO., LTD.', 1138, 91);
insert into Over_the_counter_drug (DIN, brand, cost_cents, quantity) values (80, 'Baxter Healthcare Corporation', 2623, 163);
insert into Over_the_counter_drug (DIN, brand, cost_cents, quantity) values (82, 'Aurobindo Pharma Limited', 2504, 166);
insert into Over_the_counter_drug (DIN, brand, cost_cents, quantity) values (84, 'Kinray Inc.', 1446, 23);
insert into Over_the_counter_drug (DIN, brand, cost_cents, quantity) values (86, 'Carlsbad Technology, Inc.', 2820, 31);
insert into Over_the_counter_drug (DIN, brand, cost_cents, quantity) values (88, 'McKesson', 1956, 20);
insert into Over_the_counter_drug (DIN, brand, cost_cents, quantity) values (90, 'Cardinal Health', 2848, 159);
insert into Over_the_counter_drug (DIN, brand, cost_cents, quantity) values (92, 'Gadal Laboratories Inc', 2022, 57);
insert into Over_the_counter_drug (DIN, brand, cost_cents, quantity) values (94, 'Wyeth Pharmaceuticals Inc., a subsidiary of Pfizer Inc.', 1331, 95);
insert into Over_the_counter_drug (DIN, brand, cost_cents, quantity) values (96, 'A-S Medication Solutions LLC', 1851, 62);
insert into Over_the_counter_drug (DIN, brand, cost_cents, quantity) values (98, 'SHISEIDO AMERICA INC.', 529, 43);
insert into Over_the_counter_drug (DIN, brand, cost_cents, quantity) values (100, 'Mylan Pharmaceuticals Inc.', 2900, 150);

insert into Stock_drug (DIN, amount_mg, cost_per_mg_cents) values (1, 734174, 139);
insert into Stock_drug (DIN, amount_mg, cost_per_mg_cents) values (3, 975335, 88);
insert into Stock_drug (DIN, amount_mg, cost_per_mg_cents) values (5, 1039243, 46);
insert into Stock_drug (DIN, amount_mg, cost_per_mg_cents) values (7, 1339680, 101);
insert into Stock_drug (DIN, amount_mg, cost_per_mg_cents) values (9, 512513, 308);
insert into Stock_drug (DIN, amount_mg, cost_per_mg_cents) values (11, 924461, 321);
insert into Stock_drug (DIN, amount_mg, cost_per_mg_cents) values (13, 1236782, 140);
insert into Stock_drug (DIN, amount_mg, cost_per_mg_cents) values (15, 402697, 312);
insert into Stock_drug (DIN, amount_mg, cost_per_mg_cents) values (17, 500666, 260);
insert into Stock_drug (DIN, amount_mg, cost_per_mg_cents) values (19, 784319, 301);
insert into Stock_drug (DIN, amount_mg, cost_per_mg_cents) values (21, 799932, 408);
insert into Stock_drug (DIN, amount_mg, cost_per_mg_cents) values (23, 1153315, 156);
insert into Stock_drug (DIN, amount_mg, cost_per_mg_cents) values (25, 937398, 408);
insert into Stock_drug (DIN, amount_mg, cost_per_mg_cents) values (27, 1266987, 281);
insert into Stock_drug (DIN, amount_mg, cost_per_mg_cents) values (29, 249283, 99);
insert into Stock_drug (DIN, amount_mg, cost_per_mg_cents) values (31, 359900, 441);
insert into Stock_drug (DIN, amount_mg, cost_per_mg_cents) values (33, 1473890, 291);
insert into Stock_drug (DIN, amount_mg, cost_per_mg_cents) values (35, 772026, 395);
insert into Stock_drug (DIN, amount_mg, cost_per_mg_cents) values (37, 1037310, 225);
insert into Stock_drug (DIN, amount_mg, cost_per_mg_cents) values (39, 371517, 493);
insert into Stock_drug (DIN, amount_mg, cost_per_mg_cents) values (41, 951216, 118);
insert into Stock_drug (DIN, amount_mg, cost_per_mg_cents) values (43, 1103434, 438);
insert into Stock_drug (DIN, amount_mg, cost_per_mg_cents) values (45, 887888, 183);
insert into Stock_drug (DIN, amount_mg, cost_per_mg_cents) values (47, 415521, 413);
insert into Stock_drug (DIN, amount_mg, cost_per_mg_cents) values (49, 909993, 70);
insert into Stock_drug (DIN, amount_mg, cost_per_mg_cents) values (51, 1478879, 131);
insert into Stock_drug (DIN, amount_mg, cost_per_mg_cents) values (53, 213969, 18);
insert into Stock_drug (DIN, amount_mg, cost_per_mg_cents) values (55, 1075790, 57);
insert into Stock_drug (DIN, amount_mg, cost_per_mg_cents) values (57, 1194797, 471);
insert into Stock_drug (DIN, amount_mg, cost_per_mg_cents) values (59, 1084019, 238);
insert into Stock_drug (DIN, amount_mg, cost_per_mg_cents) values (61, 749324, 252);
insert into Stock_drug (DIN, amount_mg, cost_per_mg_cents) values (63, 1071438, 328);
insert into Stock_drug (DIN, amount_mg, cost_per_mg_cents) values (65, 316218, 2);
insert into Stock_drug (DIN, amount_mg, cost_per_mg_cents) values (67, 249887, 385);
insert into Stock_drug (DIN, amount_mg, cost_per_mg_cents) values (69, 207339, 64);
insert into Stock_drug (DIN, amount_mg, cost_per_mg_cents) values (71, 656590, 486);
insert into Stock_drug (DIN, amount_mg, cost_per_mg_cents) values (73, 1349618, 117);
insert into Stock_drug (DIN, amount_mg, cost_per_mg_cents) values (75, 720608, 389);
insert into Stock_drug (DIN, amount_mg, cost_per_mg_cents) values (77, 773844, 383);
insert into Stock_drug (DIN, amount_mg, cost_per_mg_cents) values (79, 1273970, 399);
insert into Stock_drug (DIN, amount_mg, cost_per_mg_cents) values (81, 1499718, 249);
insert into Stock_drug (DIN, amount_mg, cost_per_mg_cents) values (83, 1307107, 139);
insert into Stock_drug (DIN, amount_mg, cost_per_mg_cents) values (85, 1487672, 317);
insert into Stock_drug (DIN, amount_mg, cost_per_mg_cents) values (87, 302617, 149);
insert into Stock_drug (DIN, amount_mg, cost_per_mg_cents) values (89, 610777, 164);
insert into Stock_drug (DIN, amount_mg, cost_per_mg_cents) values (91, 670081, 171);
insert into Stock_drug (DIN, amount_mg, cost_per_mg_cents) values (93, 1117596, 2);
insert into Stock_drug (DIN, amount_mg, cost_per_mg_cents) values (95, 554931, 198);
insert into Stock_drug (DIN, amount_mg, cost_per_mg_cents) values (97, 1391539, 307);
insert into Stock_drug (DIN, amount_mg, cost_per_mg_cents) values (99, 903718, 301);

insert into Insurance_coverage (policy_id, expDate, maxAllowance_cents, company) values (0, '2019-07-28', 70000, 'Cartwright LLC');
insert into Insurance_coverage (policy_id, expDate, maxAllowance_cents, company) values (173, '2020-10-29', 70000, 'Padberg, Waelchi and Mann');
insert into Insurance_coverage (policy_id, expDate, maxAllowance_cents, company) values (346, '2021-03-17', 430000, 'Kuhn, McCullough and Feeney');
insert into Insurance_coverage (policy_id, expDate, maxAllowance_cents, company) values (519, '2022-12-25', 70000, 'Goyette-Lockman');
insert into Insurance_coverage (policy_id, expDate, maxAllowance_cents, company) values (692, '2024-02-08', 520000, 'Terry-Klein');
insert into Insurance_coverage (policy_id, expDate, maxAllowance_cents, company) values (865, '2023-10-16', 430000, 'McClure, Kuhn and Jacobi');
insert into Insurance_coverage (policy_id, expDate, maxAllowance_cents, company) values (1038, '2019-05-12', 610000, 'Gorczany and Sons');
insert into Insurance_coverage (policy_id, expDate, maxAllowance_cents, company) values (1211, '2020-06-27', 640000, 'Hudson, Kuvalis and Stark');
insert into Insurance_coverage (policy_id, expDate, maxAllowance_cents, company) values (1384, '2020-08-25', 970000, 'Olson-Thiel');
insert into Insurance_coverage (policy_id, expDate, maxAllowance_cents, company) values (1557, '2022-07-13', 390000, 'Schultz, Turcotte and Block');
insert into Insurance_coverage (policy_id, expDate, maxAllowance_cents, company) values (1730, '2023-06-07', 410000, 'Skiles-Halvorson');
insert into Insurance_coverage (policy_id, expDate, maxAllowance_cents, company) values (1903, '2021-11-09', 580000, 'Pollich, Gleason and O''Hara');
insert into Insurance_coverage (policy_id, expDate, maxAllowance_cents, company) values (2076, '2023-07-15', 330000, 'Douglas-Hansen');
insert into Insurance_coverage (policy_id, expDate, maxAllowance_cents, company) values (2249, '2021-01-13', 290000, 'Langosh, Fay and Stamm');
insert into Insurance_coverage (policy_id, expDate, maxAllowance_cents, company) values (2422, '2019-02-12', 160000, 'Kassulke and Sons');
insert into Insurance_coverage (policy_id, expDate, maxAllowance_cents, company) values (2595, '2024-01-01', 90000, 'Jacobi Group');
insert into Insurance_coverage (policy_id, expDate, maxAllowance_cents, company) values (2768, '2021-04-10', 450000, 'Shields, Paucek and Leannon');
insert into Insurance_coverage (policy_id, expDate, maxAllowance_cents, company) values (2941, '2020-05-01', 740000, 'Bednar-Feil');
insert into Insurance_coverage (policy_id, expDate, maxAllowance_cents, company) values (3114, '2019-07-20', 380000, 'Abernathy-Shields');
insert into Insurance_coverage (policy_id, expDate, maxAllowance_cents, company) values (3287, '2024-03-25', 80000, 'Hamill and Sons');
insert into Insurance_coverage (policy_id, expDate, maxAllowance_cents, company) values (3460, '2020-12-04', 460000, 'Labadie, Will and Becker');
insert into Insurance_coverage (policy_id, expDate, maxAllowance_cents, company) values (3633, '2020-08-24', 910000, 'Glover, Schulist and Keebler');
insert into Insurance_coverage (policy_id, expDate, maxAllowance_cents, company) values (3806, '2024-03-27', 960000, 'Feest, Cummerata and Tremblay');
insert into Insurance_coverage (policy_id, expDate, maxAllowance_cents, company) values (3979, '2023-05-10', 50000, 'Purdy, Rowe and Monahan');
insert into Insurance_coverage (policy_id, expDate, maxAllowance_cents, company) values (4152, '2019-11-18', 430000, 'Senger Inc');
insert into Insurance_coverage (policy_id, expDate, maxAllowance_cents, company) values (4325, '2023-06-27', 800000, 'Strosin and Sons');
insert into Insurance_coverage (policy_id, expDate, maxAllowance_cents, company) values (4498, '2023-04-05', 330000, 'Beahan, Bins and Stanton');
insert into Insurance_coverage (policy_id, expDate, maxAllowance_cents, company) values (4671, '2023-02-03', 290000, 'Pfannerstill, Beahan and Brown');
insert into Insurance_coverage (policy_id, expDate, maxAllowance_cents, company) values (4844, '2021-05-25', 660000, 'Ward-Dach');
insert into Insurance_coverage (policy_id, expDate, maxAllowance_cents, company) values (5017, '2019-02-25', 970000, 'Blick, Becker and Haag');
insert into Insurance_coverage (policy_id, expDate, maxAllowance_cents, company) values (5190, '2019-08-31', 180000, 'King LLC');
insert into Insurance_coverage (policy_id, expDate, maxAllowance_cents, company) values (5363, '2019-05-22', 260000, 'Maggio Inc');
insert into Insurance_coverage (policy_id, expDate, maxAllowance_cents, company) values (5536, '2024-07-21', 270000, 'MacGyver and Sons');
insert into Insurance_coverage (policy_id, expDate, maxAllowance_cents, company) values (5709, '2019-10-05', 150000, 'Rutherford-Kling');
insert into Insurance_coverage (policy_id, expDate, maxAllowance_cents, company) values (5882, '2019-03-29', 120000, 'McLaughlin-Bashirian');
insert into Insurance_coverage (policy_id, expDate, maxAllowance_cents, company) values (6055, '2023-11-21', 400000, 'Stroman and Sons');
insert into Insurance_coverage (policy_id, expDate, maxAllowance_cents, company) values (6228, '2018-11-14', 200000, 'Ferry-Fadel');
insert into Insurance_coverage (policy_id, expDate, maxAllowance_cents, company) values (6401, '2020-01-29', 130000, 'Jacobson, Leannon and Hayes');
insert into Insurance_coverage (policy_id, expDate, maxAllowance_cents, company) values (6574, '2024-01-30', 810000, 'Hintz-Mueller');
insert into Insurance_coverage (policy_id, expDate, maxAllowance_cents, company) values (6747, '2019-10-29', 340000, 'Wolff Group');
insert into Insurance_coverage (policy_id, expDate, maxAllowance_cents, company) values (6920, '2021-05-10', 260000, 'Mitchell Inc');
insert into Insurance_coverage (policy_id, expDate, maxAllowance_cents, company) values (7093, '2022-08-30', 570000, 'Pfeffer-Hodkiewicz');
insert into Insurance_coverage (policy_id, expDate, maxAllowance_cents, company) values (7266, '2020-10-06', 240000, 'Hoeger, Hodkiewicz and Osinski');
insert into Insurance_coverage (policy_id, expDate, maxAllowance_cents, company) values (7439, '2022-08-05', 700000, 'Koch and Sons');
insert into Insurance_coverage (policy_id, expDate, maxAllowance_cents, company) values (7612, '2022-02-23', 370000, 'Bosco-Kautzer');
insert into Insurance_coverage (policy_id, expDate, maxAllowance_cents, company) values (7785, '2023-01-07', 800000, 'Kohler Inc');
insert into Insurance_coverage (policy_id, expDate, maxAllowance_cents, company) values (7958, '2021-05-03', 130000, 'Balistreri LLC');
insert into Insurance_coverage (policy_id, expDate, maxAllowance_cents, company) values (8131, '2020-10-14', 370000, 'Olson and Sons');
insert into Insurance_coverage (policy_id, expDate, maxAllowance_cents, company) values (8304, '2024-02-25', 110000, 'O''Connell-Mills');
insert into Insurance_coverage (policy_id, expDate, maxAllowance_cents, company) values (8477, '2021-10-09', 220000, 'Schumm-Bradtke');
insert into Insurance_coverage (policy_id, expDate, maxAllowance_cents, company) values (8650, '2021-08-08', 960000, 'Schaefer LLC');
insert into Insurance_coverage (policy_id, expDate, maxAllowance_cents, company) values (8823, '2020-03-27', 660000, 'Bayer Group');
insert into Insurance_coverage (policy_id, expDate, maxAllowance_cents, company) values (8996, '2022-03-28', 910000, 'Reinger, Bailey and Weber');
insert into Insurance_coverage (policy_id, expDate, maxAllowance_cents, company) values (9169, '2020-06-17', 760000, 'Reilly, Simonis and Hansen');
insert into Insurance_coverage (policy_id, expDate, maxAllowance_cents, company) values (9342, '2020-12-26', 430000, 'Kris, Reichel and Corkery');
insert into Insurance_coverage (policy_id, expDate, maxAllowance_cents, company) values (9515, '2022-09-23', 570000, 'Gulgowski LLC');
insert into Insurance_coverage (policy_id, expDate, maxAllowance_cents, company) values (9688, '2024-07-09', 200000, 'Rath, Barton and Mraz');
insert into Insurance_coverage (policy_id, expDate, maxAllowance_cents, company) values (9861, '2019-04-17', 50000, 'Lehner Group');
insert into Insurance_coverage (policy_id, expDate, maxAllowance_cents, company) values (10034, '2023-11-19', 260000, 'Anderson Inc');
insert into Insurance_coverage (policy_id, expDate, maxAllowance_cents, company) values (10207, '2020-01-04', 760000, 'Prosacco-Zieme');
insert into Insurance_coverage (policy_id, expDate, maxAllowance_cents, company) values (10380, '2023-02-24', 430000, 'Kutch and Sons');
insert into Insurance_coverage (policy_id, expDate, maxAllowance_cents, company) values (10553, '2020-08-04', 360000, 'Grimes, Tromp and Kling');
insert into Insurance_coverage (policy_id, expDate, maxAllowance_cents, company) values (10726, '2020-03-07', 350000, 'Davis-Turcotte');
insert into Insurance_coverage (policy_id, expDate, maxAllowance_cents, company) values (10899, '2019-04-07', 920000, 'Koepp-MacGyver');
insert into Insurance_coverage (policy_id, expDate, maxAllowance_cents, company) values (11072, '2023-02-12', 310000, 'Rohan-Streich');
insert into Insurance_coverage (policy_id, expDate, maxAllowance_cents, company) values (11245, '2021-01-26', 110000, 'Roberts-Wisozk');
insert into Insurance_coverage (policy_id, expDate, maxAllowance_cents, company) values (11418, '2019-09-11', 170000, 'Dooley and Sons');
insert into Insurance_coverage (policy_id, expDate, maxAllowance_cents, company) values (11591, '2019-10-01', 940000, 'Bradtke, Christiansen and Hoppe');
insert into Insurance_coverage (policy_id, expDate, maxAllowance_cents, company) values (11764, '2021-09-19', 700000, 'Orn, Lynch and Huels');
insert into Insurance_coverage (policy_id, expDate, maxAllowance_cents, company) values (11937, '2019-06-19', 760000, 'Kulas-Gleason');
insert into Insurance_coverage (policy_id, expDate, maxAllowance_cents, company) values (12110, '2020-06-05', 660000, 'Schmidt, Fay and Bartell');
insert into Insurance_coverage (policy_id, expDate, maxAllowance_cents, company) values (12283, '2021-10-25', 820000, 'Bruen and Sons');
insert into Insurance_coverage (policy_id, expDate, maxAllowance_cents, company) values (12456, '2024-03-16', 700000, 'Brakus-Mann');
insert into Insurance_coverage (policy_id, expDate, maxAllowance_cents, company) values (12629, '2023-10-29', 350000, 'Lynch, Osinski and Hackett');
insert into Insurance_coverage (policy_id, expDate, maxAllowance_cents, company) values (12802, '2023-03-01', 790000, 'Hagenes-Moore');
insert into Insurance_coverage (policy_id, expDate, maxAllowance_cents, company) values (12975, '2020-06-25', 260000, 'Durgan-Klein');
insert into Insurance_coverage (policy_id, expDate, maxAllowance_cents, company) values (13148, '2024-02-02', 900000, 'Krajcik and Sons');
insert into Insurance_coverage (policy_id, expDate, maxAllowance_cents, company) values (13321, '2019-05-30', 150000, 'Rolfson-Gulgowski');
insert into Insurance_coverage (policy_id, expDate, maxAllowance_cents, company) values (13494, '2020-11-16', 910000, 'Mosciski-Welch');
insert into Insurance_coverage (policy_id, expDate, maxAllowance_cents, company) values (13667, '2021-01-19', 560000, 'Schneider LLC');
insert into Insurance_coverage (policy_id, expDate, maxAllowance_cents, company) values (13840, '2020-10-02', 830000, 'Schoen, Wisozk and Brekke');
insert into Insurance_coverage (policy_id, expDate, maxAllowance_cents, company) values (14013, '2020-03-25', 470000, 'West, Boyle and Reinger');
insert into Insurance_coverage (policy_id, expDate, maxAllowance_cents, company) values (14186, '2021-07-05', 150000, 'Pfannerstill, Hammes and Goodwin');
insert into Insurance_coverage (policy_id, expDate, maxAllowance_cents, company) values (14359, '2022-06-15', 90000, 'Hansen, Kemmer and Howell');
insert into Insurance_coverage (policy_id, expDate, maxAllowance_cents, company) values (14532, '2020-09-25', 710000, 'Barton Inc');
insert into Insurance_coverage (policy_id, expDate, maxAllowance_cents, company) values (14705, '2024-01-30', 270000, 'Schmeler, Terry and Davis');
insert into Insurance_coverage (policy_id, expDate, maxAllowance_cents, company) values (14878, '2020-03-24', 880000, 'Mosciski LLC');
insert into Insurance_coverage (policy_id, expDate, maxAllowance_cents, company) values (15051, '2024-06-13', 180000, 'Macejkovic LLC');
insert into Insurance_coverage (policy_id, expDate, maxAllowance_cents, company) values (15224, '2024-03-07', 280000, 'Streich-Kris');
insert into Insurance_coverage (policy_id, expDate, maxAllowance_cents, company) values (15397, '2020-01-08', 180000, 'Anderson, Borer and Effertz');
insert into Insurance_coverage (policy_id, expDate, maxAllowance_cents, company) values (15570, '2024-07-24', 270000, 'Senger, Kris and Carroll');
insert into Insurance_coverage (policy_id, expDate, maxAllowance_cents, company) values (15743, '2020-09-25', 400000, 'Waelchi-Morissette');
insert into Insurance_coverage (policy_id, expDate, maxAllowance_cents, company) values (15916, '2024-09-27', 140000, 'Roob-Stehr');
insert into Insurance_coverage (policy_id, expDate, maxAllowance_cents, company) values (16089, '2023-09-05', 880000, 'Pollich-Rogahn');
insert into Insurance_coverage (policy_id, expDate, maxAllowance_cents, company) values (16262, '2019-10-06', 1000000, 'Hagenes-Reynolds');
insert into Insurance_coverage (policy_id, expDate, maxAllowance_cents, company) values (16435, '2023-04-07', 390000, 'Schmeler-Stamm');
insert into Insurance_coverage (policy_id, expDate, maxAllowance_cents, company) values (16608, '2018-12-20', 570000, 'Rath-Heaney');
insert into Insurance_coverage (policy_id, expDate, maxAllowance_cents, company) values (16781, '2023-07-20', 460000, 'Roberts-Hartmann');
insert into Insurance_coverage (policy_id, expDate, maxAllowance_cents, company) values (16954, '2020-08-06', 870000, 'Macejkovic, O''Hara and Reichel');
insert into Insurance_coverage (policy_id, expDate, maxAllowance_cents, company) values (17127, '2019-09-02', 510000, 'Purdy, Stoltenberg and MacGyver');
insert into Insurance_coverage (policy_id, expDate, maxAllowance_cents, company) values (17300, '2018-12-24', 860000, 'Hermiston-Baumbach');
insert into Insurance_coverage (policy_id, expDate, maxAllowance_cents, company) values (17473, '2021-11-05', 460000, 'Ebert Inc');
insert into Insurance_coverage (policy_id, expDate, maxAllowance_cents, company) values (17646, '2023-08-24', 170000, 'Krajcik, Zieme and Sawayn');
insert into Insurance_coverage (policy_id, expDate, maxAllowance_cents, company) values (17819, '2022-06-09', 790000, 'Wuckert and Sons');
insert into Insurance_coverage (policy_id, expDate, maxAllowance_cents, company) values (17992, '2024-08-29', 790000, 'Torphy Inc');
insert into Insurance_coverage (policy_id, expDate, maxAllowance_cents, company) values (18165, '2022-10-12', 610000, 'Lang-Braun');
insert into Insurance_coverage (policy_id, expDate, maxAllowance_cents, company) values (18338, '2022-03-14', 760000, 'Mueller-Nolan');
insert into Insurance_coverage (policy_id, expDate, maxAllowance_cents, company) values (18511, '2024-06-15', 460000, 'Nader-Christiansen');
insert into Insurance_coverage (policy_id, expDate, maxAllowance_cents, company) values (18684, '2022-07-26', 570000, 'Leannon-Friesen');
insert into Insurance_coverage (policy_id, expDate, maxAllowance_cents, company) values (18857, '2022-02-25', 170000, 'Bogisich, Mosciski and McKenzie');
insert into Insurance_coverage (policy_id, expDate, maxAllowance_cents, company) values (19030, '2023-06-27', 50000, 'Effertz-Sanford');
insert into Insurance_coverage (policy_id, expDate, maxAllowance_cents, company) values (19203, '2020-02-03', 880000, 'Macejkovic-Rath');
insert into Insurance_coverage (policy_id, expDate, maxAllowance_cents, company) values (19376, '2024-06-14', 630000, 'Thiel-Gerhold');
insert into Insurance_coverage (policy_id, expDate, maxAllowance_cents, company) values (19549, '2019-02-12', 240000, 'Kihn-Grady');
insert into Insurance_coverage (policy_id, expDate, maxAllowance_cents, company) values (19722, '2024-05-25', 240000, 'Nader-Gibson');
insert into Insurance_coverage (policy_id, expDate, maxAllowance_cents, company) values (19895, '2021-07-18', 990000, 'Quitzon Inc');
insert into Insurance_coverage (policy_id, expDate, maxAllowance_cents, company) values (20068, '2021-02-18', 130000, 'Stehr Group');
insert into Insurance_coverage (policy_id, expDate, maxAllowance_cents, company) values (20241, '2022-07-25', 100000, 'Rosenbaum-Prosacco');
insert into Insurance_coverage (policy_id, expDate, maxAllowance_cents, company) values (20414, '2021-03-26', 450000, 'Cremin and Sons');
insert into Insurance_coverage (policy_id, expDate, maxAllowance_cents, company) values (20587, '2023-02-07', 710000, 'Labadie-Koss');
insert into Insurance_coverage (policy_id, expDate, maxAllowance_cents, company) values (20760, '2022-04-25', 450000, 'Klein Inc');
insert into Insurance_coverage (policy_id, expDate, maxAllowance_cents, company) values (20933, '2023-03-08', 90000, 'Will-Smitham');
insert into Insurance_coverage (policy_id, expDate, maxAllowance_cents, company) values (21106, '2021-12-10', 900000, 'Baumbach LLC');
insert into Insurance_coverage (policy_id, expDate, maxAllowance_cents, company) values (21279, '2020-09-08', 60000, 'McClure-Goyette');
insert into Insurance_coverage (policy_id, expDate, maxAllowance_cents, company) values (21452, '2020-10-03', 880000, 'Tromp, Metz and Langosh');
insert into Insurance_coverage (policy_id, expDate, maxAllowance_cents, company) values (21625, '2023-01-05', 680000, 'Thompson and Sons');
insert into Insurance_coverage (policy_id, expDate, maxAllowance_cents, company) values (21798, '2021-10-24', 340000, 'Hermiston, Okuneva and Zieme');
insert into Insurance_coverage (policy_id, expDate, maxAllowance_cents, company) values (21971, '2024-08-10', 290000, 'Hyatt Group');
insert into Insurance_coverage (policy_id, expDate, maxAllowance_cents, company) values (22144, '2023-03-14', 980000, 'Terry, Dicki and Schowalter');
insert into Insurance_coverage (policy_id, expDate, maxAllowance_cents, company) values (22317, '2020-08-20', 830000, 'Kunde-Herzog');
insert into Insurance_coverage (policy_id, expDate, maxAllowance_cents, company) values (22490, '2023-03-11', 990000, 'Block, Kohler and Bayer');
insert into Insurance_coverage (policy_id, expDate, maxAllowance_cents, company) values (22663, '2021-04-18', 560000, 'Heaney-Harris');
insert into Insurance_coverage (policy_id, expDate, maxAllowance_cents, company) values (22836, '2020-10-11', 810000, 'Bergstrom LLC');
insert into Insurance_coverage (policy_id, expDate, maxAllowance_cents, company) values (23009, '2021-01-27', 870000, 'White, Gleichner and Strosin');
insert into Insurance_coverage (policy_id, expDate, maxAllowance_cents, company) values (23182, '2020-12-30', 830000, 'Schiller and Sons');
insert into Insurance_coverage (policy_id, expDate, maxAllowance_cents, company) values (23355, '2022-05-12', 270000, 'Grimes and Sons');
insert into Insurance_coverage (policy_id, expDate, maxAllowance_cents, company) values (23528, '2019-06-19', 580000, 'Morissette, Miller and VonRueden');
insert into Insurance_coverage (policy_id, expDate, maxAllowance_cents, company) values (23701, '2023-04-17', 540000, 'Jenkins-Terry');
insert into Insurance_coverage (policy_id, expDate, maxAllowance_cents, company) values (23874, '2022-03-23', 670000, 'Connelly-Lueilwitz');
insert into Insurance_coverage (policy_id, expDate, maxAllowance_cents, company) values (24047, '2020-06-05', 50000, 'Glover Inc');
insert into Insurance_coverage (policy_id, expDate, maxAllowance_cents, company) values (24220, '2020-07-16', 640000, 'Dicki and Sons');
insert into Insurance_coverage (policy_id, expDate, maxAllowance_cents, company) values (24393, '2022-05-02', 420000, 'Bergstrom-Lehner');
insert into Insurance_coverage (policy_id, expDate, maxAllowance_cents, company) values (24566, '2024-08-24', 440000, 'Schaefer-Kreiger');
insert into Insurance_coverage (policy_id, expDate, maxAllowance_cents, company) values (24739, '2024-06-11', 810000, 'Schneider, McCullough and Ryan');
insert into Insurance_coverage (policy_id, expDate, maxAllowance_cents, company) values (24912, '2019-11-28', 470000, 'D''Amore and Sons');
insert into Insurance_coverage (policy_id, expDate, maxAllowance_cents, company) values (25085, '2020-02-10', 890000, 'Jaskolski, Smith and Gleichner');
insert into Insurance_coverage (policy_id, expDate, maxAllowance_cents, company) values (25258, '2020-04-26', 930000, 'Harvey, Nolan and Will');
insert into Insurance_coverage (policy_id, expDate, maxAllowance_cents, company) values (25431, '2020-09-16', 520000, 'Dicki, Rau and Lakin');
insert into Insurance_coverage (policy_id, expDate, maxAllowance_cents, company) values (25604, '2022-11-30', 80000, 'Swift-Emard');
insert into Insurance_coverage (policy_id, expDate, maxAllowance_cents, company) values (25777, '2020-06-20', 580000, 'Dicki Group');
insert into Insurance_coverage (policy_id, expDate, maxAllowance_cents, company) values (25950, '2022-03-18', 290000, 'Heaney, Spinka and Jast');
insert into Insurance_coverage (policy_id, expDate, maxAllowance_cents, company) values (26123, '2024-02-25', 980000, 'Keebler-Hermiston');
insert into Insurance_coverage (policy_id, expDate, maxAllowance_cents, company) values (26296, '2024-04-10', 120000, 'Beatty-Bogan');
insert into Insurance_coverage (policy_id, expDate, maxAllowance_cents, company) values (26469, '2023-07-27', 960000, 'Hilll and Sons');
insert into Insurance_coverage (policy_id, expDate, maxAllowance_cents, company) values (26642, '2024-03-12', 950000, 'Nitzsche, Kreiger and Mohr');
insert into Insurance_coverage (policy_id, expDate, maxAllowance_cents, company) values (26815, '2024-09-03', 380000, 'Marks-Berge');
insert into Insurance_coverage (policy_id, expDate, maxAllowance_cents, company) values (26988, '2022-05-14', 950000, 'Kovacek Group');
insert into Insurance_coverage (policy_id, expDate, maxAllowance_cents, company) values (27161, '2024-01-21', 50000, 'Lockman, Lebsack and Dare');
insert into Insurance_coverage (policy_id, expDate, maxAllowance_cents, company) values (27334, '2019-10-17', 630000, 'Hills-Koss');
insert into Insurance_coverage (policy_id, expDate, maxAllowance_cents, company) values (27507, '2023-07-28', 480000, 'Krajcik-Brakus');
insert into Insurance_coverage (policy_id, expDate, maxAllowance_cents, company) values (27680, '2022-06-02', 890000, 'Rosenbaum, Rippin and Hickle');
insert into Insurance_coverage (policy_id, expDate, maxAllowance_cents, company) values (27853, '2022-04-19', 810000, 'Lueilwitz-Miller');
insert into Insurance_coverage (policy_id, expDate, maxAllowance_cents, company) values (28026, '2023-04-26', 920000, 'Graham LLC');
insert into Insurance_coverage (policy_id, expDate, maxAllowance_cents, company) values (28199, '2018-12-11', 670000, 'D''Amore and Sons');
insert into Insurance_coverage (policy_id, expDate, maxAllowance_cents, company) values (28372, '2024-08-13', 320000, 'Gerlach and Sons');
insert into Insurance_coverage (policy_id, expDate, maxAllowance_cents, company) values (28545, '2023-11-12', 900000, 'Bosco, Orn and Rodriguez');
insert into Insurance_coverage (policy_id, expDate, maxAllowance_cents, company) values (28718, '2023-04-08', 580000, 'Feil-Orn');
insert into Insurance_coverage (policy_id, expDate, maxAllowance_cents, company) values (28891, '2023-07-24', 440000, 'Kuhn, Schneider and Kerluke');
insert into Insurance_coverage (policy_id, expDate, maxAllowance_cents, company) values (29064, '2023-08-01', 690000, 'Ward LLC');
insert into Insurance_coverage (policy_id, expDate, maxAllowance_cents, company) values (29237, '2021-09-18', 570000, 'Heidenreich, Steuber and Klein');
insert into Insurance_coverage (policy_id, expDate, maxAllowance_cents, company) values (29410, '2023-07-30', 100000, 'Halvorson and Sons');
insert into Insurance_coverage (policy_id, expDate, maxAllowance_cents, company) values (29583, '2021-04-06', 660000, 'Walker, Eichmann and Nicolas');
insert into Insurance_coverage (policy_id, expDate, maxAllowance_cents, company) values (29756, '2023-03-20', 780000, 'Kozey-Ruecker');
insert into Insurance_coverage (policy_id, expDate, maxAllowance_cents, company) values (29929, '2022-03-14', 610000, 'Balistreri-Wisoky');
insert into Insurance_coverage (policy_id, expDate, maxAllowance_cents, company) values (30102, '2019-03-21', 800000, 'Marquardt-Trantow');
insert into Insurance_coverage (policy_id, expDate, maxAllowance_cents, company) values (30275, '2019-06-08', 430000, 'McDermott, Klocko and Ruecker');
insert into Insurance_coverage (policy_id, expDate, maxAllowance_cents, company) values (30448, '2022-08-01', 720000, 'Senger Group');
insert into Insurance_coverage (policy_id, expDate, maxAllowance_cents, company) values (30621, '2022-12-25', 940000, 'Hermiston-Smitham');
insert into Insurance_coverage (policy_id, expDate, maxAllowance_cents, company) values (30794, '2019-07-23', 120000, 'Williamson LLC');
insert into Insurance_coverage (policy_id, expDate, maxAllowance_cents, company) values (30967, '2024-07-23', 860000, 'Greenfelder, Graham and Beatty');
insert into Insurance_coverage (policy_id, expDate, maxAllowance_cents, company) values (31140, '2020-02-12', 120000, 'Kemmer LLC');
insert into Insurance_coverage (policy_id, expDate, maxAllowance_cents, company) values (31313, '2024-05-27', 130000, 'Spinka, Ankunding and Glover');
insert into Insurance_coverage (policy_id, expDate, maxAllowance_cents, company) values (31486, '2024-06-09', 1000000, 'Toy Inc');
insert into Insurance_coverage (policy_id, expDate, maxAllowance_cents, company) values (31659, '2020-08-02', 850000, 'Ziemann Group');
insert into Insurance_coverage (policy_id, expDate, maxAllowance_cents, company) values (31832, '2021-05-03', 390000, 'Dach, Daniel and Kuhlman');
insert into Insurance_coverage (policy_id, expDate, maxAllowance_cents, company) values (32005, '2023-01-01', 520000, 'Boyer, Blanda and Wunsch');
insert into Insurance_coverage (policy_id, expDate, maxAllowance_cents, company) values (32178, '2021-05-19', 590000, 'Gulgowski-Auer');
insert into Insurance_coverage (policy_id, expDate, maxAllowance_cents, company) values (32351, '2020-02-04', 180000, 'Jakubowski Inc');
insert into Insurance_coverage (policy_id, expDate, maxAllowance_cents, company) values (32524, '2023-09-13', 650000, 'Collins, Rowe and Moore');
insert into Insurance_coverage (policy_id, expDate, maxAllowance_cents, company) values (32697, '2022-05-02', 240000, 'Rath-Hermiston');
insert into Insurance_coverage (policy_id, expDate, maxAllowance_cents, company) values (32870, '2020-10-31', 50000, 'Lebsack LLC');
insert into Insurance_coverage (policy_id, expDate, maxAllowance_cents, company) values (33043, '2020-07-04', 980000, 'Zemlak Group');
insert into Insurance_coverage (policy_id, expDate, maxAllowance_cents, company) values (33216, '2020-07-12', 860000, 'Frami-Gulgowski');
insert into Insurance_coverage (policy_id, expDate, maxAllowance_cents, company) values (33389, '2019-06-17', 970000, 'Crooks-Dickinson');
insert into Insurance_coverage (policy_id, expDate, maxAllowance_cents, company) values (33562, '2022-11-13', 830000, 'Renner and Sons');
insert into Insurance_coverage (policy_id, expDate, maxAllowance_cents, company) values (33735, '2021-01-08', 660000, 'Eichmann, Koch and Brekke');
insert into Insurance_coverage (policy_id, expDate, maxAllowance_cents, company) values (33908, '2022-06-03', 930000, 'Baumbach and Sons');
insert into Insurance_coverage (policy_id, expDate, maxAllowance_cents, company) values (34081, '2022-09-25', 430000, 'Schuppe and Sons');
insert into Insurance_coverage (policy_id, expDate, maxAllowance_cents, company) values (34254, '2024-07-26', 300000, 'Paucek-Kohler');
insert into Insurance_coverage (policy_id, expDate, maxAllowance_cents, company) values (34427, '2019-10-27', 890000, 'Bins Inc');
insert into Insurance_coverage (policy_id, expDate, maxAllowance_cents, company) values (34600, '2021-12-02', 100000, 'Kertzmann Inc');
insert into Insurance_coverage (policy_id, expDate, maxAllowance_cents, company) values (34773, '2022-08-07', 830000, 'Yost, Sanford and Bernier');
insert into Insurance_coverage (policy_id, expDate, maxAllowance_cents, company) values (34946, '2021-03-26', 580000, 'Hane-Schuppe');
insert into Insurance_coverage (policy_id, expDate, maxAllowance_cents, company) values (35119, '2024-02-05', 120000, 'Schmeler Group');
insert into Insurance_coverage (policy_id, expDate, maxAllowance_cents, company) values (35292, '2021-03-25', 890000, 'Cole-Kub');
insert into Insurance_coverage (policy_id, expDate, maxAllowance_cents, company) values (35465, '2019-03-21', 600000, 'Cassin-Corwin');
insert into Insurance_coverage (policy_id, expDate, maxAllowance_cents, company) values (35638, '2022-09-30', 90000, 'Tremblay, Sanford and Zulauf');
insert into Insurance_coverage (policy_id, expDate, maxAllowance_cents, company) values (35811, '2019-05-01', 810000, 'Kirlin-Feeney');
insert into Insurance_coverage (policy_id, expDate, maxAllowance_cents, company) values (35984, '2023-06-17', 740000, 'Yost-Christiansen');
insert into Insurance_coverage (policy_id, expDate, maxAllowance_cents, company) values (36157, '2021-09-11', 520000, 'Beer-Emard');
insert into Insurance_coverage (policy_id, expDate, maxAllowance_cents, company) values (36330, '2019-01-09', 770000, 'Wiegand-Ferry');
insert into Insurance_coverage (policy_id, expDate, maxAllowance_cents, company) values (36503, '2024-03-05', 90000, 'Nikolaus, MacGyver and Hammes');
insert into Insurance_coverage (policy_id, expDate, maxAllowance_cents, company) values (36676, '2019-12-06', 50000, 'MacGyver, Lesch and Stokes');
insert into Insurance_coverage (policy_id, expDate, maxAllowance_cents, company) values (36849, '2020-01-06', 900000, 'Homenick Group');
insert into Insurance_coverage (policy_id, expDate, maxAllowance_cents, company) values (37022, '2021-12-25', 50000, 'Kunze, Hilll and Kertzmann');
insert into Insurance_coverage (policy_id, expDate, maxAllowance_cents, company) values (37195, '2023-09-17', 880000, 'Beahan Inc');
insert into Insurance_coverage (policy_id, expDate, maxAllowance_cents, company) values (37368, '2023-07-24', 600000, 'Bechtelar-Ullrich');
insert into Insurance_coverage (policy_id, expDate, maxAllowance_cents, company) values (37541, '2022-05-21', 640000, 'Huels Inc');
insert into Insurance_coverage (policy_id, expDate, maxAllowance_cents, company) values (37714, '2024-06-02', 860000, 'Zieme, Moen and Shields');
insert into Insurance_coverage (policy_id, expDate, maxAllowance_cents, company) values (37887, '2022-03-29', 850000, 'Funk, Heathcote and Auer');
insert into Insurance_coverage (policy_id, expDate, maxAllowance_cents, company) values (38060, '2022-11-17', 860000, 'Eichmann-Cole');
insert into Insurance_coverage (policy_id, expDate, maxAllowance_cents, company) values (38233, '2022-07-16', 810000, 'Bins-Bartoletti');
insert into Insurance_coverage (policy_id, expDate, maxAllowance_cents, company) values (38406, '2022-02-24', 830000, 'Walter Inc');
insert into Insurance_coverage (policy_id, expDate, maxAllowance_cents, company) values (38579, '2020-12-08', 660000, 'Prosacco, Orn and Barton');
insert into Insurance_coverage (policy_id, expDate, maxAllowance_cents, company) values (38752, '2023-05-27', 990000, 'Upton, Mitchell and Boyer');
insert into Insurance_coverage (policy_id, expDate, maxAllowance_cents, company) values (38925, '2023-03-09', 540000, 'Daugherty-Swift');
insert into Insurance_coverage (policy_id, expDate, maxAllowance_cents, company) values (39098, '2024-11-05', 690000, 'Crooks, Brown and Weimann');
insert into Insurance_coverage (policy_id, expDate, maxAllowance_cents, company) values (39271, '2019-11-01', 640000, 'Kris-Crona');
insert into Insurance_coverage (policy_id, expDate, maxAllowance_cents, company) values (39444, '2023-06-01', 940000, 'Klein LLC');
insert into Insurance_coverage (policy_id, expDate, maxAllowance_cents, company) values (39617, '2022-09-22', 640000, 'Bradtke Inc');
insert into Insurance_coverage (policy_id, expDate, maxAllowance_cents, company) values (39790, '2022-04-03', 380000, 'Muller Group');
insert into Insurance_coverage (policy_id, expDate, maxAllowance_cents, company) values (39963, '2020-12-18', 330000, 'Hahn, Larkin and Swift');
insert into Insurance_coverage (policy_id, expDate, maxAllowance_cents, company) values (40136, '2024-05-15', 870000, 'Dooley, Reynolds and Ankunding');
insert into Insurance_coverage (policy_id, expDate, maxAllowance_cents, company) values (40309, '2020-11-14', 800000, 'Larkin, Kemmer and Stokes');
insert into Insurance_coverage (policy_id, expDate, maxAllowance_cents, company) values (40482, '2020-09-02', 390000, 'Nolan Inc');
insert into Insurance_coverage (policy_id, expDate, maxAllowance_cents, company) values (40655, '2023-09-17', 530000, 'Kilback and Sons');
insert into Insurance_coverage (policy_id, expDate, maxAllowance_cents, company) values (40828, '2019-03-02', 1000000, 'Ward, Carter and Grant');
insert into Insurance_coverage (policy_id, expDate, maxAllowance_cents, company) values (41001, '2020-01-21', 990000, 'Lynch, Hane and Kemmer');
insert into Insurance_coverage (policy_id, expDate, maxAllowance_cents, company) values (41174, '2023-05-18', 320000, 'Leffler-Orn');
insert into Insurance_coverage (policy_id, expDate, maxAllowance_cents, company) values (41347, '2019-07-29', 480000, 'Langworth-Keebler');
insert into Insurance_coverage (policy_id, expDate, maxAllowance_cents, company) values (41520, '2024-01-12', 580000, 'Pfeffer-Schaefer');
insert into Insurance_coverage (policy_id, expDate, maxAllowance_cents, company) values (41693, '2024-06-30', 790000, 'Lakin LLC');
insert into Insurance_coverage (policy_id, expDate, maxAllowance_cents, company) values (41866, '2022-08-22', 550000, 'Roob Inc');
insert into Insurance_coverage (policy_id, expDate, maxAllowance_cents, company) values (42039, '2019-09-20', 160000, 'Frami LLC');
insert into Insurance_coverage (policy_id, expDate, maxAllowance_cents, company) values (42212, '2020-08-01', 420000, 'Balistreri LLC');
insert into Insurance_coverage (policy_id, expDate, maxAllowance_cents, company) values (42385, '2020-03-06', 50000, 'Purdy-Spencer');
insert into Insurance_coverage (policy_id, expDate, maxAllowance_cents, company) values (42558, '2023-03-04', 570000, 'Zemlak and Sons');
insert into Insurance_coverage (policy_id, expDate, maxAllowance_cents, company) values (42731, '2024-05-27', 620000, 'Marvin Group');
insert into Insurance_coverage (policy_id, expDate, maxAllowance_cents, company) values (42904, '2021-12-27', 780000, 'Crona-Donnelly');
insert into Insurance_coverage (policy_id, expDate, maxAllowance_cents, company) values (43077, '2019-09-15', 990000, 'Hand Group');

insert into Customer (customer_id, name, phone_number, insurance_policy_id) values (0, 'Norma Russell', '84-(443)348-6440', 0);
insert into Customer (customer_id, name, phone_number, insurance_policy_id) values (1, 'Mark Pierce', '34-(184)830-1409', 173);
insert into Customer (customer_id, name, phone_number, insurance_policy_id) values (2, 'Catherine Murphy', '48-(173)935-6887', 346);
insert into Customer (customer_id, name, phone_number, insurance_policy_id) values (3, 'Carol Gonzales', '509-(117)937-6849', 519);
insert into Customer (customer_id, name, phone_number, insurance_policy_id) values (4, 'Randy Webb', '351-(611)211-2726', 692);
insert into Customer (customer_id, name, phone_number, insurance_policy_id) values (5, 'Christina Harris', '63-(401)732-8760', 865);
insert into Customer (customer_id, name, phone_number, insurance_policy_id) values (6, 'Anne Sanders', '52-(992)874-1648', 1038);
insert into Customer (customer_id, name, phone_number, insurance_policy_id) values (7, 'Ruby Graham', '92-(753)152-1440', 1211);
insert into Customer (customer_id, name, phone_number, insurance_policy_id) values (8, 'Frank Coleman', '63-(811)375-9222', 1384);
insert into Customer (customer_id, name, phone_number, insurance_policy_id) values (9, 'Mark Edwards', '81-(252)238-1065', 1557);
insert into Customer (customer_id, name, phone_number, insurance_policy_id) values (10, 'Samuel Simmons', '62-(890)233-6027', 1730);
insert into Customer (customer_id, name, phone_number, insurance_policy_id) values (11, 'Heather Mendoza', '63-(839)265-4837', 1903);
insert into Customer (customer_id, name, phone_number, insurance_policy_id) values (12, 'Wayne Vasquez', '355-(328)426-3523', 2076);
insert into Customer (customer_id, name, phone_number, insurance_policy_id) values (13, 'Christine Murphy', '257-(301)621-9617', 2249);
insert into Customer (customer_id, name, phone_number, insurance_policy_id) values (14, 'Deborah Austin', '7-(349)359-3366', 2422);
insert into Customer (customer_id, name, phone_number, insurance_policy_id) values (15, 'Jacqueline Price', '55-(304)678-8973', 2595);
insert into Customer (customer_id, name, phone_number, insurance_policy_id) values (16, 'Alan Rice', '52-(724)726-3016', 2768);
insert into Customer (customer_id, name, phone_number, insurance_policy_id) values (17, 'Denise Schmidt', '46-(528)674-9262', 2941);
insert into Customer (customer_id, name, phone_number, insurance_policy_id) values (18, 'Michelle King', '86-(317)323-9888', 3114);
insert into Customer (customer_id, name, phone_number, insurance_policy_id) values (19, 'Roger Hayes', '33-(856)952-1061', 3287);
insert into Customer (customer_id, name, phone_number, insurance_policy_id) values (20, 'Craig Mason', '86-(541)883-3899', 3460);
insert into Customer (customer_id, name, phone_number, insurance_policy_id) values (21, 'Ashley Kennedy', '62-(861)661-7876', 3633);
insert into Customer (customer_id, name, phone_number, insurance_policy_id) values (22, 'Craig Arnold', '1-(198)718-4631', 3806);
insert into Customer (customer_id, name, phone_number, insurance_policy_id) values (23, 'Sandra Wells', '86-(563)550-6131', 3979);
insert into Customer (customer_id, name, phone_number, insurance_policy_id) values (24, 'Timothy Banks', '86-(557)777-8330', 4152);
insert into Customer (customer_id, name, phone_number, insurance_policy_id) values (25, 'Joseph Bennett', '62-(208)266-1465', 4325);
insert into Customer (customer_id, name, phone_number, insurance_policy_id) values (26, 'Christina Peterson', '46-(138)183-4552', 4498);
insert into Customer (customer_id, name, phone_number, insurance_policy_id) values (27, 'Jeffrey Hamilton', '86-(610)191-9817', 4671);
insert into Customer (customer_id, name, phone_number, insurance_policy_id) values (28, 'Amy Riley', '420-(368)693-0283', 4844);
insert into Customer (customer_id, name, phone_number, insurance_policy_id) values (29, 'Robert Dean', '420-(827)344-0224', 5017);
insert into Customer (customer_id, name, phone_number, insurance_policy_id) values (30, 'Russell Stewart', '7-(571)426-4708', 5190);
insert into Customer (customer_id, name, phone_number, insurance_policy_id) values (31, 'Lawrence Porter', '7-(217)841-4446', 5363);
insert into Customer (customer_id, name, phone_number, insurance_policy_id) values (32, 'Russell Ross', '48-(931)204-9479', 5536);
insert into Customer (customer_id, name, phone_number, insurance_policy_id) values (33, 'Adam Cooper', '1-(630)722-6150', 5709);
insert into Customer (customer_id, name, phone_number, insurance_policy_id) values (34, 'Douglas Coleman', '52-(840)832-3817', 5882);
insert into Customer (customer_id, name, phone_number, insurance_policy_id) values (35, 'Nancy West', '33-(925)981-1910', 6055);
insert into Customer (customer_id, name, phone_number, insurance_policy_id) values (36, 'Melissa Hill', '7-(315)618-8350', 6228);
insert into Customer (customer_id, name, phone_number, insurance_policy_id) values (37, 'Barbara Schmidt', '86-(607)246-5608', 6401);
insert into Customer (customer_id, name, phone_number, insurance_policy_id) values (38, 'Katherine Edwards', '86-(921)983-7769', 6574);
insert into Customer (customer_id, name, phone_number, insurance_policy_id) values (39, 'Roy Howell', '62-(964)573-9190', 6747);
insert into Customer (customer_id, name, phone_number, insurance_policy_id) values (40, 'Ryan Simmons', '269-(916)485-6258', 6920);
insert into Customer (customer_id, name, phone_number, insurance_policy_id) values (41, 'Nicole Chapman', '86-(441)627-7548', 7093);
insert into Customer (customer_id, name, phone_number, insurance_policy_id) values (42, 'Edward Martin', '86-(783)756-9263', 7266);
insert into Customer (customer_id, name, phone_number, insurance_policy_id) values (43, 'Alice Alvarez', '351-(379)530-8664', 7439);
insert into Customer (customer_id, name, phone_number, insurance_policy_id) values (44, 'Earl Greene', '355-(218)449-0925', 7612);
insert into Customer (customer_id, name, phone_number, insurance_policy_id) values (45, 'Sean George', '86-(780)116-4666', 7785);
insert into Customer (customer_id, name, phone_number, insurance_policy_id) values (46, 'Judy Flores', '420-(298)863-4631', 7958);
insert into Customer (customer_id, name, phone_number, insurance_policy_id) values (47, 'Susan Carter', '223-(479)832-5382', 8131);
insert into Customer (customer_id, name, phone_number, insurance_policy_id) values (48, 'Mary Harvey', '234-(761)492-5254', 8304);
insert into Customer (customer_id, name, phone_number, insurance_policy_id) values (49, 'Christopher Wheeler', '351-(918)914-2899', 8477);
insert into Customer (customer_id, name, phone_number, insurance_policy_id) values (50, 'Judith Russell', '55-(934)703-7789', 8650);
insert into Customer (customer_id, name, phone_number, insurance_policy_id) values (51, 'Louise Taylor', '62-(178)611-8762', 8823);
insert into Customer (customer_id, name, phone_number, insurance_policy_id) values (52, 'Brian Graham', '86-(306)627-1416', 8996);
insert into Customer (customer_id, name, phone_number, insurance_policy_id) values (53, 'Jane Morrison', '355-(850)539-8989', 9169);
insert into Customer (customer_id, name, phone_number, insurance_policy_id) values (54, 'Katherine Medina', '507-(273)971-7266', 9342);
insert into Customer (customer_id, name, phone_number, insurance_policy_id) values (55, 'Lois Arnold', '86-(101)520-1067', 9515);
insert into Customer (customer_id, name, phone_number, insurance_policy_id) values (56, 'Ernest Moore', '44-(928)517-2604', 9688);
insert into Customer (customer_id, name, phone_number, insurance_policy_id) values (57, 'Amy Owens', '351-(935)485-3398', 9861);
insert into Customer (customer_id, name, phone_number, insurance_policy_id) values (58, 'Arthur White', '62-(142)636-6799', 10034);
insert into Customer (customer_id, name, phone_number, insurance_policy_id) values (59, 'Carol Robertson', '86-(573)805-7922', 10207);
insert into Customer (customer_id, name, phone_number, insurance_policy_id) values (60, 'Marilyn Peterson', '55-(702)937-7110', 10380);
insert into Customer (customer_id, name, phone_number, insurance_policy_id) values (61, 'Lois Martin', '48-(733)456-2487', 10553);
insert into Customer (customer_id, name, phone_number, insurance_policy_id) values (62, 'Randy Morrison', '62-(373)802-0931', 10726);
insert into Customer (customer_id, name, phone_number, insurance_policy_id) values (63, 'Michelle Bailey', '33-(151)774-3439', 10899);
insert into Customer (customer_id, name, phone_number, insurance_policy_id) values (64, 'Keith Harper', '420-(408)549-5108', 11072);
insert into Customer (customer_id, name, phone_number, insurance_policy_id) values (65, 'Carolyn Arnold', '48-(995)279-5146', 11245);
insert into Customer (customer_id, name, phone_number, insurance_policy_id) values (66, 'Doris Graham', '63-(732)195-2172', 11418);
insert into Customer (customer_id, name, phone_number, insurance_policy_id) values (67, 'Frank Reed', '95-(433)883-5050', 11591);
insert into Customer (customer_id, name, phone_number, insurance_policy_id) values (68, 'Antonio Kelly', '967-(993)926-0630', 11764);
insert into Customer (customer_id, name, phone_number, insurance_policy_id) values (69, 'Phyllis Arnold', '48-(402)763-3172', 11937);
insert into Customer (customer_id, name, phone_number, insurance_policy_id) values (70, 'Ruby Burton', '86-(633)935-6028', 12110);
insert into Customer (customer_id, name, phone_number, insurance_policy_id) values (71, 'Melissa Martin', '60-(221)929-4741', 12283);
insert into Customer (customer_id, name, phone_number, insurance_policy_id) values (72, 'Richard Shaw', '1-(926)879-8953', 12456);
insert into Customer (customer_id, name, phone_number, insurance_policy_id) values (73, 'Stephen Montgomery', '56-(176)295-5367', 12629);
insert into Customer (customer_id, name, phone_number, insurance_policy_id) values (74, 'Jennifer Ryan', '380-(746)489-9349', 12802);
insert into Customer (customer_id, name, phone_number, insurance_policy_id) values (75, 'Theresa Bowman', '62-(511)178-8867', 12975);
insert into Customer (customer_id, name, phone_number, insurance_policy_id) values (76, 'Carl Martinez', '351-(649)934-7646', 13148);
insert into Customer (customer_id, name, phone_number, insurance_policy_id) values (77, 'Rebecca Sanders', '62-(648)445-5952', 13321);
insert into Customer (customer_id, name, phone_number, insurance_policy_id) values (78, 'Catherine Watkins', '63-(584)852-7665', 13494);
insert into Customer (customer_id, name, phone_number, insurance_policy_id) values (79, 'Phyllis Owens', '86-(994)514-4489', 13667);
insert into Customer (customer_id, name, phone_number, insurance_policy_id) values (80, 'John Morgan', '62-(285)972-7925', 13840);
insert into Customer (customer_id, name, phone_number, insurance_policy_id) values (81, 'Wayne Sanders', '62-(732)973-7213', 14013);
insert into Customer (customer_id, name, phone_number, insurance_policy_id) values (82, 'Jean Moore', '976-(325)230-4779', 14186);
insert into Customer (customer_id, name, phone_number, insurance_policy_id) values (83, 'Alice Bennett', '1-(605)993-0543', 14359);
insert into Customer (customer_id, name, phone_number, insurance_policy_id) values (84, 'Julie Simmons', '62-(511)946-2555', 14532);
insert into Customer (customer_id, name, phone_number, insurance_policy_id) values (85, 'Jesse Davis', '86-(748)951-4173', 14705);
insert into Customer (customer_id, name, phone_number, insurance_policy_id) values (86, 'Roger Henderson', '373-(676)820-0903', 14878);
insert into Customer (customer_id, name, phone_number, insurance_policy_id) values (87, 'Julia Moreno', '86-(302)582-1096', 15051);
insert into Customer (customer_id, name, phone_number, insurance_policy_id) values (88, 'Wanda Collins', '55-(386)974-5352', 15224);
insert into Customer (customer_id, name, phone_number, insurance_policy_id) values (89, 'Terry Young', '62-(717)604-8208', 15397);
insert into Customer (customer_id, name, phone_number, insurance_policy_id) values (90, 'Denise Alvarez', '86-(666)937-3670', 15570);
insert into Customer (customer_id, name, phone_number, insurance_policy_id) values (91, 'Brandon Howard', '86-(961)677-6378', 15743);
insert into Customer (customer_id, name, phone_number, insurance_policy_id) values (92, 'James Mason', '48-(979)262-5398', 15916);
insert into Customer (customer_id, name, phone_number, insurance_policy_id) values (93, 'Anna Schmidt', '81-(469)218-5355', 16089);
insert into Customer (customer_id, name, phone_number, insurance_policy_id) values (94, 'Nicole Jenkins', '55-(171)156-0675', 16262);
insert into Customer (customer_id, name, phone_number, insurance_policy_id) values (95, 'Christopher Morrison', '62-(726)728-6713', 16435);
insert into Customer (customer_id, name, phone_number, insurance_policy_id) values (96, 'Cheryl Reed', '86-(310)941-3318', 16608);
insert into Customer (customer_id, name, phone_number, insurance_policy_id) values (97, 'Phillip Rodriguez', '235-(977)621-8287', 16781);
insert into Customer (customer_id, name, phone_number, insurance_policy_id) values (98, 'Harry Carpenter', '1-(214)137-5804', 16954);
insert into Customer (customer_id, name, phone_number, insurance_policy_id) values (99, 'Elizabeth Hanson', '7-(676)682-5170', 17127);
insert into Customer (customer_id, name, phone_number, insurance_policy_id) values (100, 'Julia Williamson', '84-(240)352-3221', 17300);
insert into Customer (customer_id, name, phone_number, insurance_policy_id) values (101, 'Martin Wallace', '62-(675)196-4943', 17473);
insert into Customer (customer_id, name, phone_number, insurance_policy_id) values (102, 'Lillian Garza', '264-(833)311-5945', 17646);
insert into Customer (customer_id, name, phone_number, insurance_policy_id) values (103, 'Helen Marshall', '48-(678)179-2790', 17819);
insert into Customer (customer_id, name, phone_number, insurance_policy_id) values (104, 'Andrew Elliott', '351-(286)837-8690', 17992);
insert into Customer (customer_id, name, phone_number, insurance_policy_id) values (105, 'Donald Cunningham', '33-(942)196-9190', 18165);
insert into Customer (customer_id, name, phone_number, insurance_policy_id) values (106, 'Stephen Montgomery', '92-(394)839-6486', 18338);
insert into Customer (customer_id, name, phone_number, insurance_policy_id) values (107, 'Sara Meyer', '501-(773)888-6255', 18511);
insert into Customer (customer_id, name, phone_number, insurance_policy_id) values (108, 'Wanda Diaz', '351-(907)706-5258', 18684);
insert into Customer (customer_id, name, phone_number, insurance_policy_id) values (109, 'Ernest Carter', '63-(846)410-8911', 18857);
insert into Customer (customer_id, name, phone_number, insurance_policy_id) values (110, 'Cynthia Barnes', '998-(239)249-9794', 19030);
insert into Customer (customer_id, name, phone_number, insurance_policy_id) values (111, 'Ann Shaw', '55-(863)138-6118', 19203);
insert into Customer (customer_id, name, phone_number, insurance_policy_id) values (112, 'Wanda Wells', '86-(327)190-2015', 19376);
insert into Customer (customer_id, name, phone_number, insurance_policy_id) values (113, 'Susan Reynolds', '63-(871)163-2261', 19549);
insert into Customer (customer_id, name, phone_number, insurance_policy_id) values (114, 'Brandon Lawrence', '66-(301)388-5889', 19722);
insert into Customer (customer_id, name, phone_number, insurance_policy_id) values (115, 'Lois Baker', '86-(458)231-1246', 19895);
insert into Customer (customer_id, name, phone_number, insurance_policy_id) values (116, 'Douglas Rivera', '1-(781)868-9830', 20068);
insert into Customer (customer_id, name, phone_number, insurance_policy_id) values (117, 'Stephanie Thompson', '7-(626)470-2919', 20241);
insert into Customer (customer_id, name, phone_number, insurance_policy_id) values (118, 'Judith Harrison', '33-(689)574-7899', 20414);
insert into Customer (customer_id, name, phone_number, insurance_policy_id) values (119, 'Kevin Romero', '86-(972)576-9603', 20587);
insert into Customer (customer_id, name, phone_number, insurance_policy_id) values (120, 'Cheryl Palmer', '358-(320)309-5207', 20760);
insert into Customer (customer_id, name, phone_number, insurance_policy_id) values (121, 'Stephanie White', '33-(193)736-3119', 20933);
insert into Customer (customer_id, name, phone_number, insurance_policy_id) values (122, 'James Richardson', '1-(936)600-8354', 21106);
insert into Customer (customer_id, name, phone_number, insurance_policy_id) values (123, 'Ryan Carter', '62-(418)739-9636', 21279);
insert into Customer (customer_id, name, phone_number, insurance_policy_id) values (124, 'Laura Murphy', '48-(658)779-8688', 21452);
insert into Customer (customer_id, name, phone_number, insurance_policy_id) values (125, 'Clarence Coleman', '86-(925)643-7207', 21625);
insert into Customer (customer_id, name, phone_number, insurance_policy_id) values (126, 'Julie Rice', '996-(813)769-3691', 21798);
insert into Customer (customer_id, name, phone_number, insurance_policy_id) values (127, 'Eugene Harrison', '66-(660)672-0415', 21971);
insert into Customer (customer_id, name, phone_number, insurance_policy_id) values (128, 'Kenneth Rose', '86-(983)520-7878', 22144);
insert into Customer (customer_id, name, phone_number, insurance_policy_id) values (129, 'Anne Freeman', '86-(400)561-3591', 22317);
insert into Customer (customer_id, name, phone_number, insurance_policy_id) values (130, 'Norma Sanders', '81-(229)957-0768', 22490);
insert into Customer (customer_id, name, phone_number, insurance_policy_id) values (131, 'Bruce Ellis', '86-(888)271-3493', 22663);
insert into Customer (customer_id, name, phone_number, insurance_policy_id) values (132, 'Beverly Gray', '502-(635)925-8565', 22836);
insert into Customer (customer_id, name, phone_number, insurance_policy_id) values (133, 'Sara Evans', '7-(144)434-0159', 23009);
insert into Customer (customer_id, name, phone_number, insurance_policy_id) values (134, 'Juan Andrews', '62-(169)757-3767', 23182);
insert into Customer (customer_id, name, phone_number, insurance_policy_id) values (135, 'Catherine White', '420-(133)329-2334', 23355);
insert into Customer (customer_id, name, phone_number, insurance_policy_id) values (136, 'Sara Turner', '212-(897)803-1646', 23528);
insert into Customer (customer_id, name, phone_number, insurance_policy_id) values (137, 'Mildred Coleman', '381-(607)445-5681', 23701);
insert into Customer (customer_id, name, phone_number, insurance_policy_id) values (138, 'David Warren', '98-(439)363-4255', 23874);
insert into Customer (customer_id, name, phone_number, insurance_policy_id) values (139, 'Joseph Perry', '63-(939)386-8958', 24047);
insert into Customer (customer_id, name, phone_number, insurance_policy_id) values (140, 'Timothy Wells', '84-(610)869-6386', 24220);
insert into Customer (customer_id, name, phone_number, insurance_policy_id) values (141, 'Virginia Frazier', '86-(735)847-9753', 24393);
insert into Customer (customer_id, name, phone_number, insurance_policy_id) values (142, 'Stephen Henry', '51-(911)740-9696', 24566);
insert into Customer (customer_id, name, phone_number, insurance_policy_id) values (143, 'Harry Harrison', '62-(363)363-1810', 24739);
insert into Customer (customer_id, name, phone_number, insurance_policy_id) values (144, 'Russell Burton', '62-(958)222-3236', 24912);
insert into Customer (customer_id, name, phone_number, insurance_policy_id) values (145, 'Jeffrey Kelly', '1-(812)107-1521', 25085);
insert into Customer (customer_id, name, phone_number, insurance_policy_id) values (146, 'Theresa Harris', '33-(213)310-8319', 25258);
insert into Customer (customer_id, name, phone_number, insurance_policy_id) values (147, 'George Stanley', '33-(593)854-5350', 25431);
insert into Customer (customer_id, name, phone_number, insurance_policy_id) values (148, 'Louise Armstrong', '86-(619)573-3943', 25604);
insert into Customer (customer_id, name, phone_number, insurance_policy_id) values (149, 'Robin Shaw', '7-(898)795-1589', 25777);
insert into Customer (customer_id, name, phone_number, insurance_policy_id) values (150, 'George Bishop', '57-(995)394-3452', 25950);
insert into Customer (customer_id, name, phone_number, insurance_policy_id) values (151, 'Robin Romero', '235-(396)743-3407', 26123);
insert into Customer (customer_id, name, phone_number, insurance_policy_id) values (152, 'Brenda Harvey', '55-(726)854-6623', 26296);
insert into Customer (customer_id, name, phone_number, insurance_policy_id) values (153, 'Brandon Torres', '55-(191)492-9725', 26469);
insert into Customer (customer_id, name, phone_number, insurance_policy_id) values (154, 'Robin West', '260-(729)270-8489', 26642);
insert into Customer (customer_id, name, phone_number, insurance_policy_id) values (155, 'Christina Morgan', '62-(518)729-2547', 26815);
insert into Customer (customer_id, name, phone_number, insurance_policy_id) values (156, 'Frank Boyd', '63-(517)342-0414', 26988);
insert into Customer (customer_id, name, phone_number, insurance_policy_id) values (157, 'Robin Payne', '46-(753)431-5084', 27161);
insert into Customer (customer_id, name, phone_number, insurance_policy_id) values (158, 'Nicholas Fernandez', '380-(103)320-1804', 27334);
insert into Customer (customer_id, name, phone_number, insurance_policy_id) values (159, 'Dennis Carr', '86-(486)476-5517', 27507);
insert into Customer (customer_id, name, phone_number, insurance_policy_id) values (160, 'Virginia Daniels', '62-(622)432-8633', 27680);
insert into Customer (customer_id, name, phone_number, insurance_policy_id) values (161, 'Eugene Banks', '86-(806)384-4113', 27853);
insert into Customer (customer_id, name, phone_number, insurance_policy_id) values (162, 'Ernest Mills', '62-(227)598-1718', 28026);
insert into Customer (customer_id, name, phone_number, insurance_policy_id) values (163, 'Victor Ryan', '93-(499)436-4217', 28199);
insert into Customer (customer_id, name, phone_number, insurance_policy_id) values (164, 'Jessica Henderson', '55-(232)866-9014', 28372);
insert into Customer (customer_id, name, phone_number, insurance_policy_id) values (165, 'Louise Richards', '7-(834)719-8494', 28545);
insert into Customer (customer_id, name, phone_number, insurance_policy_id) values (166, 'Ernest Mitchell', '383-(302)477-9415', 28718);
insert into Customer (customer_id, name, phone_number, insurance_policy_id) values (167, 'Annie Reynolds', '86-(602)970-9182', 28891);
insert into Customer (customer_id, name, phone_number, insurance_policy_id) values (168, 'Sarah Gordon', '86-(791)972-8913', 29064);
insert into Customer (customer_id, name, phone_number, insurance_policy_id) values (169, 'Ernest Franklin', '7-(775)837-6380', 29237);
insert into Customer (customer_id, name, phone_number, insurance_policy_id) values (170, 'Kevin Murray', '86-(214)868-9169', 29410);
insert into Customer (customer_id, name, phone_number, insurance_policy_id) values (171, 'Jack Bishop', '86-(776)853-6007', 29583);
insert into Customer (customer_id, name, phone_number, insurance_policy_id) values (172, 'Alan Anderson', '86-(919)558-4100', 29756);
insert into Customer (customer_id, name, phone_number, insurance_policy_id) values (173, 'Jessica Flores', '62-(910)401-3988', 29929);
insert into Customer (customer_id, name, phone_number, insurance_policy_id) values (174, 'Deborah Ramos', '86-(159)411-0202', 30102);
insert into Customer (customer_id, name, phone_number, insurance_policy_id) values (175, 'Wanda Carpenter', '48-(154)510-1170', 30275);
insert into Customer (customer_id, name, phone_number, insurance_policy_id) values (176, 'Albert Greene', '86-(688)537-3903', 30448);
insert into Customer (customer_id, name, phone_number, insurance_policy_id) values (177, 'Nicole Martinez', '372-(267)293-2574', 30621);
insert into Customer (customer_id, name, phone_number, insurance_policy_id) values (178, 'Albert Rodriguez', '86-(260)603-5406', 30794);
insert into Customer (customer_id, name, phone_number, insurance_policy_id) values (179, 'Irene Snyder', '7-(228)773-5987', 30967);
insert into Customer (customer_id, name, phone_number, insurance_policy_id) values (180, 'James Hernandez', '82-(659)947-0934', 31140);
insert into Customer (customer_id, name, phone_number, insurance_policy_id) values (181, 'Pamela Edwards', '7-(556)303-4696', 31313);
insert into Customer (customer_id, name, phone_number, insurance_policy_id) values (182, 'Helen Young', '63-(933)562-9516', 31486);
insert into Customer (customer_id, name, phone_number, insurance_policy_id) values (183, 'Jennifer Graham', '507-(453)695-8160', 31659);
insert into Customer (customer_id, name, phone_number, insurance_policy_id) values (184, 'Paul Little', '98-(493)170-7824', 31832);
insert into Customer (customer_id, name, phone_number, insurance_policy_id) values (185, 'Stephanie Williams', '33-(215)207-2987', 32005);
insert into Customer (customer_id, name, phone_number, insurance_policy_id) values (186, 'Julia Hunter', '420-(764)359-8549', 32178);
insert into Customer (customer_id, name, phone_number, insurance_policy_id) values (187, 'Carlos Owens', '46-(801)471-3162', 32351);
insert into Customer (customer_id, name, phone_number, insurance_policy_id) values (188, 'Michael Pierce', '86-(841)453-9877', 32524);
insert into Customer (customer_id, name, phone_number, insurance_policy_id) values (189, 'Bobby Armstrong', '81-(190)768-9682', 32697);
insert into Customer (customer_id, name, phone_number, insurance_policy_id) values (190, 'Gerald Frazier', '62-(651)563-5205', 32870);
insert into Customer (customer_id, name, phone_number, insurance_policy_id) values (191, 'Antonio Carr', '961-(124)263-7839', 33043);
insert into Customer (customer_id, name, phone_number, insurance_policy_id) values (192, 'Deborah Thompson', '51-(882)685-1489', 33216);
insert into Customer (customer_id, name, phone_number, insurance_policy_id) values (193, 'Nicholas Arnold', '57-(758)320-0652', 33389);
insert into Customer (customer_id, name, phone_number, insurance_policy_id) values (194, 'Eric Anderson', '63-(940)598-2471', 33562);
insert into Customer (customer_id, name, phone_number, insurance_policy_id) values (195, 'Karen Mitchell', '382-(735)438-7635', 33735);
insert into Customer (customer_id, name, phone_number, insurance_policy_id) values (196, 'Jason Griffin', '381-(987)444-4855', 33908);
insert into Customer (customer_id, name, phone_number, insurance_policy_id) values (197, 'Jose Greene', '63-(755)627-0225', 34081);
insert into Customer (customer_id, name, phone_number, insurance_policy_id) values (198, 'Anna Martin', '381-(976)778-6855', 34254);
insert into Customer (customer_id, name, phone_number, insurance_policy_id) values (199, 'Janet Grant', '385-(834)681-3426', 34427);
insert into Customer (customer_id, name, phone_number, insurance_policy_id) values (200, 'Roy Spencer', '81-(872)273-9835', 34600);
insert into Customer (customer_id, name, phone_number, insurance_policy_id) values (201, 'Harry King', '46-(957)328-9579', 34773);
insert into Customer (customer_id, name, phone_number, insurance_policy_id) values (202, 'Catherine Lawrence', '234-(721)997-5533', 34946);
insert into Customer (customer_id, name, phone_number, insurance_policy_id) values (203, 'Sarah Scott', '81-(365)315-9189', 35119);
insert into Customer (customer_id, name, phone_number, insurance_policy_id) values (204, 'Katherine Sullivan', '380-(702)308-5983', 35292);
insert into Customer (customer_id, name, phone_number, insurance_policy_id) values (205, 'Christina Dunn', '55-(682)315-7342', 35465);
insert into Customer (customer_id, name, phone_number, insurance_policy_id) values (206, 'Eugene Peterson', '61-(951)150-2471', 35638);
insert into Customer (customer_id, name, phone_number, insurance_policy_id) values (207, 'James Warren', '46-(565)207-3045', 35811);
insert into Customer (customer_id, name, phone_number, insurance_policy_id) values (208, 'Peter Fisher', '86-(360)187-8030', 35984);
insert into Customer (customer_id, name, phone_number, insurance_policy_id) values (209, 'Amy Taylor', '593-(368)520-5088', 36157);
insert into Customer (customer_id, name, phone_number, insurance_policy_id) values (210, 'Johnny Harrison', '62-(701)602-6598', 36330);
insert into Customer (customer_id, name, phone_number, insurance_policy_id) values (211, 'Katherine Freeman', '86-(831)582-6717', 36503);
insert into Customer (customer_id, name, phone_number, insurance_policy_id) values (212, 'Jason Matthews', '86-(837)179-2845', 36676);
insert into Customer (customer_id, name, phone_number, insurance_policy_id) values (213, 'Alice Ross', '420-(370)730-2583', 36849);
insert into Customer (customer_id, name, phone_number, insurance_policy_id) values (214, 'Jesse Cole', '385-(952)304-0803', 37022);
insert into Customer (customer_id, name, phone_number, insurance_policy_id) values (215, 'Craig Edwards', '51-(766)147-0499', 37195);
insert into Customer (customer_id, name, phone_number, insurance_policy_id) values (216, 'Helen Olson', '86-(887)740-0863', 37368);
insert into Customer (customer_id, name, phone_number, insurance_policy_id) values (217, 'Dorothy Richardson', '86-(519)342-1075', 37541);
insert into Customer (customer_id, name, phone_number, insurance_policy_id) values (218, 'Denise Hart', '55-(868)820-2273', 37714);
insert into Customer (customer_id, name, phone_number, insurance_policy_id) values (219, 'Jeffrey Gutierrez', '51-(900)784-1776', 37887);
insert into Customer (customer_id, name, phone_number, insurance_policy_id) values (220, 'Bruce Torres', '7-(457)195-7292', 38060);
insert into Customer (customer_id, name, phone_number, insurance_policy_id) values (221, 'Tina Chapman', '7-(573)342-7475', 38233);
insert into Customer (customer_id, name, phone_number, insurance_policy_id) values (222, 'Annie Peterson', '55-(917)315-2534', 38406);
insert into Customer (customer_id, name, phone_number, insurance_policy_id) values (223, 'Dennis Chapman', '86-(718)898-4551', 38579);
insert into Customer (customer_id, name, phone_number, insurance_policy_id) values (224, 'Martin Elliott', '591-(212)976-0270', 38752);
insert into Customer (customer_id, name, phone_number, insurance_policy_id) values (225, 'Jason Crawford', '383-(656)560-9293', 38925);
insert into Customer (customer_id, name, phone_number, insurance_policy_id) values (226, 'Emily Baker', '81-(733)290-1240', 39098);
insert into Customer (customer_id, name, phone_number, insurance_policy_id) values (227, 'Walter Perkins', '62-(408)359-1927', 39271);
insert into Customer (customer_id, name, phone_number, insurance_policy_id) values (228, 'Shirley Murphy', '98-(411)682-2114', 39444);
insert into Customer (customer_id, name, phone_number, insurance_policy_id) values (229, 'Irene Shaw', '62-(992)207-9432', 39617);
insert into Customer (customer_id, name, phone_number, insurance_policy_id) values (230, 'Kenneth Ward', '351-(223)550-9502', 39790);
insert into Customer (customer_id, name, phone_number, insurance_policy_id) values (231, 'Martin Ferguson', '351-(752)230-1159', 39963);
insert into Customer (customer_id, name, phone_number, insurance_policy_id) values (232, 'Victor Sullivan', '33-(948)517-6743', 40136);
insert into Customer (customer_id, name, phone_number, insurance_policy_id) values (233, 'Todd Taylor', '86-(729)499-1868', 40309);
insert into Customer (customer_id, name, phone_number, insurance_policy_id) values (234, 'Ashley Lewis', '7-(570)456-6974', 40482);
insert into Customer (customer_id, name, phone_number, insurance_policy_id) values (235, 'Dorothy Clark', '84-(695)175-6397', 40655);
insert into Customer (customer_id, name, phone_number, insurance_policy_id) values (236, 'Deborah Burton', '62-(772)611-8647', 40828);
insert into Customer (customer_id, name, phone_number, insurance_policy_id) values (237, 'Bonnie Stevens', '7-(491)726-4414', 41001);
insert into Customer (customer_id, name, phone_number, insurance_policy_id) values (238, 'Kathryn Cook', '351-(824)895-4280', 41174);
insert into Customer (customer_id, name, phone_number, insurance_policy_id) values (239, 'Sean Alvarez', '372-(289)415-5637', 41347);
insert into Customer (customer_id, name, phone_number, insurance_policy_id) values (240, 'Jean Bowman', '53-(680)804-5910', 41520);
insert into Customer (customer_id, name, phone_number, insurance_policy_id) values (241, 'Dennis Crawford', '355-(387)244-2880', 41693);
insert into Customer (customer_id, name, phone_number, insurance_policy_id) values (242, 'Keith Armstrong', '57-(307)581-8725', 41866);
insert into Customer (customer_id, name, phone_number, insurance_policy_id) values (243, 'Diana Mccoy', '86-(589)235-5260', 42039);
insert into Customer (customer_id, name, phone_number, insurance_policy_id) values (244, 'Sandra Mccoy', '86-(783)507-6824', 42212);
insert into Customer (customer_id, name, phone_number, insurance_policy_id) values (245, 'Margaret Bowman', '7-(856)921-9854', 42385);
insert into Customer (customer_id, name, phone_number, insurance_policy_id) values (246, 'David Scott', '976-(445)733-3403', 42558);
insert into Customer (customer_id, name, phone_number, insurance_policy_id) values (247, 'Brian Day', '261-(834)273-2685', 42731);
insert into Customer (customer_id, name, phone_number, insurance_policy_id) values (248, 'Stephanie Phillips', '33-(739)280-4285', 42904);
insert into Customer (customer_id, name, phone_number, insurance_policy_id) values (249, 'Melissa Grant', '380-(443)650-6136', 43077);
