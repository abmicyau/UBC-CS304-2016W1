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
 	(doctor_id char(8) not null,
 	 phone_number char(10) not null,
 	 name varchar(20),
 	 primary key (doctor_id)
 	);

create table Customer
	(customer_id char(8) not null,
	 name varchar(25) null,
 	 phone_number char(10) null,
	 insurance_info varchar(30) null,
 	 primary key (customer_id)
 	);

 create table Patient
 	(customer_Id char(8) not null,
 	 care_card_number char(16) not null unique,
 	 address char(20) null,
 	 birthdate date null,
 	 gender char(1) null,
 	 primary key (customer_Id), 
 	 foreign key (customer_Id) references Customer ON DELETE CASCADE
 	);

 create table Prescription_by_is_for
 	(service_id char(8) not null,
	 doctor_id char(8) not null,
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
	 dose varchar(16) not null,
 	 duration varchar(32) not null,
 	 frequency varchar(32) not null,
 	 primary key (item_id, prescription_id), 
 	 foreign key (prescription_id) references Prescription_by_is_for ON DELETE CASCADE
	);

create table Pharmacy_record_has 
 	(record_id char(10) not null,
 	 care_card_number char(16) not null,
 	 purchasing_history varchar(100),
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
 	 dose varchar(16) null,
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


insert into Employee (emp_id, email, date_of_birth, address, name, phone_number, gender, sin) values (0, 'tberry0@cnet.com', '1993-02-07', '965 Johnson Avenue', 'Tina Berry', '1-(739)838-9611', 'F', '491796127');
insert into Employee (emp_id, email, date_of_birth, address, name, phone_number, gender, sin) values (1, 'ckelly1@cnet.com', '1959-04-26', '04935 Swallow Crossing', 'Christine Kelly', '62-(659)576-4866', 'F', '301457583');
insert into Employee (emp_id, email, date_of_birth, address, name, phone_number, gender, sin) values (2, 'jfrazier2@mapy.cz', '1976-07-15', '0901 Eastlawn Avenue', 'James Frazier', '972-(300)539-1244', 'M', '670995587');
insert into Employee (emp_id, email, date_of_birth, address, name, phone_number, gender, sin) values (3, 'abanks3@china.com.cn', '1984-11-26', '903 Erie Way', 'Antonio Banks', '351-(596)249-4820', 'M', '500235762');
insert into Employee (emp_id, email, date_of_birth, address, name, phone_number, gender, sin) values (4, 'tgeorge4@reuters.com', '1980-02-15', '8 Garrison Pass', 'Todd George', '86-(657)142-9631', 'M', '355172520');
insert into Employee (emp_id, email, date_of_birth, address, name, phone_number, gender, sin) values (5, 'griley5@comcast.net', '1973-08-21', '75 Crownhardt Way', 'Gary Riley', '84-(594)649-9529', 'M', '355895431');
insert into Employee (emp_id, email, date_of_birth, address, name, phone_number, gender, sin) values (6, 'rgonzalez6@google.ca', '1957-07-29', '4 Lukken Place', 'Rose Gonzalez', '86-(508)341-8141', 'F', '560224330');
insert into Employee (emp_id, email, date_of_birth, address, name, phone_number, gender, sin) values (7, 'egilbert7@jimdo.com', '1977-06-08', '66008 Northport Road', 'Ernest Gilbert', '86-(690)459-5967', 'M', '490360729');
insert into Employee (emp_id, email, date_of_birth, address, name, phone_number, gender, sin) values (8, 'escott8@state.tx.us', '1980-07-22', '58907 Butternut Hill', 'Ernest Scott', '86-(668)266-2586', 'M', '374288907');
insert into Employee (emp_id, email, date_of_birth, address, name, phone_number, gender, sin) values (9, 'slawson9@sohu.com', '1971-06-25', '3 Moland Street', 'Susan Lawson', '355-(435)873-7027', 'F', '353467058');
insert into Employee (emp_id, email, date_of_birth, address, name, phone_number, gender, sin) values (10, 'bwoodsa@comcast.net', '1961-02-13', '58426 Buell Court', 'Bruce Woods', '501-(533)213-0620', 'M', '356388414');
insert into Employee (emp_id, email, date_of_birth, address, name, phone_number, gender, sin) values (11, 'awallaceb@sitemeter.com', '1968-08-05', '159 Steensland Junction', 'Amanda Wallace', '86-(294)820-0742', 'F', '364436263');
insert into Employee (emp_id, email, date_of_birth, address, name, phone_number, gender, sin) values (12, 'aclarkc@woothemes.com', '1967-07-22', '9849 Westridge Avenue', 'Angela Clark', '86-(859)889-6057', 'F', '374288318');
insert into Employee (emp_id, email, date_of_birth, address, name, phone_number, gender, sin) values (13, 'aelliottd@istockphoto.com', '1979-08-17', '35 School Park', 'Anthony Elliott', '86-(994)409-4762', 'M', '356545672');
insert into Employee (emp_id, email, date_of_birth, address, name, phone_number, gender, sin) values (14, 'mhamiltone@apple.com', '1989-10-01', '905 Glacier Hill Drive', 'Michelle Hamilton', '420-(807)703-7046', 'F', '491372751');
insert into Employee (emp_id, email, date_of_birth, address, name, phone_number, gender, sin) values (15, 'rwheelerf@biblegateway.com', '1991-11-22', '38484 Onsgard Drive', 'Raymond Wheeler', '7-(559)781-2094', 'M', '676291625');
insert into Employee (emp_id, email, date_of_birth, address, name, phone_number, gender, sin) values (16, 'tgonzalesg@thetimes.co.uk', '1986-07-24', '1036 Southridge Terrace', 'Teresa Gonzales', '86-(294)776-7561', 'F', '361965499');
insert into Employee (emp_id, email, date_of_birth, address, name, phone_number, gender, sin) values (17, 'jbarnesh@harvard.edu', '1984-09-23', '713 Ramsey Avenue', 'Jennifer Barnes', '351-(424)871-3738', 'F', '201504567');
insert into Employee (emp_id, email, date_of_birth, address, name, phone_number, gender, sin) values (18, 'arobertsoni@skype.com', '1994-12-06', '5 Farragut Plaza', 'Arthur Robertson', '46-(125)316-8467', 'M', '560225320');
insert into Employee (emp_id, email, date_of_birth, address, name, phone_number, gender, sin) values (19, 'ajordanj@woothemes.com', '1984-05-24', '1919 Messerschmidt Center', 'Anne Jordan', '234-(690)282-6587', 'F', '355708195');
insert into Employee (emp_id, email, date_of_birth, address, name, phone_number, gender, sin) values (20, 'dgibsonk@plala.or.jp', '1987-01-27', '339 Stone Corner Avenue', 'Dorothy Gibson', '62-(400)641-2341', 'F', '358268638');
insert into Employee (emp_id, email, date_of_birth, address, name, phone_number, gender, sin) values (21, 'drusselll@yahoo.co.jp', '1982-01-14', '6922 Eagan Park', 'Daniel Russell', '62-(379)328-8605', 'M', '491702356');
insert into Employee (emp_id, email, date_of_birth, address, name, phone_number, gender, sin) values (22, 'ghartm@phoca.cz', '1966-10-12', '8 Eastlawn Alley', 'George Hart', '60-(710)254-4497', 'M', '356921337');
insert into Employee (emp_id, email, date_of_birth, address, name, phone_number, gender, sin) values (23, 'rwestn@shutterfly.com', '1989-02-27', '9054 Sundown Avenue', 'Russell West', '63-(341)876-7027', 'M', '358927997');
insert into Employee (emp_id, email, date_of_birth, address, name, phone_number, gender, sin) values (24, 'wwheelero@nasa.gov', '1985-01-23', '3309 Maple Park', 'Walter Wheeler', '86-(307)290-2124', 'M', '353612661');
insert into Employee (emp_id, email, date_of_birth, address, name, phone_number, gender, sin) values (25, 'jbryantp@phpbb.com', '1990-08-13', '80270 Dakota Alley', 'Justin Bryant', '963-(537)675-5576', 'M', '354958591');
insert into Employee (emp_id, email, date_of_birth, address, name, phone_number, gender, sin) values (26, 'aperryq@youtu.be', '1978-12-03', '5 Badeau Street', 'Ashley Perry', '967-(942)756-7381', 'F', '356156905');
insert into Employee (emp_id, email, date_of_birth, address, name, phone_number, gender, sin) values (27, 'grichardsonr@devhub.com', '1971-06-08', '7128 Coleman Place', 'Gregory Richardson', '30-(453)838-7089', 'M', '355238093');
insert into Employee (emp_id, email, date_of_birth, address, name, phone_number, gender, sin) values (28, 'treynoldss@exblog.jp', '1972-07-03', '1 Grover Lane', 'Todd Reynolds', '48-(661)820-7815', 'M', '305927005');
insert into Employee (emp_id, email, date_of_birth, address, name, phone_number, gender, sin) values (29, 'bcolet@google.co.uk', '1963-10-06', '44 Thierer Crossing', 'Bobby Cole', '86-(340)385-3847', 'M', '491363863');
insert into Employee (emp_id, email, date_of_birth, address, name, phone_number, gender, sin) values (30, 'lwellsu@technorati.com', '1958-11-13', '7 Novick Terrace', 'Laura Wells', '86-(445)992-7818', 'F', '417500711');
insert into Employee (emp_id, email, date_of_birth, address, name, phone_number, gender, sin) values (31, 'jboydv@washingtonpost.com', '1983-08-21', '217 Schurz Road', 'Jessica Boyd', '86-(250)951-2705', 'F', '349915996');
insert into Employee (emp_id, email, date_of_birth, address, name, phone_number, gender, sin) values (32, 'schavezw@samsung.com', '1992-10-23', '434 Roxbury Junction', 'Sara Chavez', '48-(359)771-6981', 'F', '355999761');
insert into Employee (emp_id, email, date_of_birth, address, name, phone_number, gender, sin) values (33, 'mlittlex@hexun.com', '1962-03-17', '06 Laurel Crossing', 'Michael Little', '7-(160)450-1546', 'M', '530760285');
insert into Employee (emp_id, email, date_of_birth, address, name, phone_number, gender, sin) values (34, 'rpiercey@deliciousdays.com', '1969-03-20', '143 Rowland Street', 'Rachel Pierce', '56-(552)714-8193', 'F', '560225740');
insert into Employee (emp_id, email, date_of_birth, address, name, phone_number, gender, sin) values (35, 'aalexanderz@sogou.com', '1960-08-06', '78 Ryan Center', 'Anna Alexander', '62-(354)132-1177', 'F', '354654143');
insert into Employee (emp_id, email, date_of_birth, address, name, phone_number, gender, sin) values (36, 'jtorres10@rediff.com', '1990-02-16', '723 Schurz Trail', 'James Torres', '62-(119)266-4755', 'M', '355573170');
insert into Employee (emp_id, email, date_of_birth, address, name, phone_number, gender, sin) values (37, 'sbaker11@about.me', '1993-12-23', '7 Transport Park', 'Scott Baker', '1-(716)492-8448', 'M', '353735175');
insert into Employee (emp_id, email, date_of_birth, address, name, phone_number, gender, sin) values (38, 'jvasquez12@ycombinator.com', '1992-10-28', '2 Tennessee Court', 'Jennifer Vasquez', '86-(734)931-9734', 'F', '356234067');
insert into Employee (emp_id, email, date_of_birth, address, name, phone_number, gender, sin) values (39, 'lgilbert13@google.ca', '1982-05-15', '21147 Sherman Avenue', 'Lillian Gilbert', '234-(371)435-4593', 'F', '303030807');
insert into Employee (emp_id, email, date_of_birth, address, name, phone_number, gender, sin) values (40, 'kelliott14@desdev.cn', '1970-12-29', '5760 Elgar Center', 'Katherine Elliott', '63-(959)461-9177', 'F', '356820505');
insert into Employee (emp_id, email, date_of_birth, address, name, phone_number, gender, sin) values (41, 'hward15@hud.gov', '1961-10-20', '495 Hauk Street', 'Helen Ward', '33-(711)769-4538', 'F', '374283905');
insert into Employee (emp_id, email, date_of_birth, address, name, phone_number, gender, sin) values (42, 'sbennett16@example.com', '1970-04-04', '3288 Shopko Terrace', 'Stephanie Bennett', '251-(837)100-4698', 'F', '560222899');
insert into Employee (emp_id, email, date_of_birth, address, name, phone_number, gender, sin) values (43, 'brichardson17@foxnews.com', '1984-06-12', '0 Sugar Point', 'Benjamin Richardson', '7-(682)133-9275', 'M', '354983287');
insert into Employee (emp_id, email, date_of_birth, address, name, phone_number, gender, sin) values (44, 'bpayne18@goo.gl', '1975-02-13', '350 La Follette Plaza', 'Betty Payne', '593-(906)581-7798', 'F', '560223389');
insert into Employee (emp_id, email, date_of_birth, address, name, phone_number, gender, sin) values (45, 'vray19@illinois.edu', '1959-02-02', '565 Susan Crossing', 'Virginia Ray', '98-(671)542-3896', 'F', '503806122');
insert into Employee (emp_id, email, date_of_birth, address, name, phone_number, gender, sin) values (46, 'tmurray1a@springer.com', '1973-08-14', '8906 Kim Point', 'Theresa Murray', '7-(969)682-1983', 'F', '357818768');
insert into Employee (emp_id, email, date_of_birth, address, name, phone_number, gender, sin) values (47, 'aclark1b@tinypic.com', '1987-03-23', '1539 Logan Parkway', 'Amanda Clark', '7-(625)106-4792', 'F', '504837585');
insert into Employee (emp_id, email, date_of_birth, address, name, phone_number, gender, sin) values (48, 'brobinson1c@blogs.com', '1978-09-22', '6 Daystar Pass', 'Brenda Robinson', '228-(230)710-4672', 'F', '354166954');
insert into Employee (emp_id, email, date_of_birth, address, name, phone_number, gender, sin) values (49, 'tholmes1d@engadget.com', '1993-04-07', '7637 Menomonie Lane', 'Terry Holmes', '86-(609)231-3240', 'M', '358905843');
insert into Employee (emp_id, email, date_of_birth, address, name, phone_number, gender, sin) values (50, 'padams1e@wired.com', '1977-02-25', '5424 Manufacturers Avenue', 'Pamela Adams', '62-(238)113-3926', 'F', '676215364');
insert into Employee (emp_id, email, date_of_birth, address, name, phone_number, gender, sin) values (51, 'eburton1f@yahoo.co.jp', '1961-12-08', '17410 Red Cloud Lane', 'Eugene Burton', '58-(712)780-3064', 'M', '357743846');
insert into Employee (emp_id, email, date_of_birth, address, name, phone_number, gender, sin) values (52, 'abaker1g@youtu.be', '1966-07-11', '78732 Old Gate Alley', 'Alan Baker', '86-(381)810-6876', 'M', '354828270');
insert into Employee (emp_id, email, date_of_birth, address, name, phone_number, gender, sin) values (53, 'rwilliams1h@free.fr', '1993-02-15', '42 Brown Way', 'Rebecca Williams', '63-(797)516-3407', 'F', '358651718');
insert into Employee (emp_id, email, date_of_birth, address, name, phone_number, gender, sin) values (54, 'jjordan1i@nih.gov', '1992-05-20', '4 Blackbird Hill', 'Julie Jordan', '95-(621)831-7846', 'F', '374288037');
insert into Employee (emp_id, email, date_of_birth, address, name, phone_number, gender, sin) values (55, 'rperry1j@com.com', '1959-05-13', '30 Crest Line Pass', 'Robert Perry', '381-(245)207-2541', 'M', '201483390');
insert into Employee (emp_id, email, date_of_birth, address, name, phone_number, gender, sin) values (56, 'gturner1k@va.gov', '1990-03-22', '752 School Court', 'Gloria Turner', '420-(361)973-9153', 'F', '201565356');
insert into Employee (emp_id, email, date_of_birth, address, name, phone_number, gender, sin) values (57, 'jkim1l@alexa.com', '1963-03-29', '4 Lawn Park', 'Jane Kim', '381-(120)964-2219', 'F', '358519754');
insert into Employee (emp_id, email, date_of_birth, address, name, phone_number, gender, sin) values (58, 'agordon1m@issuu.com', '1990-09-11', '85 International Place', 'Ashley Gordon', '81-(486)797-3329', 'F', '353452486');
insert into Employee (emp_id, email, date_of_birth, address, name, phone_number, gender, sin) values (59, 'egraham1n@microsoft.com', '1995-08-01', '02 Scoville Court', 'Emily Graham', '86-(123)912-3895', 'F', '354535386');
insert into Employee (emp_id, email, date_of_birth, address, name, phone_number, gender, sin) values (60, 'wreynolds1o@bloglines.com', '1982-09-11', '33 Dunning Terrace', 'Wanda Reynolds', '86-(375)869-7376', 'F', '633399674');
insert into Employee (emp_id, email, date_of_birth, address, name, phone_number, gender, sin) values (61, 'jrobertson1p@whitehouse.gov', '1985-04-24', '47 Hauk Circle', 'Jane Robertson', '1-(217)239-4744', 'F', '504837637');
insert into Employee (emp_id, email, date_of_birth, address, name, phone_number, gender, sin) values (62, 'vroberts1q@technorati.com', '1956-12-08', '622 Mayfield Crossing', 'Virginia Roberts', '380-(187)540-4692', 'F', '493649691');
insert into Employee (emp_id, email, date_of_birth, address, name, phone_number, gender, sin) values (63, 'abanks1r@digg.com', '1967-02-25', '97 Stuart Crossing', 'Anna Banks', '93-(377)292-5543', 'F', '354209396');
insert into Employee (emp_id, email, date_of_birth, address, name, phone_number, gender, sin) values (64, 'dcarr1s@studiopress.com', '1963-06-20', '852 Dennis Drive', 'Deborah Carr', '86-(305)666-7173', 'F', '354030007');
insert into Employee (emp_id, email, date_of_birth, address, name, phone_number, gender, sin) values (65, 'rward1t@clickbank.net', '1977-12-05', '5433 Waxwing Alley', 'Randy Ward', '502-(157)981-8895', 'M', '500235473');
insert into Employee (emp_id, email, date_of_birth, address, name, phone_number, gender, sin) values (66, 'jhunter1u@examiner.com', '1981-06-13', '0 Northfield Lane', 'Joan Hunter', '7-(140)416-2949', 'F', '374622306');
insert into Employee (emp_id, email, date_of_birth, address, name, phone_number, gender, sin) values (67, 'jknight1v@nature.com', '1976-04-04', '840 Lillian Way', 'Joe Knight', '351-(740)457-6898', 'M', '676389712');
insert into Employee (emp_id, email, date_of_birth, address, name, phone_number, gender, sin) values (68, 'ecarter1w@whitehouse.gov', '1993-11-15', '000 Nova Court', 'Earl Carter', '46-(385)107-7700', 'M', '561070766');
insert into Employee (emp_id, email, date_of_birth, address, name, phone_number, gender, sin) values (69, 'crivera1x@hp.com', '1972-08-03', '60 Warrior Terrace', 'Christina Rivera', '86-(453)564-1133', 'F', '354915327');
insert into Employee (emp_id, email, date_of_birth, address, name, phone_number, gender, sin) values (70, 'gmarshall1y@scribd.com', '1957-01-19', '3056 Waubesa Avenue', 'George Marshall', '81-(273)878-3612', 'M', '491193583');
insert into Employee (emp_id, email, date_of_birth, address, name, phone_number, gender, sin) values (71, 'alarson1z@mayoclinic.com', '1996-06-14', '670 Shopko Trail', 'Antonio Larson', '55-(573)211-4894', 'M', '526378855');
insert into Employee (emp_id, email, date_of_birth, address, name, phone_number, gender, sin) values (72, 'cmorgan20@miitbeian.gov.cn', '1968-05-11', '748 Anniversary Junction', 'Catherine Morgan', '51-(548)580-8851', 'F', '356362492');
insert into Employee (emp_id, email, date_of_birth, address, name, phone_number, gender, sin) values (73, 'rpeterson21@yahoo.com', '1964-10-20', '41 Golf Course Trail', 'Robin Peterson', '86-(761)713-3957', 'F', '358764614');
insert into Employee (emp_id, email, date_of_birth, address, name, phone_number, gender, sin) values (74, 'tcunningham22@geocities.jp', '1983-07-25', '62332 Everett Plaza', 'Terry Cunningham', '351-(847)434-8928', 'M', '551881349');
insert into Employee (emp_id, email, date_of_birth, address, name, phone_number, gender, sin) values (75, 'kmeyer23@linkedin.com', '1996-09-30', '452 Nancy Avenue', 'Katherine Meyer', '86-(283)731-2535', 'F', '633110460');
insert into Employee (emp_id, email, date_of_birth, address, name, phone_number, gender, sin) values (76, 'sjordan24@edublogs.org', '1965-10-23', '1 East Road', 'Shirley Jordan', '46-(220)206-8037', 'F', '353119286');
insert into Employee (emp_id, email, date_of_birth, address, name, phone_number, gender, sin) values (77, 'lrodriguez25@army.mil', '1986-03-03', '35 Lawn Point', 'Lillian Rodriguez', '62-(111)758-6577', 'F', '356614958');
insert into Employee (emp_id, email, date_of_birth, address, name, phone_number, gender, sin) values (78, 'plewis26@adobe.com', '1993-09-18', '7 Shasta Plaza', 'Phillip Lewis', '86-(912)771-2924', 'M', '352845885');
insert into Employee (emp_id, email, date_of_birth, address, name, phone_number, gender, sin) values (79, 'cryan27@discovery.com', '1974-10-15', '1 Burrows Hill', 'Christina Ryan', '420-(179)765-5192', 'F', '560222807');
insert into Employee (emp_id, email, date_of_birth, address, name, phone_number, gender, sin) values (80, 'rwagner28@360.cn', '1960-03-30', '78 Northland Terrace', 'Ronald Wagner', '62-(677)675-1356', 'M', '354752329');
insert into Employee (emp_id, email, date_of_birth, address, name, phone_number, gender, sin) values (81, 'lperry29@ox.ac.uk', '1959-08-05', '9324 Gale Lane', 'Lois Perry', '86-(393)243-6933', 'F', '357006710');
insert into Employee (emp_id, email, date_of_birth, address, name, phone_number, gender, sin) values (82, 'aperry2a@amazon.co.jp', '1969-03-12', '39 Northridge Point', 'Albert Perry', '52-(388)358-0636', 'M', '300680773');
insert into Employee (emp_id, email, date_of_birth, address, name, phone_number, gender, sin) values (83, 'sknight2b@deliciousdays.com', '1974-03-23', '989 Anthes Point', 'Sarah Knight', '86-(108)384-6297', 'F', '491759632');
insert into Employee (emp_id, email, date_of_birth, address, name, phone_number, gender, sin) values (84, 'icrawford2c@t.co', '1968-07-23', '12 Donald Court', 'Irene Crawford', '7-(968)748-5157', 'F', '561045560');
insert into Employee (emp_id, email, date_of_birth, address, name, phone_number, gender, sin) values (85, 'mkim2d@hugedomains.com', '1965-04-04', '9530 Pawling Alley', 'Matthew Kim', '62-(600)406-4969', 'M', '404159593');
insert into Employee (emp_id, email, date_of_birth, address, name, phone_number, gender, sin) values (86, 'jhayes2e@myspace.com', '1981-08-30', '0 Anniversary Hill', 'Jacqueline Hayes', '52-(570)307-6175', 'F', '353201364');
insert into Employee (emp_id, email, date_of_birth, address, name, phone_number, gender, sin) values (87, 'wmedina2f@globo.com', '1967-05-13', '409 Claremont Plaza', 'Walter Medina', '63-(641)188-6846', 'M', '510875496');
insert into Employee (emp_id, email, date_of_birth, address, name, phone_number, gender, sin) values (88, 'lcarter2g@flavors.me', '1962-05-21', '9 Browning Place', 'Lois Carter', '383-(264)482-0491', 'F', '484436789');
insert into Employee (emp_id, email, date_of_birth, address, name, phone_number, gender, sin) values (89, 'jcruz2h@nytimes.com', '1960-05-06', '4 Shopko Trail', 'Jeremy Cruz', '51-(282)665-8681', 'M', '527538114');
insert into Employee (emp_id, email, date_of_birth, address, name, phone_number, gender, sin) values (90, 'rmartinez2i@yelp.com', '1984-02-14', '55662 School Drive', 'Roger Martinez', '55-(319)874-0716', 'M', '301650611');
insert into Employee (emp_id, email, date_of_birth, address, name, phone_number, gender, sin) values (91, 'swashington2j@desdev.cn', '1987-04-22', '53 Gale Drive', 'Sandra Washington', '55-(527)763-4099', 'F', '354036135');
insert into Employee (emp_id, email, date_of_birth, address, name, phone_number, gender, sin) values (92, 'bnguyen2k@webeden.co.uk', '1958-10-23', '39 Becker Road', 'Betty Nguyen', '880-(124)807-5738', 'F', '557681791');
insert into Employee (emp_id, email, date_of_birth, address, name, phone_number, gender, sin) values (93, 'tcrawford2l@icq.com', '1967-03-17', '7349 Saint Paul Drive', 'Tina Crawford', '62-(745)828-8869', 'F', '354468372');
insert into Employee (emp_id, email, date_of_birth, address, name, phone_number, gender, sin) values (94, 'pdean2m@xing.com', '1985-05-21', '196 Carberry Junction', 'Peter Dean', '374-(479)288-8445', 'M', '633319282');
insert into Employee (emp_id, email, date_of_birth, address, name, phone_number, gender, sin) values (95, 'amiller2n@stumbleupon.com', '1972-05-08', '1 Boyd Terrace', 'Anne Miller', '86-(908)824-8951', 'F', '352920343');
insert into Employee (emp_id, email, date_of_birth, address, name, phone_number, gender, sin) values (96, 'gporter2o@columbia.edu', '1978-05-28', '62 Hollow Ridge Junction', 'Gloria Porter', '7-(632)259-0339', 'F', '353585815');
insert into Employee (emp_id, email, date_of_birth, address, name, phone_number, gender, sin) values (97, 'lcruz2p@yandex.ru', '1996-09-10', '365 Rigney Place', 'Lori Cruz', '31-(297)508-9454', 'F', '502023445');
insert into Employee (emp_id, email, date_of_birth, address, name, phone_number, gender, sin) values (98, 'mreynolds2q@surveymonkey.com', '1965-04-10', '72944 Milwaukee Pass', 'Mary Reynolds', '27-(217)365-1145', 'F', '676179519');
insert into Employee (emp_id, email, date_of_birth, address, name, phone_number, gender, sin) values (99, 'tcarroll2r@baidu.com', '1984-01-22', '188 Kenwood Alley', 'Teresa Carroll', '86-(753)189-4932', 'F', '358964834');
insert into Employee (emp_id, email, date_of_birth, address, name, phone_number, gender, sin) values (100, 'lwells2s@wunderground.com', '1994-07-24', '79171 Monument Terrace', 'Linda Wells', '351-(447)864-5738', 'F', '670939290');
insert into Employee (emp_id, email, date_of_birth, address, name, phone_number, gender, sin) values (101, 'tcunningham2t@sourceforge.net', '1988-05-01', '34 Sherman Park', 'Teresa Cunningham', '62-(494)591-1726', 'F', '358986677');
insert into Employee (emp_id, email, date_of_birth, address, name, phone_number, gender, sin) values (102, 'fknight2u@dailymail.co.uk', '1979-04-04', '0 Sage Court', 'Fred Knight', '234-(765)811-1367', 'M', '201680268');
insert into Employee (emp_id, email, date_of_birth, address, name, phone_number, gender, sin) values (103, 'amorrison2v@ezinearticles.com', '1975-02-21', '1627 Canary Terrace', 'Arthur Morrison', '7-(918)274-6479', 'M', '352982782');
insert into Employee (emp_id, email, date_of_birth, address, name, phone_number, gender, sin) values (104, 'cwright2w@nationalgeographic.com', '1979-03-28', '55 Stang Plaza', 'Cheryl Wright', '86-(345)827-9207', 'F', '201454896');
insert into Employee (emp_id, email, date_of_birth, address, name, phone_number, gender, sin) values (105, 'agreen2x@shop-pro.jp', '1975-12-10', '4802 Bunker Hill Alley', 'Arthur Green', '358-(744)667-4056', 'M', '354633173');
insert into Employee (emp_id, email, date_of_birth, address, name, phone_number, gender, sin) values (106, 'btucker2y@theglobeandmail.com', '1962-11-26', '34650 Anderson Hill', 'Barbara Tucker', '86-(852)640-8175', 'F', '490310234');
insert into Employee (emp_id, email, date_of_birth, address, name, phone_number, gender, sin) values (107, 'mwoods2z@unicef.org', '1975-06-18', '92 Commercial Point', 'Matthew Woods', '55-(382)568-5325', 'M', '525682823');
insert into Employee (emp_id, email, date_of_birth, address, name, phone_number, gender, sin) values (108, 'rowens30@amazonaws.com', '1971-06-12', '5243 Arrowood Way', 'Ronald Owens', '86-(611)270-8615', 'M', '356392981');
insert into Employee (emp_id, email, date_of_birth, address, name, phone_number, gender, sin) values (109, 'jalexander31@vkontakte.ru', '1974-03-21', '76181 Meadow Ridge Drive', 'Janet Alexander', '64-(365)208-2861', 'F', '560224835');
insert into Employee (emp_id, email, date_of_birth, address, name, phone_number, gender, sin) values (110, 'cstevens32@github.com', '1969-01-13', '46239 Mockingbird Street', 'Cynthia Stevens', '66-(629)433-6083', 'F', '353727417');
insert into Employee (emp_id, email, date_of_birth, address, name, phone_number, gender, sin) values (111, 'ssanders33@amazon.co.uk', '1962-09-21', '00 Delaware Center', 'Susan Sanders', '7-(289)221-2551', 'F', '633110876');
insert into Employee (emp_id, email, date_of_birth, address, name, phone_number, gender, sin) values (112, 'pgarcia34@qq.com', '1970-09-20', '323 La Follette Way', 'Peter Garcia', '86-(287)302-0742', 'M', '354821475');
insert into Employee (emp_id, email, date_of_birth, address, name, phone_number, gender, sin) values (113, 'dfields35@ning.com', '1973-01-10', '7 Forster Hill', 'Donna Fields', '86-(399)185-4783', 'F', '404159337');
insert into Employee (emp_id, email, date_of_birth, address, name, phone_number, gender, sin) values (114, 'bshaw36@mail.ru', '1965-10-25', '73801 Larry Court', 'Brenda Shaw', '375-(227)890-9357', 'F', '355256528');
insert into Employee (emp_id, email, date_of_birth, address, name, phone_number, gender, sin) values (115, 'scampbell37@discovery.com', '1974-02-19', '23853 Monterey Plaza', 'Sandra Campbell', '62-(673)677-2834', 'F', '201522069');
insert into Employee (emp_id, email, date_of_birth, address, name, phone_number, gender, sin) values (116, 'brodriguez38@canalblog.com', '1976-11-07', '1 West Avenue', 'Brandon Rodriguez', '358-(687)597-1206', 'M', '500235056');
insert into Employee (emp_id, email, date_of_birth, address, name, phone_number, gender, sin) values (117, 'pbanks39@gmpg.org', '1987-01-27', '05565 Washington Lane', 'Phyllis Banks', '55-(893)956-8377', 'F', '493691760');
insert into Employee (emp_id, email, date_of_birth, address, name, phone_number, gender, sin) values (118, 'thanson3a@omniture.com', '1983-12-11', '2514 Garrison Crossing', 'Timothy Hanson', '595-(311)780-6060', 'M', '355044290');
insert into Employee (emp_id, email, date_of_birth, address, name, phone_number, gender, sin) values (119, 'jnguyen3b@google.ru', '1989-04-08', '575 Di Loreto Parkway', 'Joshua Nguyen', '62-(258)430-5059', 'M', '355880352');
insert into Employee (emp_id, email, date_of_birth, address, name, phone_number, gender, sin) values (120, 'jberry3c@cmu.edu', '1993-08-11', '9 Crowley Parkway', 'James Berry', '63-(785)806-0824', 'M', '502010146');
insert into Employee (emp_id, email, date_of_birth, address, name, phone_number, gender, sin) values (121, 'hfernandez3d@elpais.com', '1989-05-08', '8246 Hoffman Center', 'Howard Fernandez', '45-(186)598-6880', 'M', '356925098');
insert into Employee (emp_id, email, date_of_birth, address, name, phone_number, gender, sin) values (122, 'pjohnston3e@foxnews.com', '1963-06-30', '0 Waywood Avenue', 'Phillip Johnston', '55-(306)323-5471', 'M', '300433020');
insert into Employee (emp_id, email, date_of_birth, address, name, phone_number, gender, sin) values (123, 'hdaniels3f@utexas.edu', '1983-09-01', '08042 Utah Place', 'Harold Daniels', '62-(372)507-0090', 'M', '401795068');
insert into Employee (emp_id, email, date_of_birth, address, name, phone_number, gender, sin) values (124, 'jjenkins3g@ca.gov', '1970-12-03', '830 Utah Parkway', 'Jesse Jenkins', '1-(952)420-9088', 'M', '355184076');
insert into Employee (emp_id, email, date_of_birth, address, name, phone_number, gender, sin) values (125, 'pstanley3h@zdnet.com', '1967-09-04', '1521 Sherman Place', 'Pamela Stanley', '502-(404)456-1308', 'F', '356279287');
insert into Employee (emp_id, email, date_of_birth, address, name, phone_number, gender, sin) values (126, 'lbrown3i@macromedia.com', '1984-10-25', '52150 Aberg Center', 'Lori Brown', '86-(352)755-3317', 'F', '510013106');
insert into Employee (emp_id, email, date_of_birth, address, name, phone_number, gender, sin) values (127, 'barmstrong3j@icio.us', '1976-06-27', '0 Becker Plaza', 'Bonnie Armstrong', '1-(613)682-1642', 'F', '358686993');
insert into Employee (emp_id, email, date_of_birth, address, name, phone_number, gender, sin) values (128, 'kchapman3k@netvibes.com', '1971-12-13', '8 Roth Parkway', 'Katherine Chapman', '675-(919)716-5176', 'F', '353816846');
insert into Employee (emp_id, email, date_of_birth, address, name, phone_number, gender, sin) values (129, 'dgarcia3l@goo.ne.jp', '1967-04-21', '66 Parkside Trail', 'Denise Garcia', '62-(897)929-7959', 'F', '633330453');
insert into Employee (emp_id, email, date_of_birth, address, name, phone_number, gender, sin) values (130, 'emorrison3m@nhs.uk', '1995-07-09', '9943 Hallows Junction', 'Ernest Morrison', '505-(891)682-1910', 'M', '558530045');
insert into Employee (emp_id, email, date_of_birth, address, name, phone_number, gender, sin) values (131, 'lsullivan3n@netlog.com', '1995-07-07', '45 Brentwood Parkway', 'Linda Sullivan', '86-(251)457-1984', 'F', '354455603');
insert into Employee (emp_id, email, date_of_birth, address, name, phone_number, gender, sin) values (132, 'kgreene3o@paypal.com', '1961-06-24', '7324 Declaration Park', 'Kevin Greene', '86-(114)649-2815', 'M', '564182586');
insert into Employee (emp_id, email, date_of_birth, address, name, phone_number, gender, sin) values (133, 'dweaver3p@booking.com', '1975-11-26', '0 Sycamore Park', 'Daniel Weaver', '212-(792)786-4399', 'M', '493622034');
insert into Employee (emp_id, email, date_of_birth, address, name, phone_number, gender, sin) values (134, 'fbarnes3q@abc.net.au', '1969-10-24', '701 Hovde Trail', 'Frances Barnes', '1-(114)982-4314', 'F', '402653853');
insert into Employee (emp_id, email, date_of_birth, address, name, phone_number, gender, sin) values (135, 'rharris3r@usa.gov', '1989-06-27', '11 Morning Junction', 'Ruby Harris', '351-(803)358-4183', 'F', '515471053');
insert into Employee (emp_id, email, date_of_birth, address, name, phone_number, gender, sin) values (136, 'bclark3s@tripadvisor.com', '1979-01-14', '4 Judy Parkway', 'Brian Clark', '420-(244)342-2624', 'M', '358891488');
insert into Employee (emp_id, email, date_of_birth, address, name, phone_number, gender, sin) values (137, 'jdiaz3t@oracle.com', '1990-06-13', '20 Bay Alley', 'Jack Diaz', '880-(996)704-3770', 'M', '510014634');
insert into Employee (emp_id, email, date_of_birth, address, name, phone_number, gender, sin) values (138, 'kschmidt3u@jalbum.net', '1957-10-04', '76 Sugar Hill', 'Kimberly Schmidt', '48-(925)175-8581', 'F', '357366740');
insert into Employee (emp_id, email, date_of_birth, address, name, phone_number, gender, sin) values (139, 'ahayes3v@auda.org.au', '1978-08-07', '9908 Continental Terrace', 'Alan Hayes', '7-(134)323-3900', 'M', '510017061');
insert into Employee (emp_id, email, date_of_birth, address, name, phone_number, gender, sin) values (140, 'kduncan3w@yandex.ru', '1968-02-19', '542 Utah Park', 'Kathryn Duncan', '84-(197)870-2026', 'F', '356540418');
insert into Employee (emp_id, email, date_of_birth, address, name, phone_number, gender, sin) values (141, 'alewis3x@slideshare.net', '1988-01-17', '884 Oakridge Terrace', 'Andrew Lewis', '507-(280)878-7345', 'M', '358932033');
insert into Employee (emp_id, email, date_of_birth, address, name, phone_number, gender, sin) values (142, 'blarson3y@goo.gl', '1976-03-18', '287 Warrior Drive', 'Beverly Larson', '55-(345)738-5390', 'F', '354357310');
insert into Employee (emp_id, email, date_of_birth, address, name, phone_number, gender, sin) values (143, 'jwelch3z@over-blog.com', '1958-08-22', '7 Mifflin Trail', 'Janet Welch', '237-(259)106-8638', 'F', '354843407');
insert into Employee (emp_id, email, date_of_birth, address, name, phone_number, gender, sin) values (144, 'shamilton40@bigcartel.com', '1958-06-16', '45916 Donald Street', 'Shirley Hamilton', '371-(312)405-0693', 'F', '561096771');
insert into Employee (emp_id, email, date_of_birth, address, name, phone_number, gender, sin) values (145, 'sday41@discovery.com', '1962-07-15', '1403 Summerview Place', 'Steven Day', '62-(790)781-4999', 'M', '353180027');
insert into Employee (emp_id, email, date_of_birth, address, name, phone_number, gender, sin) values (146, 'kwatkins42@xinhuanet.com', '1987-12-02', '5 Bobwhite Avenue', 'Kathy Watkins', '62-(824)295-4724', 'F', '355804179');
insert into Employee (emp_id, email, date_of_birth, address, name, phone_number, gender, sin) values (147, 'jclark43@zdnet.com', '1982-04-20', '7 Carey Road', 'Joan Clark', '62-(821)851-8797', 'F', '300590643');
insert into Employee (emp_id, email, date_of_birth, address, name, phone_number, gender, sin) values (148, 'cboyd44@example.com', '1979-04-30', '7317 Eagan Point', 'Cynthia Boyd', '380-(664)362-5315', 'F', '354880996');
insert into Employee (emp_id, email, date_of_birth, address, name, phone_number, gender, sin) values (149, 'jhunt45@yellowbook.com', '1964-02-15', '9828 Rutledge Place', 'Jean Hunt', '86-(356)194-4726', 'F', '555875301');
insert into Employee (emp_id, email, date_of_birth, address, name, phone_number, gender, sin) values (150, 'agibson46@istockphoto.com', '1980-02-07', '73839 Miller Circle', 'Amanda Gibson', '86-(837)902-9401', 'F', '560225761');
insert into Employee (emp_id, email, date_of_birth, address, name, phone_number, gender, sin) values (151, 'hwalker47@altervista.org', '1989-01-02', '30 Stone Corner Junction', 'Heather Walker', '81-(649)155-5465', 'F', '374622531');
insert into Employee (emp_id, email, date_of_birth, address, name, phone_number, gender, sin) values (152, 'dstone48@mozilla.com', '1984-03-31', '22 Dryden Road', 'Denise Stone', '358-(982)933-6403', 'F', '358965358');
insert into Employee (emp_id, email, date_of_birth, address, name, phone_number, gender, sin) values (153, 'grodriguez49@independent.co.uk', '1992-10-18', '5 Gale Plaza', 'George Rodriguez', '84-(485)897-5332', 'M', '564182569');
insert into Employee (emp_id, email, date_of_birth, address, name, phone_number, gender, sin) values (154, 'swagner4a@squidoo.com', '1957-10-02', '608 Longview Way', 'Steve Wagner', '48-(358)461-6626', 'M', '201774173');
insert into Employee (emp_id, email, date_of_birth, address, name, phone_number, gender, sin) values (155, 'jhoward4b@smugmug.com', '1988-05-19', '8 Blaine Terrace', 'Justin Howard', '1-(204)302-4290', 'M', '677159899');
insert into Employee (emp_id, email, date_of_birth, address, name, phone_number, gender, sin) values (156, 'ccarter4c@yellowpages.com', '1996-08-04', '34477 Lien Lane', 'Christina Carter', '86-(903)144-5512', 'F', '560225560');
insert into Employee (emp_id, email, date_of_birth, address, name, phone_number, gender, sin) values (157, 'glynch4d@si.edu', '1968-07-06', '12 Ruskin Drive', 'Gloria Lynch', '86-(892)288-9791', 'F', '356515539');
insert into Employee (emp_id, email, date_of_birth, address, name, phone_number, gender, sin) values (158, 'rwatkins4e@php.net', '1982-12-14', '5 Anderson Center', 'Ralph Watkins', '86-(416)254-3498', 'M', '357562477');
insert into Employee (emp_id, email, date_of_birth, address, name, phone_number, gender, sin) values (159, 'mmarshall4f@ucla.edu', '1986-11-18', '2279 Kipling Parkway', 'Michael Marshall', '261-(109)979-0590', 'M', '355792479');
insert into Employee (emp_id, email, date_of_birth, address, name, phone_number, gender, sin) values (160, 'bfranklin4g@google.ca', '1982-09-03', '096 Aberg Crossing', 'Brandon Franklin', '63-(461)914-7045', 'M', '356948147');
insert into Employee (emp_id, email, date_of_birth, address, name, phone_number, gender, sin) values (161, 'bevans4h@deviantart.com', '1962-05-07', '753 Erie Hill', 'Brandon Evans', '967-(927)244-7116', 'M', '560223151');
insert into Employee (emp_id, email, date_of_birth, address, name, phone_number, gender, sin) values (162, 'dlong4i@dropbox.com', '1975-05-24', '61 Ridgeway Pass', 'Diana Long', '33-(526)336-2282', 'F', '353646544');
insert into Employee (emp_id, email, date_of_birth, address, name, phone_number, gender, sin) values (163, 'jford4j@tmall.com', '1964-03-15', '2828 Village Green Trail', 'Jessica Ford', '62-(360)418-9899', 'F', '337941391');
insert into Employee (emp_id, email, date_of_birth, address, name, phone_number, gender, sin) values (164, 'akelly4k@dropbox.com', '1975-09-18', '3 Butternut Point', 'Annie Kelly', '51-(908)514-8435', 'F', '561014613');
insert into Employee (emp_id, email, date_of_birth, address, name, phone_number, gender, sin) values (165, 'spatterson4l@uiuc.edu', '1981-11-04', '50 Logan Drive', 'Shawn Patterson', '352-(203)301-2312', 'M', '677179032');
insert into Employee (emp_id, email, date_of_birth, address, name, phone_number, gender, sin) values (166, 'gortiz4m@cnbc.com', '1967-08-22', '45635 Forest Dale Plaza', 'George Ortiz', '63-(657)579-0427', 'M', '354210560');
insert into Employee (emp_id, email, date_of_birth, address, name, phone_number, gender, sin) values (167, 'sbarnes4n@shareasale.com', '1966-10-25', '92 Ryan Way', 'Shawn Barnes', '57-(634)237-9078', 'M', '630423751');
insert into Employee (emp_id, email, date_of_birth, address, name, phone_number, gender, sin) values (168, 'dchapman4o@artisteer.com', '1964-02-26', '98247 Laurel Avenue', 'Dennis Chapman', '62-(793)460-1795', 'M', '676396814');
insert into Employee (emp_id, email, date_of_birth, address, name, phone_number, gender, sin) values (169, 'jmoore4p@reuters.com', '1987-05-14', '9588 8th Road', 'Jessica Moore', '62-(159)891-9489', 'F', '356441891');
insert into Employee (emp_id, email, date_of_birth, address, name, phone_number, gender, sin) values (170, 'jward4q@ebay.co.uk', '1988-05-28', '05953 Milwaukee Center', 'Justin Ward', '7-(288)961-9825', 'M', '493624383');
insert into Employee (emp_id, email, date_of_birth, address, name, phone_number, gender, sin) values (171, 'arobertson4r@google.ca', '1984-06-25', '3 Novick Pass', 'Anne Robertson', '47-(973)999-5556', 'F', '561056797');
insert into Employee (emp_id, email, date_of_birth, address, name, phone_number, gender, sin) values (172, 'trodriguez4s@arizona.edu', '1960-08-28', '8 Rusk Plaza', 'Theresa Rodriguez', '504-(931)254-0161', 'F', '355171085');
insert into Employee (emp_id, email, date_of_birth, address, name, phone_number, gender, sin) values (173, 'tfisher4t@springer.com', '1962-02-09', '37090 Waubesa Pass', 'Timothy Fisher', '7-(873)238-4925', 'M', '305281383');
insert into Employee (emp_id, email, date_of_birth, address, name, phone_number, gender, sin) values (174, 'ashaw4u@blinklist.com', '1970-01-06', '36631 Monica Terrace', 'Andrew Shaw', '352-(688)634-8819', 'M', '362705937');
insert into Employee (emp_id, email, date_of_birth, address, name, phone_number, gender, sin) values (175, 'drice4v@quantcast.com', '1992-07-24', '5979 Dorton Way', 'Deborah Rice', '46-(845)958-9878', 'F', '300958049');
insert into Employee (emp_id, email, date_of_birth, address, name, phone_number, gender, sin) values (176, 'rmorrison4w@bloglines.com', '1981-01-18', '226 Northridge Way', 'Rose Morrison', '33-(223)329-2242', 'F', '353796386');
insert into Employee (emp_id, email, date_of_birth, address, name, phone_number, gender, sin) values (177, 'jfoster4x@usnews.com', '1983-05-20', '74 Westerfield Park', 'Julia Foster', '261-(415)215-0674', 'F', '561076639');
insert into Employee (emp_id, email, date_of_birth, address, name, phone_number, gender, sin) values (178, 'pbrown4y@over-blog.com', '1957-07-22', '1459 Green Place', 'Philip Brown', '86-(768)716-7220', 'M', '560225237');
insert into Employee (emp_id, email, date_of_birth, address, name, phone_number, gender, sin) values (179, 'msimpson4z@bigcartel.com', '1995-04-16', '00147 Sheridan Street', 'Michelle Simpson', '355-(893)880-8037', 'F', '355225707');
insert into Employee (emp_id, email, date_of_birth, address, name, phone_number, gender, sin) values (180, 'mandrews50@howstuffworks.com', '1969-05-15', '7 Dottie Street', 'Melissa Andrews', '55-(438)392-6423', 'F', '676385260');
insert into Employee (emp_id, email, date_of_birth, address, name, phone_number, gender, sin) values (181, 'smurphy51@netvibes.com', '1986-04-04', '6959 Northland Avenue', 'Steven Murphy', '86-(474)587-0686', 'M', '374622809');
insert into Employee (emp_id, email, date_of_birth, address, name, phone_number, gender, sin) values (182, 'jperkins52@upenn.edu', '1994-04-23', '5 Welch Crossing', 'Jonathan Perkins', '27-(509)533-3602', 'M', '374283780');
insert into Employee (emp_id, email, date_of_birth, address, name, phone_number, gender, sin) values (183, 'cburke53@amazon.co.uk', '1973-05-06', '4482 Scofield Avenue', 'Clarence Burke', '976-(734)329-1959', 'M', '060455039');
insert into Employee (emp_id, email, date_of_birth, address, name, phone_number, gender, sin) values (184, 'whamilton54@state.gov', '1979-12-10', '23 Becker Drive', 'Walter Hamilton', '81-(293)107-6641', 'M', '589316013');
insert into Employee (emp_id, email, date_of_birth, address, name, phone_number, gender, sin) values (185, 'epeters55@artisteer.com', '1986-11-29', '8 Artisan Street', 'Elizabeth Peters', '54-(906)541-1493', 'F', '560224557');
insert into Employee (emp_id, email, date_of_birth, address, name, phone_number, gender, sin) values (186, 'bford56@vk.com', '1994-04-13', '7 Green Ridge Trail', 'Brian Ford', '52-(872)327-4061', 'M', '355560279');
insert into Employee (emp_id, email, date_of_birth, address, name, phone_number, gender, sin) values (187, 'dryan57@is.gd', '1981-12-07', '65 Graedel Place', 'Donna Ryan', '86-(396)984-9736', 'F', '510017310');
insert into Employee (emp_id, email, date_of_birth, address, name, phone_number, gender, sin) values (188, 'jjohnston58@istockphoto.com', '1991-06-04', '115 Reinke Way', 'James Johnston', '1-(322)966-4359', 'M', '201736664');
insert into Employee (emp_id, email, date_of_birth, address, name, phone_number, gender, sin) values (189, 'cpierce59@drupal.org', '1961-01-27', '8182 Towne Junction', 'Craig Pierce', '351-(424)817-3271', 'M', '460759603');
insert into Employee (emp_id, email, date_of_birth, address, name, phone_number, gender, sin) values (190, 'kwilliamson5a@comsenz.com', '1983-03-01', '98932 Johnson Park', 'Kevin Williamson', '86-(521)902-8560', 'M', '560223719');
insert into Employee (emp_id, email, date_of_birth, address, name, phone_number, gender, sin) values (191, 'cdunn5b@engadget.com', '1991-10-19', '39238 Canary Lane', 'Catherine Dunn', '63-(675)830-2045', 'F', '560225154');
insert into Employee (emp_id, email, date_of_birth, address, name, phone_number, gender, sin) values (192, 'phughes5c@wisc.edu', '1970-04-29', '19 Grim Road', 'Paul Hughes', '967-(515)716-1168', 'M', '560221872');
insert into Employee (emp_id, email, date_of_birth, address, name, phone_number, gender, sin) values (193, 'lramos5d@amazon.com', '1970-03-21', '020 1st Hill', 'Louis Ramos', '976-(763)958-9618', 'M', '353503844');
insert into Employee (emp_id, email, date_of_birth, address, name, phone_number, gender, sin) values (194, 'abaker5e@posterous.com', '1964-11-19', '762 Jackson Lane', 'Anne Baker', '86-(158)257-2429', 'F', '357677579');
insert into Employee (emp_id, email, date_of_birth, address, name, phone_number, gender, sin) values (195, 'jcunningham5f@rakuten.co.jp', '1977-11-19', '794 Springview Pass', 'Jacqueline Cunningham', '55-(546)561-0342', 'F', '560222636');
insert into Employee (emp_id, email, date_of_birth, address, name, phone_number, gender, sin) values (196, 'sfrazier5g@hugedomains.com', '1957-10-02', '5 Holmberg Hill', 'Samuel Frazier', '46-(462)897-5494', 'M', '354547649');
insert into Employee (emp_id, email, date_of_birth, address, name, phone_number, gender, sin) values (197, 'rfields5h@pcworld.com', '1981-02-28', '292 Truax Alley', 'Robert Fields', '52-(714)445-2896', 'M', '201710425');
insert into Employee (emp_id, email, date_of_birth, address, name, phone_number, gender, sin) values (198, 'jday5i@tumblr.com', '1960-02-24', '1555 Roxbury Alley', 'Jack Day', '30-(429)704-6698', 'M', '546737440');
insert into Employee (emp_id, email, date_of_birth, address, name, phone_number, gender, sin) values (199, 'bhawkins5j@cornell.edu', '1984-12-07', '23 Forest Junction', 'Bruce Hawkins', '63-(582)228-1473', 'M', '353726530');
insert into Employee (emp_id, email, date_of_birth, address, name, phone_number, gender, sin) values (200, 'nwheeler5k@epa.gov', '1970-12-23', '92 Graceland Place', 'Nicole Wheeler', '63-(911)735-5829', 'F', '637092534');
insert into Employee (emp_id, email, date_of_birth, address, name, phone_number, gender, sin) values (201, 'kfields5l@tuttocitta.it', '1965-01-22', '3459 Union Drive', 'Kelly Fields', '86-(637)872-7701', 'F', '491374430');
insert into Employee (emp_id, email, date_of_birth, address, name, phone_number, gender, sin) values (202, 'hjenkins5m@list-manage.com', '1958-07-16', '42 Springs Plaza', 'Heather Jenkins', '62-(440)207-7837', 'F', '358512539');
insert into Employee (emp_id, email, date_of_birth, address, name, phone_number, gender, sin) values (203, 'jburke5n@who.int', '1966-05-17', '94 Chive Avenue', 'Joseph Burke', '62-(842)169-0641', 'M', '201886553');
insert into Employee (emp_id, email, date_of_birth, address, name, phone_number, gender, sin) values (204, 'dedwards5o@aol.com', '1959-04-30', '80635 Twin Pines Lane', 'Diane Edwards', '234-(693)215-8496', 'F', '404159873');
insert into Employee (emp_id, email, date_of_birth, address, name, phone_number, gender, sin) values (205, 'ksnyder5p@plala.or.jp', '1972-11-27', '5060 Talmadge Avenue', 'Karen Snyder', '86-(723)250-7170', 'F', '358636744');
insert into Employee (emp_id, email, date_of_birth, address, name, phone_number, gender, sin) values (206, 'swelch5q@google.it', '1957-09-20', '7 Maryland Drive', 'Samuel Welch', '7-(348)646-5184', 'M', '358102245');
insert into Employee (emp_id, email, date_of_birth, address, name, phone_number, gender, sin) values (207, 'abowman5r@mapy.cz', '1983-12-17', '17 Brown Street', 'Andrew Bowman', '86-(913)217-2706', 'M', '357286915');
insert into Employee (emp_id, email, date_of_birth, address, name, phone_number, gender, sin) values (208, 'pwhite5s@springer.com', '1963-03-19', '98865 Superior Junction', 'Patricia White', '7-(939)928-4715', 'F', '353559112');
insert into Employee (emp_id, email, date_of_birth, address, name, phone_number, gender, sin) values (209, 'sgray5t@flickr.com', '1993-11-05', '630 Scofield Avenue', 'Susan Gray', '62-(411)309-7267', 'F', '353787017');
insert into Employee (emp_id, email, date_of_birth, address, name, phone_number, gender, sin) values (210, 'jhernandez5u@reference.com', '1968-11-13', '64 8th Parkway', 'Joshua Hernandez', '44-(299)520-4299', 'M', '355539227');
insert into Employee (emp_id, email, date_of_birth, address, name, phone_number, gender, sin) values (211, 'sbaker5v@sina.com.cn', '1973-05-23', '42 Stephen Pass', 'Samuel Baker', '84-(996)935-0870', 'M', '353462217');
insert into Employee (emp_id, email, date_of_birth, address, name, phone_number, gender, sin) values (212, 'lmorgan5w@apple.com', '1971-10-10', '334 Sachtjen Point', 'Laura Morgan', '7-(365)530-2029', 'F', '356930285');
insert into Employee (emp_id, email, date_of_birth, address, name, phone_number, gender, sin) values (213, 'jboyd5x@quantcast.com', '1967-12-28', '73237 Stoughton Trail', 'Jean Boyd', '86-(328)242-0255', 'F', '300428171');
insert into Employee (emp_id, email, date_of_birth, address, name, phone_number, gender, sin) values (214, 'pspencer5y@aol.com', '1963-08-12', '56 Blue Bill Park Avenue', 'Philip Spencer', '86-(328)343-9752', 'M', '060454348');
insert into Employee (emp_id, email, date_of_birth, address, name, phone_number, gender, sin) values (215, 'cbrown5z@msu.edu', '1985-11-19', '94 Banding Point', 'Chris Brown', '7-(181)818-6173', 'M', '561080496');
insert into Employee (emp_id, email, date_of_birth, address, name, phone_number, gender, sin) values (216, 'ihenry60@amazon.co.uk', '1971-03-06', '3 Ohio Terrace', 'Irene Henry', '1-(209)439-9524', 'F', '354218940');
insert into Employee (emp_id, email, date_of_birth, address, name, phone_number, gender, sin) values (217, 'rperry61@rakuten.co.jp', '1960-05-31', '20009 Mallory Road', 'Randy Perry', '86-(186)177-1903', 'M', '356881442');
insert into Employee (emp_id, email, date_of_birth, address, name, phone_number, gender, sin) values (218, 'ksimpson62@com.com', '1975-08-26', '5 Debra Alley', 'Katherine Simpson', '62-(446)374-3855', 'F', '356991020');
insert into Employee (emp_id, email, date_of_birth, address, name, phone_number, gender, sin) values (219, 'mfernandez63@cnet.com', '1974-12-27', '359 Atwood Parkway', 'Mildred Fernandez', '1-(918)307-0802', 'F', '491125169');
insert into Employee (emp_id, email, date_of_birth, address, name, phone_number, gender, sin) values (220, 'mellis64@google.ru', '1994-01-08', '4 Bellgrove Hill', 'Martin Ellis', '56-(833)812-0631', 'M', '491193742');
insert into Employee (emp_id, email, date_of_birth, address, name, phone_number, gender, sin) values (221, 'jmedina65@economist.com', '1980-07-02', '2566 Crownhardt Crossing', 'Jennifer Medina', '385-(253)969-2727', 'F', '561083211');
insert into Employee (emp_id, email, date_of_birth, address, name, phone_number, gender, sin) values (222, 'bharper66@answers.com', '1973-09-14', '54 Bluestem Plaza', 'Brian Harper', '358-(648)730-2636', 'M', '633312744');
insert into Employee (emp_id, email, date_of_birth, address, name, phone_number, gender, sin) values (223, 'dhoward67@cargocollective.com', '1970-08-16', '6 Messerschmidt Hill', 'Donna Howard', '86-(509)508-5033', 'F', '404137709');
insert into Employee (emp_id, email, date_of_birth, address, name, phone_number, gender, sin) values (224, 'jmartin68@phpbb.com', '1959-03-26', '140 Valley Edge Place', 'Janet Martin', '385-(999)703-1068', 'F', '356952123');
insert into Employee (emp_id, email, date_of_birth, address, name, phone_number, gender, sin) values (225, 'rwhite69@abc.net.au', '1970-11-12', '6030 Barby Parkway', 'Roger White', '86-(766)883-0897', 'M', '356125784');
insert into Employee (emp_id, email, date_of_birth, address, name, phone_number, gender, sin) values (226, 'rblack6a@oakley.com', '1976-04-25', '9 Merrick Point', 'Rachel Black', '62-(468)104-4512', 'F', '355101272');
insert into Employee (emp_id, email, date_of_birth, address, name, phone_number, gender, sin) values (227, 'ssanchez6b@webmd.com', '1993-01-01', '7 Macpherson Junction', 'Sarah Sanchez', '351-(555)399-6923', 'F', '358465836');
insert into Employee (emp_id, email, date_of_birth, address, name, phone_number, gender, sin) values (228, 'dlopez6c@moonfruit.com', '1969-11-21', '4947 Randy Place', 'Doris Lopez', '86-(626)817-9826', 'F', '357851539');
insert into Employee (emp_id, email, date_of_birth, address, name, phone_number, gender, sin) values (229, 'srose6d@blogspot.com', '1982-02-24', '771 Vernon Drive', 'Steve Rose', '976-(567)430-5752', 'M', '560224473');
insert into Employee (emp_id, email, date_of_birth, address, name, phone_number, gender, sin) values (230, 'mwilliamson6e@cnn.com', '1990-05-13', '67040 Portage Road', 'Margaret Williamson', '62-(184)596-5362', 'F', '675906190');
insert into Employee (emp_id, email, date_of_birth, address, name, phone_number, gender, sin) values (231, 'efranklin6f@engadget.com', '1971-07-07', '69949 Forest Dale Point', 'Eric Franklin', '62-(675)879-7956', 'M', '633458099');
insert into Employee (emp_id, email, date_of_birth, address, name, phone_number, gender, sin) values (232, 'ljones6g@shop-pro.jp', '1970-01-21', '5028 Logan Road', 'Lori Jones', '86-(350)648-7939', 'F', '356906621');
insert into Employee (emp_id, email, date_of_birth, address, name, phone_number, gender, sin) values (233, 'pmoore6h@merriam-webster.com', '1962-08-21', '04 Evergreen Center', 'Paul Moore', '86-(133)904-2122', 'M', '356085065');
insert into Employee (emp_id, email, date_of_birth, address, name, phone_number, gender, sin) values (234, 'mrichards6i@webnode.com', '1989-02-15', '8660 West Crossing', 'Melissa Richards', '55-(105)290-9811', 'F', '500235306');
insert into Employee (emp_id, email, date_of_birth, address, name, phone_number, gender, sin) values (235, 'jhenderson6j@admin.ch', '1962-12-16', '75180 Pine View Point', 'Jessica Henderson', '967-(422)300-0375', 'F', '347563020');
insert into Employee (emp_id, email, date_of_birth, address, name, phone_number, gender, sin) values (236, 'ppatterson6k@themeforest.net', '1980-12-04', '6 Union Drive', 'Peter Patterson', '33-(379)894-3708', 'M', '560224355');
insert into Employee (emp_id, email, date_of_birth, address, name, phone_number, gender, sin) values (237, 'ddavis6l@zdnet.com', '1982-06-10', '809 Milwaukee Court', 'Dennis Davis', '595-(496)403-4650', 'M', '354073463');
insert into Employee (emp_id, email, date_of_birth, address, name, phone_number, gender, sin) values (238, 'rjenkins6m@npr.org', '1985-07-01', '8371 Becker Parkway', 'Roger Jenkins', '962-(896)961-9195', 'M', '676140164');
insert into Employee (emp_id, email, date_of_birth, address, name, phone_number, gender, sin) values (239, 'sross6n@about.com', '1980-01-27', '168 Holmberg Court', 'Samuel Ross', '507-(873)111-4222', 'M', '353614507');
insert into Employee (emp_id, email, date_of_birth, address, name, phone_number, gender, sin) values (240, 'rbradley6o@ft.com', '1973-10-27', '92 Michigan Court', 'Ronald Bradley', '51-(107)536-4447', 'M', '638917819');
insert into Employee (emp_id, email, date_of_birth, address, name, phone_number, gender, sin) values (241, 'jreynolds6p@ihg.com', '1985-05-03', '384 Mockingbird Drive', 'Jacqueline Reynolds', '255-(474)783-1542', 'F', '358535325');
insert into Employee (emp_id, email, date_of_birth, address, name, phone_number, gender, sin) values (242, 'ljohnston6q@vimeo.com', '1989-11-20', '1 Prairieview Circle', 'Laura Johnston', '30-(831)454-8643', 'F', '355268026');
insert into Employee (emp_id, email, date_of_birth, address, name, phone_number, gender, sin) values (243, 'wfrazier6r@networksolutions.com', '1985-03-18', '0 Veith Center', 'Walter Frazier', '212-(442)740-1594', 'M', '356297157');
insert into Employee (emp_id, email, date_of_birth, address, name, phone_number, gender, sin) values (244, 'amitchell6s@globo.com', '1966-12-06', '1 Forest Dale Circle', 'Albert Mitchell', '66-(248)953-2147', 'M', '491133808');
insert into Employee (emp_id, email, date_of_birth, address, name, phone_number, gender, sin) values (245, 'griley6t@rambler.ru', '1991-06-30', '25857 Packers Place', 'Gary Riley', '62-(969)231-6964', 'M', '500235027');
insert into Employee (emp_id, email, date_of_birth, address, name, phone_number, gender, sin) values (246, 'dgarza6u@nymag.com', '1968-07-23', '71587 Artisan Park', 'Diana Garza', '62-(464)557-0125', 'F', '357707368');
insert into Employee (emp_id, email, date_of_birth, address, name, phone_number, gender, sin) values (247, 'dferguson6v@psu.edu', '1969-06-10', '73054 Washington Court', 'Dorothy Ferguson', '46-(887)704-5875', 'F', '417500213');
insert into Employee (emp_id, email, date_of_birth, address, name, phone_number, gender, sin) values (248, 'rward6w@yellowbook.com', '1987-06-07', '53 Meadow Vale Pass', 'Roy Ward', '62-(906)731-3727', 'M', '358887991');
insert into Employee (emp_id, email, date_of_birth, address, name, phone_number, gender, sin) values (249, 'cgray6x@amazon.co.jp', '1967-03-15', '28778 Green Ridge Drive', 'Carlos Gray', '86-(788)478-4629', 'M', '490384520');
insert into Employee (emp_id, email, date_of_birth, address, name, phone_number, gender, sin) values (250, 'erobertson6y@diigo.com', '1976-08-08', '25695 7th Crossing', 'Edward Robertson', '351-(651)774-8721', 'M', '358710541');
insert into Employee (emp_id, email, date_of_birth, address, name, phone_number, gender, sin) values (251, 'bboyd6z@goodreads.com', '1972-10-14', '02 Lerdahl Lane', 'Barbara Boyd', '86-(284)624-7431', 'F', '357366953');
insert into Employee (emp_id, email, date_of_birth, address, name, phone_number, gender, sin) values (252, 'aramos70@wikia.com', '1993-05-30', '52 Porter Crossing', 'Ann Ramos', '81-(795)160-2541', 'F', '357459064');
insert into Employee (emp_id, email, date_of_birth, address, name, phone_number, gender, sin) values (253, 'fdavis71@uiuc.edu', '1989-03-09', '0 Mayer Place', 'Fred Davis', '351-(579)368-1628', 'M', '354516117');
insert into Employee (emp_id, email, date_of_birth, address, name, phone_number, gender, sin) values (254, 'jdavis72@newsvine.com', '1990-01-27', '10900 Lotheville Avenue', 'Janice Davis', '98-(931)178-1167', 'F', '491743530');
insert into Employee (emp_id, email, date_of_birth, address, name, phone_number, gender, sin) values (255, 'dwood73@java.com', '1985-12-26', '479 Gulseth Trail', 'Diana Wood', '60-(753)494-6986', 'F', '560222026');
insert into Employee (emp_id, email, date_of_birth, address, name, phone_number, gender, sin) values (256, 'mdunn74@sun.com', '1978-11-14', '23 Carpenter Point', 'Martin Dunn', '351-(542)678-3229', 'M', '357785920');
insert into Employee (emp_id, email, date_of_birth, address, name, phone_number, gender, sin) values (257, 'doliver75@yellowpages.com', '1962-03-31', '7524 Vidon Park', 'Deborah Oliver', '86-(563)313-1012', 'F', '201891829');
insert into Employee (emp_id, email, date_of_birth, address, name, phone_number, gender, sin) values (258, 'lolson76@smh.com.au', '1993-11-19', '63115 Moose Road', 'Laura Olson', '86-(117)522-4822', 'F', '557422998');
insert into Employee (emp_id, email, date_of_birth, address, name, phone_number, gender, sin) values (259, 'hmartin77@china.com.cn', '1958-11-01', '3 Canary Court', 'Howard Martin', '7-(989)858-2304', 'M', '510017284');
insert into Employee (emp_id, email, date_of_birth, address, name, phone_number, gender, sin) values (260, 'ccarter78@cornell.edu', '1966-09-11', '84436 Ridge Oak Hill', 'Carlos Carter', '55-(878)643-5416', 'M', '404159688');
insert into Employee (emp_id, email, date_of_birth, address, name, phone_number, gender, sin) values (261, 'awheeler79@mapy.cz', '1987-05-05', '385 Center Avenue', 'Adam Wheeler', '86-(103)578-3269', 'M', '676266482');
insert into Employee (emp_id, email, date_of_birth, address, name, phone_number, gender, sin) values (262, 'aalvarez7a@csmonitor.com', '1970-04-10', '9885 Division Circle', 'Amy Alvarez', '252-(660)709-3841', 'F', '358755034');
insert into Employee (emp_id, email, date_of_birth, address, name, phone_number, gender, sin) values (263, 'bhowell7b@deviantart.com', '1961-10-05', '889 Calypso Avenue', 'Brandon Howell', '380-(828)191-5792', 'M', '353348402');
insert into Employee (emp_id, email, date_of_birth, address, name, phone_number, gender, sin) values (264, 'athomas7c@123-reg.co.uk', '1971-01-19', '75240 Bultman Plaza', 'Arthur Thomas', '55-(703)309-5687', 'M', '356124940');
insert into Employee (emp_id, email, date_of_birth, address, name, phone_number, gender, sin) values (265, 'smorales7d@twitpic.com', '1959-12-11', '3 Mifflin Alley', 'Stephen Morales', '86-(764)446-8942', 'M', '357067158');
insert into Employee (emp_id, email, date_of_birth, address, name, phone_number, gender, sin) values (266, 'acollins7e@cocolog-nifty.com', '1982-09-09', '9052 Bobwhite Alley', 'Alice Collins', '976-(821)772-9965', 'F', '353555125');
insert into Employee (emp_id, email, date_of_birth, address, name, phone_number, gender, sin) values (267, 'pdean7f@yolasite.com', '1966-08-05', '41 Nevada Lane', 'Pamela Dean', '86-(716)415-8232', 'F', '560223804');
insert into Employee (emp_id, email, date_of_birth, address, name, phone_number, gender, sin) values (268, 'hrice7g@whitehouse.gov', '1970-12-05', '7474 Eagan Drive', 'Harold Rice', '63-(727)358-7950', 'M', '352801211');
insert into Employee (emp_id, email, date_of_birth, address, name, phone_number, gender, sin) values (269, 'jjohnson7h@webmd.com', '1969-04-02', '22710 Canary Way', 'Jennifer Johnson', '62-(992)443-9721', 'F', '201767102');
insert into Employee (emp_id, email, date_of_birth, address, name, phone_number, gender, sin) values (270, 'cfrazier7i@studiopress.com', '1991-08-09', '58 Kingsford Crossing', 'Carl Frazier', '7-(565)588-5617', 'M', '402685940');
insert into Employee (emp_id, email, date_of_birth, address, name, phone_number, gender, sin) values (271, 'jwells7j@hugedomains.com', '1983-02-15', '99749 Scoville Point', 'Janet Wells', '213-(417)741-8036', 'F', '510875636');
insert into Employee (emp_id, email, date_of_birth, address, name, phone_number, gender, sin) values (272, 'pmorris7k@samsung.com', '1986-07-24', '2 Bayside Park', 'Phyllis Morris', '62-(792)615-1962', 'F', '560225476');
insert into Employee (emp_id, email, date_of_birth, address, name, phone_number, gender, sin) values (273, 'jhanson7l@google.com.br', '1992-10-22', '36270 Florence Crossing', 'Jack Hanson', '51-(895)177-5196', 'M', '670903182');
insert into Employee (emp_id, email, date_of_birth, address, name, phone_number, gender, sin) values (274, 'escott7m@imageshack.us', '1957-09-16', '415 Dwight Alley', 'Eric Scott', '51-(784)342-0787', 'M', '402617273');
insert into Employee (emp_id, email, date_of_birth, address, name, phone_number, gender, sin) values (275, 'jwood7n@pinterest.com', '1972-07-07', '1 Warrior Place', 'Jack Wood', '1-(310)661-3943', 'M', '589383266');
insert into Employee (emp_id, email, date_of_birth, address, name, phone_number, gender, sin) values (276, 'mtucker7o@cisco.com', '1957-02-04', '191 Hollow Ridge Plaza', 'Martin Tucker', '52-(233)813-9932', 'M', '356062258');
insert into Employee (emp_id, email, date_of_birth, address, name, phone_number, gender, sin) values (277, 'dgilbert7p@wp.com', '1972-02-01', '4 Mayer Center', 'Dennis Gilbert', '33-(360)727-5680', 'M', '372301958');
insert into Employee (emp_id, email, date_of_birth, address, name, phone_number, gender, sin) values (278, 'rking7q@cbsnews.com', '1984-05-16', '4856 Burning Wood Crossing', 'Randy King', '86-(965)533-5263', 'M', '560221315');
insert into Employee (emp_id, email, date_of_birth, address, name, phone_number, gender, sin) values (279, 'alee7r@prnewswire.com', '1988-07-31', '669 Tomscot Way', 'Amanda Lee', '66-(910)777-8846', 'F', '354060771');
insert into Employee (emp_id, email, date_of_birth, address, name, phone_number, gender, sin) values (280, 'awilliams7s@quantcast.com', '1983-08-20', '0147 Anthes Pass', 'Arthur Williams', '62-(813)516-3111', 'M', '493643090');
insert into Employee (emp_id, email, date_of_birth, address, name, phone_number, gender, sin) values (281, 'lburton7t@cocolog-nifty.com', '1972-01-05', '108 Gina Drive', 'Lillian Burton', '374-(503)869-3504', 'F', '305246038');
insert into Employee (emp_id, email, date_of_birth, address, name, phone_number, gender, sin) values (282, 'hbutler7u@who.int', '1977-07-12', '2 Rowland Lane', 'Howard Butler', '234-(605)338-4595', 'M', '201667724');
insert into Employee (emp_id, email, date_of_birth, address, name, phone_number, gender, sin) values (283, 'jreyes7v@typepad.com', '1975-12-23', '7774 Charing Cross Alley', 'Jessica Reyes', '420-(809)469-0030', 'F', '490509066');
insert into Employee (emp_id, email, date_of_birth, address, name, phone_number, gender, sin) values (284, 'priley7w@apple.com', '1983-10-15', '6 Swallow Plaza', 'Paul Riley', '86-(588)330-9105', 'M', '354070317');
insert into Employee (emp_id, email, date_of_birth, address, name, phone_number, gender, sin) values (285, 'cwashington7x@elpais.com', '1989-06-29', '09950 Harbort Park', 'Cheryl Washington', '7-(574)329-7622', 'F', '354930929');
insert into Employee (emp_id, email, date_of_birth, address, name, phone_number, gender, sin) values (286, 'gortiz7y@exblog.jp', '1992-02-27', '5642 Marcy Junction', 'Gerald Ortiz', '86-(365)721-4445', 'M', '356541456');
insert into Employee (emp_id, email, date_of_birth, address, name, phone_number, gender, sin) values (287, 'tparker7z@imageshack.us', '1989-04-13', '59 John Wall Place', 'Tammy Parker', '351-(624)177-8197', 'F', '491790151');
insert into Employee (emp_id, email, date_of_birth, address, name, phone_number, gender, sin) values (288, 'rrodriguez80@vk.com', '1960-12-06', '1 New Castle Circle', 'Ruth Rodriguez', '7-(129)257-0852', 'F', '675908454');
insert into Employee (emp_id, email, date_of_birth, address, name, phone_number, gender, sin) values (289, 'adaniels81@kickstarter.com', '1966-02-14', '81 Shoshone Street', 'Alan Daniels', '86-(970)238-9816', 'M', '510017266');
insert into Employee (emp_id, email, date_of_birth, address, name, phone_number, gender, sin) values (290, 'dthompson82@marriott.com', '1974-04-01', '450 Forster Alley', 'Donald Thompson', '504-(294)391-8993', 'M', '302405268');
insert into Employee (emp_id, email, date_of_birth, address, name, phone_number, gender, sin) values (291, 'jlynch83@myspace.com', '1995-05-01', '88359 Pond Circle', 'Jimmy Lynch', '351-(635)257-6889', 'M', '354392176');
insert into Employee (emp_id, email, date_of_birth, address, name, phone_number, gender, sin) values (292, 'emason84@prnewswire.com', '1984-09-19', '17676 Bluejay Alley', 'Eric Mason', '86-(431)513-6855', 'M', '500766029');
insert into Employee (emp_id, email, date_of_birth, address, name, phone_number, gender, sin) values (293, 'bgarrett85@hubpages.com', '1960-05-26', '67 Johnson Crossing', 'Brandon Garrett', '86-(551)524-8690', 'M', '675914946');
insert into Employee (emp_id, email, date_of_birth, address, name, phone_number, gender, sin) values (294, 'swilson86@studiopress.com', '1960-02-20', '85 Muir Center', 'Steve Wilson', '86-(950)644-1380', 'M', '355529655');
insert into Employee (emp_id, email, date_of_birth, address, name, phone_number, gender, sin) values (295, 'lwilliamson87@hexun.com', '1975-07-08', '5 Lukken Street', 'Linda Williamson', '62-(433)134-3906', 'F', '355406371');
insert into Employee (emp_id, email, date_of_birth, address, name, phone_number, gender, sin) values (296, 'rgordon88@google.com.br', '1961-08-28', '186 Burrows Hill', 'Rose Gordon', '62-(344)154-9569', 'F', '358865039');
insert into Employee (emp_id, email, date_of_birth, address, name, phone_number, gender, sin) values (297, 'khill89@howstuffworks.com', '1992-03-09', '4261 Namekagon Park', 'Kathleen Hill', '63-(153)514-4715', 'F', '354222386');
insert into Employee (emp_id, email, date_of_birth, address, name, phone_number, gender, sin) values (298, 'bgarrett8a@ning.com', '1993-04-27', '6 Goodland Drive', 'Brenda Garrett', '86-(416)779-8534', 'F', '303843027');
insert into Employee (emp_id, email, date_of_birth, address, name, phone_number, gender, sin) values (299, 'pjacobs8b@homestead.com', '1979-09-02', '02632 Cottonwood Junction', 'Peter Jacobs', '92-(894)790-5105', 'M', '358580138');
insert into Employee (emp_id, email, date_of_birth, address, name, phone_number, gender, sin) values (300, 'pjordan8c@netlog.com', '1958-10-31', '2817 Tony Terrace', 'Phyllis Jordan', '66-(304)813-3620', 'F', '676785978');
insert into Employee (emp_id, email, date_of_birth, address, name, phone_number, gender, sin) values (301, 'bfisher8d@cafepress.com', '1991-06-19', '6 Bashford Park', 'Bobby Fisher', '351-(504)525-6732', 'M', '355283690');
insert into Employee (emp_id, email, date_of_birth, address, name, phone_number, gender, sin) values (302, 'mhart8e@lulu.com', '1966-11-05', '34400 Troy Alley', 'Mary Hart', '47-(928)412-1913', 'F', '633323477');
insert into Employee (emp_id, email, date_of_birth, address, name, phone_number, gender, sin) values (303, 'adiaz8f@marketwatch.com', '1976-11-08', '65 Arapahoe Alley', 'Alan Diaz', '31-(946)170-7689', 'M', '670690598');
insert into Employee (emp_id, email, date_of_birth, address, name, phone_number, gender, sin) values (304, 'lgonzalez8g@gnu.org', '1978-03-29', '41 Hagan Center', 'Lori Gonzalez', '62-(590)913-2684', 'F', '676100855');
insert into Employee (emp_id, email, date_of_birth, address, name, phone_number, gender, sin) values (305, 'jfreeman8h@mysql.com', '1983-12-02', '54 Namekagon Trail', 'Joe Freeman', '46-(477)340-8554', 'M', '491763825');
insert into Employee (emp_id, email, date_of_birth, address, name, phone_number, gender, sin) values (306, 'fkelly8i@angelfire.com', '1972-12-24', '346 Manufacturers Alley', 'Fred Kelly', '66-(770)642-7608', 'M', '374622009');
insert into Employee (emp_id, email, date_of_birth, address, name, phone_number, gender, sin) values (307, 'tfranklin8j@gizmodo.com', '1994-05-13', '20 Jay Circle', 'Tammy Franklin', '98-(988)589-3346', 'F', '503887065');
insert into Employee (emp_id, email, date_of_birth, address, name, phone_number, gender, sin) values (308, 'rwright8k@facebook.com', '1980-09-08', '76402 Brentwood Pass', 'Raymond Wright', '86-(587)514-2086', 'M', '493663952');
insert into Employee (emp_id, email, date_of_birth, address, name, phone_number, gender, sin) values (309, 'fferguson8l@china.com.cn', '1975-02-10', '07904 Schmedeman Street', 'Fred Ferguson', '7-(146)404-5089', 'M', '356880044');
insert into Employee (emp_id, email, date_of_birth, address, name, phone_number, gender, sin) values (310, 'ggeorge8m@abc.net.au', '1964-03-23', '75103 South Trail', 'George George', '507-(647)536-8805', 'M', '357925674');
insert into Employee (emp_id, email, date_of_birth, address, name, phone_number, gender, sin) values (311, 'vchavez8n@dion.ne.jp', '1992-05-14', '20016 Atwood Drive', 'Virginia Chavez', '880-(527)910-1676', 'F', '365318906');
insert into Employee (emp_id, email, date_of_birth, address, name, phone_number, gender, sin) values (312, 'sjohnston8o@vinaora.com', '1960-04-03', '8872 Loftsgordon Parkway', 'Susan Johnston', '505-(804)239-3520', 'F', '676331980');
insert into Employee (emp_id, email, date_of_birth, address, name, phone_number, gender, sin) values (313, 'mparker8p@about.com', '1972-06-10', '799 Towne Center', 'Michael Parker', '46-(597)959-3501', 'M', '357842418');
insert into Employee (emp_id, email, date_of_birth, address, name, phone_number, gender, sin) values (314, 'lhoward8q@bluehost.com', '1979-01-21', '97860 Lake View Center', 'Lori Howard', '370-(807)131-8329', 'F', '510875844');
insert into Employee (emp_id, email, date_of_birth, address, name, phone_number, gender, sin) values (315, 'rmartin8r@is.gd', '1988-05-03', '5 Tony Way', 'Ruby Martin', '351-(646)284-3126', 'F', '352949654');
insert into Employee (emp_id, email, date_of_birth, address, name, phone_number, gender, sin) values (316, 'candrews8s@purevolume.com', '1964-10-04', '4359 Sauthoff Parkway', 'Craig Andrews', '55-(490)849-3198', 'M', '530629737');
insert into Employee (emp_id, email, date_of_birth, address, name, phone_number, gender, sin) values (317, 'agomez8t@eepurl.com', '1963-01-09', '6681 Banding Drive', 'Amy Gomez', '963-(839)919-9596', 'F', '401795364');
insert into Employee (emp_id, email, date_of_birth, address, name, phone_number, gender, sin) values (318, 'dwatson8u@blogs.com', '1984-04-23', '5978 Cambridge Way', 'David Watson', '33-(400)942-5921', 'M', '358047873');
insert into Employee (emp_id, email, date_of_birth, address, name, phone_number, gender, sin) values (319, 'dwelch8v@pbs.org', '1992-05-11', '6 Raven Avenue', 'Dennis Welch', '963-(798)107-7538', 'M', '356055441');
insert into Employee (emp_id, email, date_of_birth, address, name, phone_number, gender, sin) values (320, 'dcollins8w@printfriendly.com', '1979-02-04', '7 Moose Street', 'Douglas Collins', '351-(823)635-2952', 'M', '354463653');
insert into Employee (emp_id, email, date_of_birth, address, name, phone_number, gender, sin) values (321, 'estevens8x@dmoz.org', '1972-07-20', '38796 Everett Crossing', 'Earl Stevens', '506-(357)682-2128', 'M', '357235063');
insert into Employee (emp_id, email, date_of_birth, address, name, phone_number, gender, sin) values (322, 'pharris8y@pcworld.com', '1968-03-12', '4 Arizona Trail', 'Peter Harris', '507-(913)433-6385', 'M', '354373506');
insert into Employee (emp_id, email, date_of_birth, address, name, phone_number, gender, sin) values (323, 'hgordon8z@yale.edu', '1965-02-04', '72027 Meadow Vale Hill', 'Henry Gordon', '977-(810)107-6950', 'M', '510014177');
insert into Employee (emp_id, email, date_of_birth, address, name, phone_number, gender, sin) values (324, 'mfowler90@cam.ac.uk', '1984-04-10', '9 Chive Point', 'Marilyn Fowler', '63-(998)515-3594', 'F', '510014445');
insert into Employee (emp_id, email, date_of_birth, address, name, phone_number, gender, sin) values (325, 'dgonzales91@ycombinator.com', '1957-04-04', '65019 Oak Valley Park', 'Dennis Gonzales', '7-(376)836-9626', 'M', '353440041');
insert into Employee (emp_id, email, date_of_birth, address, name, phone_number, gender, sin) values (326, 'sfreeman92@house.gov', '1965-03-26', '5858 Lukken Terrace', 'Steven Freeman', '970-(157)783-5348', 'M', '352957865');
insert into Employee (emp_id, email, date_of_birth, address, name, phone_number, gender, sin) values (327, 'jwashington93@youtube.com', '1984-02-03', '1661 Melby Plaza', 'Jennifer Washington', '86-(892)972-2546', 'F', '633426758');
insert into Employee (emp_id, email, date_of_birth, address, name, phone_number, gender, sin) values (328, 'mhughes94@acquirethisname.com', '1983-10-04', '89519 3rd Center', 'Mildred Hughes', '81-(741)333-0581', 'F', '564182972');
insert into Employee (emp_id, email, date_of_birth, address, name, phone_number, gender, sin) values (329, 'mkennedy95@alexa.com', '1971-10-16', '46 Vahlen Avenue', 'Mildred Kennedy', '57-(561)469-2946', 'F', '374622123');
insert into Employee (emp_id, email, date_of_birth, address, name, phone_number, gender, sin) values (330, 'drice96@delicious.com', '1977-03-05', '834 Golf View Alley', 'Doris Rice', '380-(120)423-2591', 'F', '354118039');
insert into Employee (emp_id, email, date_of_birth, address, name, phone_number, gender, sin) values (331, 'dsanchez97@engadget.com', '1968-12-29', '1 Crownhardt Hill', 'Diana Sanchez', '62-(651)678-0358', 'F', '402604922');
insert into Employee (emp_id, email, date_of_birth, address, name, phone_number, gender, sin) values (332, 'balvarez98@histats.com', '1978-04-04', '4398 Old Gate Terrace', 'Beverly Alvarez', '55-(879)913-8754', 'F', '353952426');
insert into Employee (emp_id, email, date_of_birth, address, name, phone_number, gender, sin) values (333, 'sgardner99@tiny.cc', '1970-08-08', '50596 Hoard Hill', 'Steven Gardner', '7-(413)736-8410', 'M', '358477549');
insert into Employee (emp_id, email, date_of_birth, address, name, phone_number, gender, sin) values (334, 'rrobertson9a@accuweather.com', '1957-05-28', '7883 Meadow Vale Point', 'Ralph Robertson', '351-(469)931-6627', 'M', '300773895');
insert into Employee (emp_id, email, date_of_birth, address, name, phone_number, gender, sin) values (335, 'jrichardson9b@vkontakte.ru', '1990-07-23', '6266 Mayer Avenue', 'Judy Richardson', '56-(976)838-2498', 'F', '523050637');
insert into Employee (emp_id, email, date_of_birth, address, name, phone_number, gender, sin) values (336, 'rmurray9c@geocities.jp', '1993-11-03', '7 Sunnyside Point', 'Roy Murray', '46-(522)380-7065', 'M', '545223188');
insert into Employee (emp_id, email, date_of_birth, address, name, phone_number, gender, sin) values (337, 'jcole9d@netscape.com', '1966-01-16', '950 Anniversary Point', 'Jennifer Cole', '670-(634)874-5127', 'F', '201723004');
insert into Employee (emp_id, email, date_of_birth, address, name, phone_number, gender, sin) values (338, 'cwhite9e@bloomberg.com', '1969-07-18', '282 Hintze Terrace', 'Carol White', '81-(920)173-0857', 'F', '356699894');
insert into Employee (emp_id, email, date_of_birth, address, name, phone_number, gender, sin) values (339, 'daustin9f@about.me', '1968-04-06', '01 Pond Hill', 'David Austin', '353-(855)922-3160', 'M', '358528651');
insert into Employee (emp_id, email, date_of_birth, address, name, phone_number, gender, sin) values (340, 'mdixon9g@xinhuanet.com', '1991-10-10', '4 Bobwhite Place', 'Martha Dixon', '86-(304)168-7434', 'F', '493681032');
insert into Employee (emp_id, email, date_of_birth, address, name, phone_number, gender, sin) values (341, 'rharrison9h@stumbleupon.com', '1978-04-08', '858 Loeprich Pass', 'Ruby Harrison', '235-(963)561-8854', 'F', '302889618');
insert into Employee (emp_id, email, date_of_birth, address, name, phone_number, gender, sin) values (342, 'lcoleman9i@infoseek.co.jp', '1988-05-11', '00226 Maple Plaza', 'Lois Coleman', '57-(825)316-2550', 'F', '637833636');
insert into Employee (emp_id, email, date_of_birth, address, name, phone_number, gender, sin) values (343, 'dmendoza9j@people.com.cn', '1977-06-04', '033 Hovde Parkway', 'Daniel Mendoza', '7-(167)651-2787', 'M', '353454072');
insert into Employee (emp_id, email, date_of_birth, address, name, phone_number, gender, sin) values (344, 'sclark9k@cloudflare.com', '1986-03-04', '984 Holy Cross Crossing', 'Sean Clark', '31-(534)345-5592', 'M', '561055129');
insert into Employee (emp_id, email, date_of_birth, address, name, phone_number, gender, sin) values (345, 'ahernandez9l@a8.net', '1996-02-22', '15930 Garrison Court', 'Antonio Hernandez', '95-(225)371-8528', 'M', '356817064');
insert into Employee (emp_id, email, date_of_birth, address, name, phone_number, gender, sin) values (346, 'mfields9m@gov.uk', '1970-07-09', '0 Golf Hill', 'Marie Fields', '62-(180)427-4863', 'F', '560223359');
insert into Employee (emp_id, email, date_of_birth, address, name, phone_number, gender, sin) values (347, 'dprice9n@eventbrite.com', '1970-01-18', '35501 Fallview Park', 'Diana Price', '377-(736)196-7301', 'F', '490525171');
insert into Employee (emp_id, email, date_of_birth, address, name, phone_number, gender, sin) values (348, 'jmorales9o@bloglovin.com', '1981-09-09', '59838 Harbort Junction', 'Joe Morales', '86-(353)984-9909', 'M', '484441456');
insert into Employee (emp_id, email, date_of_birth, address, name, phone_number, gender, sin) values (349, 'creyes9p@cnbc.com', '1959-11-27', '20199 Carey Circle', 'Clarence Reyes', '66-(527)591-2816', 'M', '633110795');
insert into Employee (emp_id, email, date_of_birth, address, name, phone_number, gender, sin) values (350, 'jschmidt9q@clickbank.net', '1974-04-15', '79112 Upham Court', 'Julie Schmidt', '66-(130)461-6242', 'F', '503832815');
insert into Employee (emp_id, email, date_of_birth, address, name, phone_number, gender, sin) values (351, 'tsanders9r@tuttocitta.it', '1963-08-27', '23874 Becker Park', 'Theresa Sanders', '7-(422)551-9901', 'F', '358124008');
insert into Employee (emp_id, email, date_of_birth, address, name, phone_number, gender, sin) values (352, 'jwhite9s@barnesandnoble.com', '1986-06-14', '52923 Fremont Street', 'Julie White', '7-(562)220-3091', 'F', '561071924');
insert into Employee (emp_id, email, date_of_birth, address, name, phone_number, gender, sin) values (353, 'wolson9t@w3.org', '1993-03-17', '2 Farwell Alley', 'Walter Olson', '7-(825)323-8005', 'M', '510875538');
insert into Employee (emp_id, email, date_of_birth, address, name, phone_number, gender, sin) values (354, 'bberry9u@theatlantic.com', '1966-08-20', '31019 Heffernan Parkway', 'Bonnie Berry', '86-(975)777-4356', 'F', '353494288');
insert into Employee (emp_id, email, date_of_birth, address, name, phone_number, gender, sin) values (355, 'jrobertson9v@prweb.com', '1974-02-15', '60164 Garrison Alley', 'Janice Robertson', '86-(597)632-4232', 'F', '357807051');
insert into Employee (emp_id, email, date_of_birth, address, name, phone_number, gender, sin) values (356, 'sdiaz9w@drupal.org', '1959-01-02', '5862 Northridge Point', 'Sharon Diaz', '48-(223)982-6248', 'F', '353920688');
insert into Employee (emp_id, email, date_of_birth, address, name, phone_number, gender, sin) values (357, 'erichards9x@ucla.edu', '1987-01-09', '21 Raven Street', 'Eric Richards', '62-(594)331-7331', 'M', '356191619');
insert into Employee (emp_id, email, date_of_birth, address, name, phone_number, gender, sin) values (358, 'pdunn9y@unc.edu', '1971-01-19', '0806 Westerfield Plaza', 'Patrick Dunn', '86-(101)778-2450', 'M', '355176721');
insert into Employee (emp_id, email, date_of_birth, address, name, phone_number, gender, sin) values (359, 'jhughes9z@paginegialle.it', '1960-02-04', '5986 Sage Street', 'Jonathan Hughes', '212-(855)670-0487', 'M', '630487853');
insert into Employee (emp_id, email, date_of_birth, address, name, phone_number, gender, sin) values (360, 'jcastilloa0@yolasite.com', '1969-09-15', '4 Glacier Hill Place', 'Johnny Castillo', '1-(808)565-1789', 'M', '356364509');
insert into Employee (emp_id, email, date_of_birth, address, name, phone_number, gender, sin) values (361, 'cfreemana1@ft.com', '1973-08-17', '97 Jenna Street', 'Cynthia Freeman', '55-(462)858-2517', 'F', '676120240');
insert into Employee (emp_id, email, date_of_birth, address, name, phone_number, gender, sin) values (362, 'rhicksa2@chicagotribune.com', '1961-04-10', '5 Jay Park', 'Ruth Hicks', '86-(879)652-9334', 'F', '500235302');
insert into Employee (emp_id, email, date_of_birth, address, name, phone_number, gender, sin) values (363, 'jhudsona3@pcworld.com', '1973-02-01', '775 Bellgrove Pass', 'Jerry Hudson', '7-(944)629-3655', 'M', '355477207');
insert into Employee (emp_id, email, date_of_birth, address, name, phone_number, gender, sin) values (364, 'melliotta4@google.co.uk', '1960-07-10', '1043 Grim Point', 'Matthew Elliott', '86-(404)497-6863', 'M', '357028689');
insert into Employee (emp_id, email, date_of_birth, address, name, phone_number, gender, sin) values (365, 'jevansa5@com.com', '1989-11-02', '40 Rusk Circle', 'Jonathan Evans', '7-(371)140-4565', 'M', '303448020');
insert into Employee (emp_id, email, date_of_birth, address, name, phone_number, gender, sin) values (366, 'rknighta6@photobucket.com', '1957-11-08', '9940 Sherman Road', 'Roy Knight', '86-(633)840-7083', 'M', '060447265');
insert into Employee (emp_id, email, date_of_birth, address, name, phone_number, gender, sin) values (367, 'jbakera7@tinypic.com', '1963-03-17', '5 Monica Park', 'Jacqueline Baker', '86-(956)815-9659', 'F', '303331866');
insert into Employee (emp_id, email, date_of_birth, address, name, phone_number, gender, sin) values (368, 'cpalmera8@sun.com', '1958-09-10', '8686 Petterle Park', 'Catherine Palmer', '380-(151)639-6071', 'F', '358186735');
insert into Employee (emp_id, email, date_of_birth, address, name, phone_number, gender, sin) values (369, 'treida9@jimdo.com', '1957-04-08', '45981 Buell Center', 'Todd Reid', '53-(604)630-5558', 'M', '450811678');
insert into Employee (emp_id, email, date_of_birth, address, name, phone_number, gender, sin) values (370, 'drichardsonaa@virginia.edu', '1980-03-22', '208 Manufacturers Alley', 'Debra Richardson', '62-(563)936-7942', 'F', '638100800');
insert into Employee (emp_id, email, date_of_birth, address, name, phone_number, gender, sin) values (371, 'ggeorgeab@lycos.com', '1960-03-18', '81830 Bartillon Crossing', 'Gloria George', '963-(544)472-4606', 'F', '504837629');
insert into Employee (emp_id, email, date_of_birth, address, name, phone_number, gender, sin) values (372, 'pmoralesac@wufoo.com', '1967-03-11', '8686 Gale Plaza', 'Phyllis Morales', '62-(131)341-3306', 'F', '374622202');
insert into Employee (emp_id, email, date_of_birth, address, name, phone_number, gender, sin) values (373, 'dfergusonad@aboutads.info', '1974-10-20', '83 Westend Drive', 'Daniel Ferguson', '46-(661)916-5349', 'M', '201685146');
insert into Employee (emp_id, email, date_of_birth, address, name, phone_number, gender, sin) values (374, 'lsimsae@europa.eu', '1980-07-23', '31 Farwell Terrace', 'Lillian Sims', '353-(125)488-1335', 'F', '354348022');
insert into Employee (emp_id, email, date_of_birth, address, name, phone_number, gender, sin) values (375, 'jmurphyaf@alexa.com', '1994-09-19', '83779 Farmco Circle', 'Joshua Murphy', '86-(479)943-2355', 'M', '357865864');
insert into Employee (emp_id, email, date_of_birth, address, name, phone_number, gender, sin) values (376, 'mwelchag@mozilla.org', '1970-06-08', '672 Clarendon Drive', 'Martin Welch', '62-(856)659-0368', 'M', '510875462');
insert into Employee (emp_id, email, date_of_birth, address, name, phone_number, gender, sin) values (377, 'apetersah@delicious.com', '1996-08-11', '849 Ilene Lane', 'Adam Peters', '86-(479)533-8284', 'M', '510013982');
insert into Employee (emp_id, email, date_of_birth, address, name, phone_number, gender, sin) values (378, 'triveraai@ibm.com', '1982-10-17', '354 Old Gate Circle', 'Tina Rivera', '7-(994)629-1159', 'F', '630404919');
insert into Employee (emp_id, email, date_of_birth, address, name, phone_number, gender, sin) values (379, 'amorrisonaj@tuttocitta.it', '1971-04-09', '4 Arrowood Lane', 'Albert Morrison', '504-(746)802-4769', 'M', '358025371');
insert into Employee (emp_id, email, date_of_birth, address, name, phone_number, gender, sin) values (380, 'amurrayak@noaa.gov', '1983-12-07', '9 Everett Court', 'Ashley Murray', '7-(280)644-9309', 'F', '353707981');
insert into Employee (emp_id, email, date_of_birth, address, name, phone_number, gender, sin) values (381, 'mthompsonal@msu.edu', '1992-11-18', '2 Anderson Alley', 'Michelle Thompson', '62-(149)769-6101', 'F', '354358099');
insert into Employee (emp_id, email, date_of_birth, address, name, phone_number, gender, sin) values (382, 'cduncanam@mtv.com', '1979-05-24', '21 Annamark Circle', 'Catherine Duncan', '234-(422)518-0904', 'F', '302192728');
insert into Employee (emp_id, email, date_of_birth, address, name, phone_number, gender, sin) values (383, 'pfowleran@wikipedia.org', '1977-12-15', '5862 Basil Circle', 'Paula Fowler', '86-(715)657-7026', 'F', '201460952');
insert into Employee (emp_id, email, date_of_birth, address, name, phone_number, gender, sin) values (384, 'smontgomeryao@taobao.com', '1962-06-13', '126 Northview Road', 'Sara Montgomery', '995-(299)679-4958', 'F', '670617367');
insert into Employee (emp_id, email, date_of_birth, address, name, phone_number, gender, sin) values (385, 'lhunterap@rambler.ru', '1967-06-29', '8123 Onsgard Point', 'Laura Hunter', '52-(774)503-5570', 'F', '356435601');
insert into Employee (emp_id, email, date_of_birth, address, name, phone_number, gender, sin) values (386, 'psmithaq@free.fr', '1960-04-19', '43 Little Fleur Trail', 'Peter Smith', '1-(405)277-0715', 'M', '670900175');
insert into Employee (emp_id, email, date_of_birth, address, name, phone_number, gender, sin) values (387, 'jhansenar@weibo.com', '1975-03-22', '02766 Amoth Way', 'Joshua Hansen', '62-(701)185-6690', 'M', '355229811');
insert into Employee (emp_id, email, date_of_birth, address, name, phone_number, gender, sin) values (388, 'rcolemanas@ihg.com', '1973-04-01', '0 Dexter Junction', 'Ruby Coleman', '63-(463)574-8426', 'F', '355690491');
insert into Employee (emp_id, email, date_of_birth, address, name, phone_number, gender, sin) values (389, 'eromeroat@bloglovin.com', '1994-05-16', '28 Ryan Road', 'Elizabeth Romero', '251-(313)661-4124', 'F', '201443832');
insert into Employee (emp_id, email, date_of_birth, address, name, phone_number, gender, sin) values (390, 'fdanielsau@123-reg.co.uk', '1989-02-15', '0 Forest Pass', 'Frank Daniels', '58-(136)832-7798', 'M', '670662569');
insert into Employee (emp_id, email, date_of_birth, address, name, phone_number, gender, sin) values (391, 'lturnerav@comcast.net', '1974-10-18', '4133 Harper Place', 'Laura Turner', '351-(414)819-2395', 'F', '560223280');
insert into Employee (emp_id, email, date_of_birth, address, name, phone_number, gender, sin) values (392, 'acunninghamaw@cisco.com', '1980-07-12', '0940 Shelley Drive', 'Albert Cunningham', '63-(733)581-2856', 'M', '372301581');
insert into Employee (emp_id, email, date_of_birth, address, name, phone_number, gender, sin) values (393, 'cbrooksax@guardian.co.uk', '1985-08-26', '3 Vernon Street', 'Christina Brooks', '33-(422)695-8588', 'F', '355196055');
insert into Employee (emp_id, email, date_of_birth, address, name, phone_number, gender, sin) values (394, 'ckennedyay@woothemes.com', '1958-02-01', '5 Merchant Lane', 'Carlos Kennedy', '55-(850)666-2792', 'M', '357284319');
insert into Employee (emp_id, email, date_of_birth, address, name, phone_number, gender, sin) values (395, 'mgeorgeaz@slate.com', '1965-05-25', '9 Drewry Junction', 'Maria George', '57-(605)432-0768', 'F', '356635060');
insert into Employee (emp_id, email, date_of_birth, address, name, phone_number, gender, sin) values (396, 'dcarrb0@google.cn', '1972-07-26', '14 Johnson Lane', 'Donna Carr', '30-(139)524-7166', 'F', '374288484');
insert into Employee (emp_id, email, date_of_birth, address, name, phone_number, gender, sin) values (397, 'srodriguezb1@senate.gov', '1993-03-29', '0 Beilfuss Court', 'Sharon Rodriguez', '86-(559)400-0874', 'F', '357774910');
insert into Employee (emp_id, email, date_of_birth, address, name, phone_number, gender, sin) values (398, 'atorresb2@fda.gov', '1958-02-09', '52 Montana Lane', 'Anne Torres', '86-(392)595-2699', 'F', '355661419');
insert into Employee (emp_id, email, date_of_birth, address, name, phone_number, gender, sin) values (399, 'rspencerb3@state.gov', '1989-03-30', '9 Merchant Lane', 'Raymond Spencer', '66-(829)821-9100', 'M', '357832468');
insert into Employee (emp_id, email, date_of_birth, address, name, phone_number, gender, sin) values (400, 'krodriguezb4@chicagotribune.com', '1966-07-28', '4683 Fordem Avenue', 'Katherine Rodriguez', '381-(381)335-8332', 'F', '560225329');
insert into Employee (emp_id, email, date_of_birth, address, name, phone_number, gender, sin) values (401, 'tmorrisb5@latimes.com', '1977-01-16', '8 Tennyson Drive', 'Tina Morris', '62-(636)786-1471', 'F', '504837624');
insert into Employee (emp_id, email, date_of_birth, address, name, phone_number, gender, sin) values (402, 'lnelsonb6@netlog.com', '1990-06-11', '1 Hazelcrest Terrace', 'Laura Nelson', '351-(312)768-4834', 'F', '354201349');
insert into Employee (emp_id, email, date_of_birth, address, name, phone_number, gender, sin) values (403, 'blittleb7@storify.com', '1959-10-24', '70 Dunning Drive', 'Brenda Little', '48-(366)522-2603', 'F', '353084911');
insert into Employee (emp_id, email, date_of_birth, address, name, phone_number, gender, sin) values (404, 'wwoodb8@state.tx.us', '1978-09-06', '4 Becker Plaza', 'Willie Wood', '52-(161)200-9926', 'M', '358972322');
insert into Employee (emp_id, email, date_of_birth, address, name, phone_number, gender, sin) values (405, 'bgrayb9@wunderground.com', '1978-12-06', '60 Towne Alley', 'Barbara Gray', '251-(485)737-4855', 'F', '676233890');
insert into Employee (emp_id, email, date_of_birth, address, name, phone_number, gender, sin) values (406, 'ncarpenterba@vkontakte.ru', '1994-02-04', '1228 Morrow Drive', 'Nancy Carpenter', '86-(514)728-3787', 'F', '417500423');
insert into Employee (emp_id, email, date_of_birth, address, name, phone_number, gender, sin) values (407, 'rburnsbb@joomla.org', '1965-11-11', '883 Blaine Avenue', 'Ryan Burns', '86-(610)486-7660', 'M', '510014112');
insert into Employee (emp_id, email, date_of_birth, address, name, phone_number, gender, sin) values (408, 'gkennedybc@google.fr', '1986-12-11', '002 8th Circle', 'Gloria Kennedy', '256-(742)750-1032', 'F', '530486228');
insert into Employee (emp_id, email, date_of_birth, address, name, phone_number, gender, sin) values (409, 'mharperbd@mayoclinic.com', '1959-02-10', '509 Acker Hill', 'Mary Harper', '351-(890)184-4932', 'F', '500235285');
insert into Employee (emp_id, email, date_of_birth, address, name, phone_number, gender, sin) values (410, 'kgrantbe@vimeo.com', '1959-11-18', '83 Green Alley', 'Kathryn Grant', '86-(509)473-0627', 'F', '560224662');
insert into Employee (emp_id, email, date_of_birth, address, name, phone_number, gender, sin) values (411, 'bmitchellbf@marketwatch.com', '1972-07-13', '9065 Express Park', 'Barbara Mitchell', '66-(800)249-6584', 'F', '060416060');
insert into Employee (emp_id, email, date_of_birth, address, name, phone_number, gender, sin) values (412, 'vperkinsbg@icq.com', '1975-06-18', '42690 Orin Lane', 'Virginia Perkins', '1-(423)892-3395', 'F', '488727969');
insert into Employee (emp_id, email, date_of_birth, address, name, phone_number, gender, sin) values (413, 'rarmstrongbh@diigo.com', '1968-07-04', '33862 Mayer Plaza', 'Ruth Armstrong', '48-(719)639-2755', 'F', '303021973');
insert into Employee (emp_id, email, date_of_birth, address, name, phone_number, gender, sin) values (414, 'areidbi@github.com', '1971-02-08', '6 Kinsman Alley', 'Adam Reid', '63-(632)537-4279', 'M', '372301558');
insert into Employee (emp_id, email, date_of_birth, address, name, phone_number, gender, sin) values (415, 'bharrisbj@sfgate.com', '1973-10-08', '36709 Farmco Plaza', 'Bobby Harris', '7-(722)346-2906', 'M', '491324908');
insert into Employee (emp_id, email, date_of_birth, address, name, phone_number, gender, sin) values (416, 'ajohnsonbk@constantcontact.com', '1985-04-06', '5 Rowland Parkway', 'Ashley Johnson', '62-(543)631-3504', 'F', '560225874');
insert into Employee (emp_id, email, date_of_birth, address, name, phone_number, gender, sin) values (417, 'mbellbl@chicagotribune.com', '1992-06-17', '15495 Hoepker Avenue', 'Mildred Bell', '30-(193)948-1515', 'F', '356762866');
insert into Employee (emp_id, email, date_of_birth, address, name, phone_number, gender, sin) values (418, 'avasquezbm@youtu.be', '1972-04-29', '11311 Schurz Street', 'Alan Vasquez', '591-(240)712-9748', 'M', '357499139');
insert into Employee (emp_id, email, date_of_birth, address, name, phone_number, gender, sin) values (419, 'rwalkerbn@tripadvisor.com', '1966-08-07', '0 Westend Street', 'Ruby Walker', '505-(829)409-1124', 'F', '516113763');
insert into Employee (emp_id, email, date_of_birth, address, name, phone_number, gender, sin) values (420, 'sdanielsbo@odnoklassniki.ru', '1957-12-17', '70 Golf Course Court', 'Shirley Daniels', '86-(538)452-0292', 'F', '357509784');
insert into Employee (emp_id, email, date_of_birth, address, name, phone_number, gender, sin) values (421, 'bphillipsbp@multiply.com', '1981-09-12', '0733 Myrtle Hill', 'Billy Phillips', '64-(741)898-2867', 'M', '353627374');
insert into Employee (emp_id, email, date_of_birth, address, name, phone_number, gender, sin) values (422, 'rsanchezbq@exblog.jp', '1994-02-04', '73 Autumn Leaf Terrace', 'Russell Sanchez', '92-(138)470-3738', 'M', '510875747');
insert into Employee (emp_id, email, date_of_birth, address, name, phone_number, gender, sin) values (423, 'jmorrisbr@lycos.com', '1982-08-05', '082 Surrey Trail', 'Jean Morris', '359-(834)173-4674', 'F', '464127637');
insert into Employee (emp_id, email, date_of_birth, address, name, phone_number, gender, sin) values (424, 'bpalmerbs@google.cn', '1974-07-27', '652 Maywood Court', 'Brandon Palmer', '86-(914)139-5020', 'M', '440586738');
insert into Employee (emp_id, email, date_of_birth, address, name, phone_number, gender, sin) values (425, 'cmyersbt@bbc.co.uk', '1963-07-16', '00184 David Pass', 'Carlos Myers', '62-(524)523-6636', 'M', '355502992');
insert into Employee (emp_id, email, date_of_birth, address, name, phone_number, gender, sin) values (426, 'msandersbu@unesco.org', '1987-07-29', '51306 Lakewood Park', 'Mark Sanders', '961-(804)745-5288', 'M', '201403303');
insert into Employee (emp_id, email, date_of_birth, address, name, phone_number, gender, sin) values (427, 'sbrooksbv@imgur.com', '1973-02-25', '5 Gina Way', 'Samuel Brooks', '351-(369)329-9784', 'M', '354326226');
insert into Employee (emp_id, email, date_of_birth, address, name, phone_number, gender, sin) values (428, 'cmyersbw@rakuten.co.jp', '1979-09-19', '6853 Muir Avenue', 'Christopher Myers', '55-(144)621-2804', 'M', '354659213');
insert into Employee (emp_id, email, date_of_birth, address, name, phone_number, gender, sin) values (429, 'bwoodsbx@devhub.com', '1979-03-03', '946 Kings Lane', 'Benjamin Woods', '7-(952)231-8023', 'M', '354484690');
insert into Employee (emp_id, email, date_of_birth, address, name, phone_number, gender, sin) values (430, 'dmeyerby@apple.com', '1982-08-31', '72808 Everett Place', 'Denise Meyer', '1-(994)962-8261', 'F', '354862514');
insert into Employee (emp_id, email, date_of_birth, address, name, phone_number, gender, sin) values (431, 'krosebz@fastcompany.com', '1966-06-09', '1 Pepper Wood Street', 'Kimberly Rose', '351-(592)388-9731', 'F', '354557418');
insert into Employee (emp_id, email, date_of_birth, address, name, phone_number, gender, sin) values (432, 'dgrahamc0@prnewswire.com', '1974-01-07', '9384 Summer Ridge Hill', 'Debra Graham', '33-(560)493-0596', 'F', '358686050');
insert into Employee (emp_id, email, date_of_birth, address, name, phone_number, gender, sin) values (433, 'jturnerc1@xinhuanet.com', '1996-08-25', '17 Hermina Junction', 'Joyce Turner', '86-(372)537-5572', 'F', '560222232');
insert into Employee (emp_id, email, date_of_birth, address, name, phone_number, gender, sin) values (434, 'cporterc2@baidu.com', '1984-07-07', '014 Golf Junction', 'Carol Porter', '86-(359)559-4123', 'F', '540893271');
insert into Employee (emp_id, email, date_of_birth, address, name, phone_number, gender, sin) values (435, 'gbrooksc3@abc.net.au', '1970-01-03', '437 Everett Trail', 'Gregory Brooks', '86-(153)303-2827', 'M', '676799414');
insert into Employee (emp_id, email, date_of_birth, address, name, phone_number, gender, sin) values (436, 'jrichardsonc4@etsy.com', '1980-02-28', '794 Claremont Lane', 'Jacqueline Richardson', '93-(455)363-4307', 'F', '675901950');
insert into Employee (emp_id, email, date_of_birth, address, name, phone_number, gender, sin) values (437, 'jalexanderc5@arizona.edu', '1972-05-25', '50057 Charing Cross Court', 'Jose Alexander', '1-(925)311-3923', 'M', '355790309');
insert into Employee (emp_id, email, date_of_birth, address, name, phone_number, gender, sin) values (438, 'rrichardsc6@nature.com', '1958-02-01', '83910 Spenser Plaza', 'Ruth Richards', '267-(586)525-6556', 'F', '304759111');
insert into Employee (emp_id, email, date_of_birth, address, name, phone_number, gender, sin) values (439, 'breidc7@digg.com', '1961-09-25', '39045 Raven Way', 'Brian Reid', '56-(633)580-7779', 'M', '560221713');
insert into Employee (emp_id, email, date_of_birth, address, name, phone_number, gender, sin) values (440, 'amoralesc8@mit.edu', '1965-01-10', '192 Elmside Center', 'Andrew Morales', '1-(231)367-4577', 'M', '357392735');
insert into Employee (emp_id, email, date_of_birth, address, name, phone_number, gender, sin) values (441, 'rpricec9@comsenz.com', '1986-08-28', '9191 Kingsford Road', 'Ronald Price', '48-(503)175-9539', 'M', '355861400');
insert into Employee (emp_id, email, date_of_birth, address, name, phone_number, gender, sin) values (442, 'dpetersca@simplemachines.org', '1988-04-18', '5863 Bluejay Terrace', 'Donald Peters', '381-(283)847-7989', 'M', '490333993');
insert into Employee (emp_id, email, date_of_birth, address, name, phone_number, gender, sin) values (443, 'lrobertscb@harvard.edu', '1963-02-16', '45961 Sutherland Drive', 'Lisa Roberts', '48-(932)929-4875', 'F', '358501471');
insert into Employee (emp_id, email, date_of_birth, address, name, phone_number, gender, sin) values (444, 'tcarpentercc@hibu.com', '1975-08-27', '64567 Artisan Avenue', 'Tina Carpenter', '86-(773)983-8635', 'F', '510017121');
insert into Employee (emp_id, email, date_of_birth, address, name, phone_number, gender, sin) values (445, 'hwestcd@ft.com', '1977-05-01', '8883 Superior Avenue', 'Heather West', '967-(691)783-3380', 'F', '356326893');
insert into Employee (emp_id, email, date_of_birth, address, name, phone_number, gender, sin) values (446, 'hcollinsce@bluehost.com', '1989-06-13', '88026 Dayton Trail', 'Heather Collins', '48-(825)802-9375', 'F', '500235350');
insert into Employee (emp_id, email, date_of_birth, address, name, phone_number, gender, sin) values (447, 'smontgomerycf@icq.com', '1958-12-16', '2 Londonderry Lane', 'Sharon Montgomery', '54-(457)673-2362', 'F', '353119494');
insert into Employee (emp_id, email, date_of_birth, address, name, phone_number, gender, sin) values (448, 'afieldscg@mysql.com', '1959-07-06', '08405 Rowland Place', 'Alan Fields', '54-(371)686-4449', 'M', '302016299');
insert into Employee (emp_id, email, date_of_birth, address, name, phone_number, gender, sin) values (449, 'dortizch@e-recht24.de', '1964-10-23', '89605 Riverside Alley', 'Douglas Ortiz', '961-(774)798-2254', 'M', '356990498');
insert into Employee (emp_id, email, date_of_birth, address, name, phone_number, gender, sin) values (450, 'agordonci@nifty.com', '1974-04-08', '9778 Saint Paul Alley', 'Anthony Gordon', '420-(313)230-3862', 'M', '503862769');
insert into Employee (emp_id, email, date_of_birth, address, name, phone_number, gender, sin) values (451, 'mhenrycj@tuttocitta.it', '1989-01-28', '068 Shoshone Court', 'Mildred Henry', '1-(305)782-6344', 'F', '510017125');
insert into Employee (emp_id, email, date_of_birth, address, name, phone_number, gender, sin) values (452, 'jcampbellck@wired.com', '1978-06-01', '303 Starling Point', 'Jesse Campbell', '506-(413)117-8445', 'M', '504837103');
insert into Employee (emp_id, email, date_of_birth, address, name, phone_number, gender, sin) values (453, 'speterscl@flickr.com', '1983-08-19', '6 Little Fleur Parkway', 'Susan Peters', '86-(682)235-7208', 'F', '356403245');
insert into Employee (emp_id, email, date_of_birth, address, name, phone_number, gender, sin) values (454, 'nfranklincm@godaddy.com', '1965-02-27', '428 Hansons Lane', 'Nicole Franklin', '7-(915)367-0910', 'F', '504837372');
insert into Employee (emp_id, email, date_of_birth, address, name, phone_number, gender, sin) values (455, 'kfullercn@mapquest.com', '1970-06-28', '5 Mockingbird Parkway', 'Kelly Fuller', '86-(547)842-5407', 'F', '677180276');
insert into Employee (emp_id, email, date_of_birth, address, name, phone_number, gender, sin) values (456, 'croseco@geocities.com', '1972-02-27', '6 Jana Place', 'Christopher Rose', '86-(548)396-6850', 'M', '357462725');
insert into Employee (emp_id, email, date_of_birth, address, name, phone_number, gender, sin) values (457, 'hschmidtcp@drupal.org', '1973-08-22', '960 Helena Junction', 'Harry Schmidt', '351-(602)499-5012', 'M', '493687132');
insert into Employee (emp_id, email, date_of_birth, address, name, phone_number, gender, sin) values (458, 'abaileycq@vk.com', '1984-02-14', '4087 Hanover Circle', 'Alan Bailey', '254-(724)106-8882', 'M', '538001364');
insert into Employee (emp_id, email, date_of_birth, address, name, phone_number, gender, sin) values (459, 'jmyerscr@tripadvisor.com', '1960-09-22', '341 Hazelcrest Circle', 'Janet Myers', '62-(131)691-7368', 'F', '561078019');
insert into Employee (emp_id, email, date_of_birth, address, name, phone_number, gender, sin) values (460, 'jharveycs@cmu.edu', '1983-11-07', '05936 Truax Plaza', 'Judith Harvey', '33-(626)945-5885', 'F', '504837095');
insert into Employee (emp_id, email, date_of_birth, address, name, phone_number, gender, sin) values (461, 'wpalmerct@psu.edu', '1979-07-13', '8776 Talmadge Circle', 'Wayne Palmer', '55-(629)176-7385', 'M', '355226184');
insert into Employee (emp_id, email, date_of_birth, address, name, phone_number, gender, sin) values (462, 'tarmstrongcu@edublogs.org', '1985-05-06', '0401 Jenifer Way', 'Timothy Armstrong', '62-(305)179-1984', 'M', '353770648');
insert into Employee (emp_id, email, date_of_birth, address, name, phone_number, gender, sin) values (463, 'bcoxcv@fotki.com', '1995-09-06', '0 Sachs Point', 'Bruce Cox', '62-(974)829-1568', 'M', '491308526');
insert into Employee (emp_id, email, date_of_birth, address, name, phone_number, gender, sin) values (464, 'criveracw@nymag.com', '1964-08-25', '25 Russell Park', 'Chris Rivera', '380-(491)688-4543', 'M', '676237582');
insert into Employee (emp_id, email, date_of_birth, address, name, phone_number, gender, sin) values (465, 'planecx@imgur.com', '1975-12-29', '4953 Rigney Crossing', 'Paula Lane', '86-(318)250-6018', 'F', '356207146');
insert into Employee (emp_id, email, date_of_birth, address, name, phone_number, gender, sin) values (466, 'jknightcy@wunderground.com', '1965-02-08', '98 Hintze Terrace', 'Jason Knight', '992-(666)562-4103', 'M', '357133603');
insert into Employee (emp_id, email, date_of_birth, address, name, phone_number, gender, sin) values (467, 'twilliamscz@booking.com', '1981-11-13', '2 Londonderry Way', 'Timothy Williams', '222-(589)994-4616', 'M', '363829229');
insert into Employee (emp_id, email, date_of_birth, address, name, phone_number, gender, sin) values (468, 'jlawrenced0@businessinsider.com', '1985-02-02', '2 Mitchell Crossing', 'Justin Lawrence', '63-(844)226-9517', 'M', '589343856');
insert into Employee (emp_id, email, date_of_birth, address, name, phone_number, gender, sin) values (469, 'bnguyend1@macromedia.com', '1961-06-30', '86 Huxley Court', 'Bobby Nguyen', '46-(752)153-6993', 'M', '356912593');
insert into Employee (emp_id, email, date_of_birth, address, name, phone_number, gender, sin) values (470, 'cschmidtd2@delicious.com', '1967-12-26', '33804 Crest Line Court', 'Christina Schmidt', '7-(447)102-7141', 'F', '637788539');
insert into Employee (emp_id, email, date_of_birth, address, name, phone_number, gender, sin) values (471, 'showelld3@prweb.com', '1966-08-08', '20 Village Avenue', 'Sara Howell', '86-(498)222-1717', 'F', '353616813');
insert into Employee (emp_id, email, date_of_birth, address, name, phone_number, gender, sin) values (472, 'nkelleyd4@spotify.com', '1967-09-19', '328 Upham Terrace', 'Nancy Kelley', '7-(135)372-6463', 'F', '355840988');
insert into Employee (emp_id, email, date_of_birth, address, name, phone_number, gender, sin) values (473, 'frusselld5@answers.com', '1957-11-22', '6728 Sunfield Center', 'Frank Russell', '55-(889)670-0088', 'M', '354960422');
insert into Employee (emp_id, email, date_of_birth, address, name, phone_number, gender, sin) values (474, 'jwallaced6@ow.ly', '1969-11-25', '63 Ilene Terrace', 'Joseph Wallace', '55-(250)243-5595', 'M', '356481764');
insert into Employee (emp_id, email, date_of_birth, address, name, phone_number, gender, sin) values (475, 'ryoungd7@sitemeter.com', '1976-02-24', '11 Corry Drive', 'Ruth Young', '62-(713)316-1372', 'F', '357260416');
insert into Employee (emp_id, email, date_of_birth, address, name, phone_number, gender, sin) values (476, 'awestd8@clickbank.net', '1963-03-08', '1 Mosinee Place', 'Alan West', '86-(908)915-0496', 'M', '510014002');
insert into Employee (emp_id, email, date_of_birth, address, name, phone_number, gender, sin) values (477, 'cthomasd9@ed.gov', '1962-08-28', '31 Loeprich Circle', 'Clarence Thomas', '51-(179)846-8957', 'M', '560221716');
insert into Employee (emp_id, email, date_of_birth, address, name, phone_number, gender, sin) values (478, 'shansenda@joomla.org', '1960-01-28', '1481 Holy Cross Terrace', 'Sandra Hansen', '86-(719)488-1127', 'F', '561088228');
insert into Employee (emp_id, email, date_of_birth, address, name, phone_number, gender, sin) values (479, 'lbutlerdb@t.co', '1963-03-30', '71660 Summit Point', 'Lawrence Butler', '1-(512)343-5821', 'M', '301381548');
insert into Employee (emp_id, email, date_of_birth, address, name, phone_number, gender, sin) values (480, 'rpaynedc@cnbc.com', '1973-04-22', '34 Morrow Park', 'Ralph Payne', '7-(709)840-3429', 'M', '353393243');
insert into Employee (emp_id, email, date_of_birth, address, name, phone_number, gender, sin) values (481, 'wcoxdd@trellian.com', '1985-01-19', '94 Warbler Avenue', 'William Cox', '7-(616)250-3937', 'M', '353670512');
insert into Employee (emp_id, email, date_of_birth, address, name, phone_number, gender, sin) values (482, 'eharrisde@amazon.com', '1985-06-02', '617 Union Circle', 'Eugene Harris', '86-(405)624-1600', 'M', '670611113');
insert into Employee (emp_id, email, date_of_birth, address, name, phone_number, gender, sin) values (483, 'bgraydf@cisco.com', '1974-09-20', '2 Starling Place', 'Brian Gray', '591-(133)804-8733', 'M', '633341824');
insert into Employee (emp_id, email, date_of_birth, address, name, phone_number, gender, sin) values (484, 'ascottdg@live.com', '1973-06-26', '44714 Mendota Terrace', 'Anna Scott', '81-(103)219-4467', 'F', '500766406');
insert into Employee (emp_id, email, date_of_birth, address, name, phone_number, gender, sin) values (485, 'sruizdh@dyndns.org', '1983-03-30', '7031 Graedel Center', 'Sharon Ruiz', '56-(538)938-5328', 'F', '355517465');
insert into Employee (emp_id, email, date_of_birth, address, name, phone_number, gender, sin) values (486, 'dlynchdi@fastcompany.com', '1977-11-24', '4616 Meadow Ridge Point', 'Diane Lynch', '968-(230)660-2485', 'F', '630472993');
insert into Employee (emp_id, email, date_of_birth, address, name, phone_number, gender, sin) values (487, 'ksimpsondj@amazonaws.com', '1992-01-14', '96412 Loftsgordon Trail', 'Karen Simpson', '1-(318)737-6496', 'F', '417500395');
insert into Employee (emp_id, email, date_of_birth, address, name, phone_number, gender, sin) values (488, 'jtorresdk@foxnews.com', '1990-03-02', '2139 High Crossing Pass', 'Julie Torres', '7-(955)367-1338', 'F', '503859488');
insert into Employee (emp_id, email, date_of_birth, address, name, phone_number, gender, sin) values (489, 'sandersondl@wsj.com', '1986-02-11', '7374 2nd Park', 'Shirley Anderson', '7-(779)413-3824', 'F', '638884164');
insert into Employee (emp_id, email, date_of_birth, address, name, phone_number, gender, sin) values (490, 'plewisdm@eepurl.com', '1988-07-17', '4 Bay Hill', 'Peter Lewis', '351-(887)738-7032', 'M', '491758825');
insert into Employee (emp_id, email, date_of_birth, address, name, phone_number, gender, sin) values (491, 'jbradleydn@bloglines.com', '1994-10-06', '96 Ridgeway Lane', 'Jason Bradley', '46-(623)697-6904', 'M', '356541833');
insert into Employee (emp_id, email, date_of_birth, address, name, phone_number, gender, sin) values (492, 'jfrazierdo@shutterfly.com', '1987-05-22', '11395 4th Point', 'Julie Frazier', '351-(951)245-8120', 'F', '637747583');
insert into Employee (emp_id, email, date_of_birth, address, name, phone_number, gender, sin) values (493, 'efrazierdp@columbia.edu', '1975-08-24', '1 Grover Circle', 'Edward Frazier', '33-(794)740-4421', 'M', '357711521');
insert into Employee (emp_id, email, date_of_birth, address, name, phone_number, gender, sin) values (494, 'dsimsdq@chicagotribune.com', '1970-07-16', '4 Sage Alley', 'Debra Sims', '86-(439)791-0279', 'F', '491328684');
insert into Employee (emp_id, email, date_of_birth, address, name, phone_number, gender, sin) values (495, 'pdunndr@springer.com', '1996-05-09', '8315 Sauthoff Hill', 'Phyllis Dunn', '46-(754)388-4762', 'F', '355699225');
insert into Employee (emp_id, email, date_of_birth, address, name, phone_number, gender, sin) values (496, 'chamiltonds@163.com', '1984-12-06', '14718 Dovetail Crossing', 'Carolyn Hamilton', '62-(819)911-5639', 'F', '355750141');
insert into Employee (emp_id, email, date_of_birth, address, name, phone_number, gender, sin) values (497, 'pleedt@vkontakte.ru', '1966-01-18', '013 Commercial Place', 'Phyllis Lee', '86-(825)348-5608', 'F', '417500701');
insert into Employee (emp_id, email, date_of_birth, address, name, phone_number, gender, sin) values (498, 'jthompsondu@barnesandnoble.com', '1989-07-08', '6038 3rd Street', 'Jean Thompson', '54-(872)883-4230', 'F', '353839138');
insert into Employee (emp_id, email, date_of_birth, address, name, phone_number, gender, sin) values (499, 'fcoxdv@abc.net.au', '1960-07-29', '65 Marcy Junction', 'Fred Cox', '1-(887)745-9333', 'M', '560224258');

insert into Pharmacy_Assistant values (0);

insert into Pharmacist values (1, 'Westland Insurance', '00000000');
insert into Pharmacist values (2, 'Eastland Insurance', '00000001');

insert into Pharmacy_Technician values (3, '00000002');
insert into Pharmacy_Technician values (4, '00000003');

insert into Pharmacy_managed (store_id, emp_id, address, name, phone_number) values (1, 45, '5 Eagle Crest Park', 'Boyle, Mitchell and Lynch', '86-(616)156-6771');
insert into Pharmacy_managed (store_id, emp_id, address, name, phone_number) values (2, 134, '6803 Portage Center', 'Schmidt and Sons', '60-(904)278-2579');
insert into Pharmacy_managed (store_id, emp_id, address, name, phone_number) values (3, 126, '270 Graedel Drive', 'Muller and Sons', '62-(791)338-5236');
insert into Pharmacy_managed (store_id, emp_id, address, name, phone_number) values (4, 141, '4036 Longview Street', 'Altenwerth-Jaskolski', '48-(591)914-3482');
insert into Pharmacy_managed (store_id, emp_id, address, name, phone_number) values (5, 156, '142 Clarendon Place', 'Larkin, Tremblay and Gislason', '972-(416)202-1722');
insert into Pharmacy_managed (store_id, emp_id, address, name, phone_number) values (6, 96, '99344 Lakewood Crossing', 'Davis, Daniel and Davis', '63-(781)616-8390');
insert into Pharmacy_managed (store_id, emp_id, address, name, phone_number) values (7, 164, '64789 Jay Parkway', 'Nienow-Kessler', '57-(154)834-0106');
insert into Pharmacy_managed (store_id, emp_id, address, name, phone_number) values (8, 38, '4134 Thompson Crossing', 'Towne-Upton', '51-(138)186-9980');
insert into Pharmacy_managed (store_id, emp_id, address, name, phone_number) values (9, 23, '815 Southridge Lane', 'Reilly, Schulist and Padberg', '86-(889)805-7821');
insert into Pharmacy_managed (store_id, emp_id, address, name, phone_number) values (10, 148, '962 Dwight Avenue', 'Borer LLC', '359-(751)761-7881');

insert into Doctor values ('00000000', '7788881234', 'Dr. Miranda Bailey');
insert into Doctor values ('00000001', '6045681234', 'Dr. Meredith Grey');
insert into Doctor values ('00000002', '6045969923', 'Dr. Gregory House');
insert into Doctor values ('00000003', '7782217865', 'Dr. Derek Shepherd');
insert into Doctor values ('00000004', '4035552213', 'Dr. Christina Yang');

insert into Customer values ('00000000', 'Harry Potter', '7781129876', 'Westland Insurance');
insert into Customer values ('00000001', 'Pikachu Chu', '6045525673', 'Westland Insurance');
insert into Customer values ('00000002', 'Angelina Jolie', '6042346754', 'Blue Cross');
insert into Customer values ('00000003', 'Ken Bone', '7783324326', 'Eastland Insurance');
insert into Customer values ('00000004', 'Oprah Winfrey', '6048320986', 'Blue Cross');

insert into Patient values ('00000000', '9123456798342343', '22B Baker Street', '1954-01-29', 'F');
insert into Patient values ('00000001', '9100567832130097', '1766 Willow St.', '1975-06-04', 'F');
insert into Patient values ('00000002', '9322998812344631', '567 Evergreen Ave.', '1980-07-31', 'M');

insert into Prescription_by_is_for values ('00000000', '00000000', '00000000', '00000000', '2016-10-16');
insert into Prescription_by_is_for values ('00000001', '00000000', '00000001', '00000001', '2016-10-16');
insert into Prescription_by_is_for values ('00000002', '00000001', '00000002', '00000002', '2016-10-16');
insert into Prescription_by_is_for values ('00000003', '00000001', '00000002', '00000003', '2016-10-16');
insert into Prescription_by_is_for values ('00000004', '00000001', '00000000', '00000004', '2016-10-16');

insert into Prescription_item_has values ('00000000', '00000000', '20 mg', '3 weeks', '1 capsule QID');
insert into Prescription_item_has values ('00000001', '00000000', '80 mg', '2 weeks', '3 pills QD');
insert into Prescription_item_has values ('00000002', '00000000', '100 mg', '2 weeks', '2 capsules TID');
insert into Prescription_item_has values ('00000003', '00000001', '15 mg', '5 days', '1 pill every 3 hours');
insert into Prescription_item_has values ('00000004', '00000001', '180 mg', '5 days', '2 tablets every 8 hours');

insert into Pharmacy_record_has values ('0000000000', '9123456798342343', 'Patient is up to date with all medication');
insert into Pharmacy_record_has values ('0000000001', '9100567832130097', 'Patient switched brand of birth control');
insert into Pharmacy_record_has values ('0000000002', '9322998812344631', 'Patient is up to date with all medication');

insert into Service_provides values ('00000000', '1');
insert into Service_provides values ('00000001', '2');
insert into Service_provides values ('00000002', '1');
insert into Service_provides values ('00000003', '2');
insert into Service_provides values ('00000004', '2');

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