create database swimming_coach;

use swimming_coach;

create table parents (
    parent_id int unsigned auto_increment primary key,
    name varchar(100) not null,
    contact_no varchar(10) not null,
    occupation varchar(100)
) engine = innodb;

insert into parents (name, contact_no, occupation)
    values ("Tan Ah Liang", "9999999", "Truck driver");;

-- insert multiple parents
insert into parents(name,contact_no,occupation) values
    ("Mary Sue","1111111","Doctor"),
    ("Tan Ah Kow","2222222","Programmer");

create table locations (
    location_id mediumint unsigned auto_increment primary key,
    name varchar(100) not null,
    address varchar(255) not null
) engine = innodb;

insert into locations (name, address) values
    ("Yishun Swimming Complex","Yishun Ave 4");

-- #method 1 of creating a table with a foreign key
    -- # - create the table with the foreign key column but not setting it as a foreign key
    create table addresses (
        address_id int unsigned auto_increment primary key,
        parent_id int unsigned not null,
        block_no varchar(6) not null,
        street_name varchar(255) not null,
        unit_no varchar(100) not null,
        postal_code varchar(10) not null
    ) engine = innodb;

    -- # -  add in the foreign key relationship to the parent_id
    -- # alter table <table name> add constraint <name of constraint>
    -- #    foreign key (column of the altered table) references <other table>
    alter table addresses add constraint fk_addresses_parents
        foreign key(parent_id) references parents(parent_id);
        -- # addres.parent_id will refer to parents.parent_id (tablename.tablecolumnname)

-- #method 2 of creating a table with a foreign key
    -- # - create the table with the foreign key column
    create table students (
        student_id int unsigned auto_increment primary key,
        name varchar(100) not null,
        date_of_birth date not null,
        parent_id int unsigned not null,
        foreign key (parent_id) references parents(parent_id)
    ) engine = innodb;

insert into students(name,date_of_birth,parent_id) values ("Cindy Tan","2020-06-11",4);
update students set parent_id=4 where student_id =1;

-- # sql will block it because existing data will cease to be invalid if this is deleted/updated
    -- delete from parents where parent_id=4;
    -- update students set parent_id=9 where student_id =1;


create table sessions (
    session_id int unsigned auto_increment primary key,
    `datetime` datetime not null,
    location_id mediumint unsigned not null,
    foreign key (location_id) references locations(location_id)
 ) engine = innodb;


-- integer types determine size of database, tinyint,mediumint

    -- to delete, in terminal: delete from parents where parent_id=2;
    -- to show table, in terminal: select * from parents
    -- to show table fields, in terminal: describe locations;
    -- in terminal: show table
    -- in terminal: exit
