To start mysql, in the terminal, type in `mysql -u root`

To create a user that can be accessed via nodejs etc, run this:
```
mysql -e "ALTER USER 'user'@'localhost' IDENTIFIED WITH mysql_native_password BY 'root_password';"
```

# To import sakila database
```
mysql -u root < sakila-schema.sql
mysql -u root < sakila-data.sql
```
# test if database has data
use sakila database;
show tables;
select * from actor;

# dependencies
```
yarn add express 
yarn add hbs
yarn add wax-on
yarn add handlebars-helpers
yarn add mysql2
```

# CREATE BASH SCRIPT/SHELL SCRIPT --> init.sh
run npm init
create init.sh file
in init.sh file --> put in the dependencies
in terminal: chmod +x init.sh
in terminal: ./init.sh

# CREATE USER IN MYSQL
the root is the superadmin user, so it's dangerous to use it.
```
in terminal: CREATE USER 'joanneks'@'localhost' IDENTIFIED BY 'Tech2022';
```

# GRANT a USER PERMISSION
```
GRANT ALL PRIVILEGES on sakila.* TO 'joanneks'@'localhost' WITH GRANT OPTION;
FLUSH PRIVILEGES;
```