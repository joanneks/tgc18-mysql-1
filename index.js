const express = require('express');
const hbs = require('hbs');
const wax = require('wax-on');
const mysql2 = require('mysql2/promise'); //use await/async,we must use the promise version of mysql2

const app = express();

app.set('view engine','hbs');
wax.on(hbs.handlebars);
wax.setLayoutPath('./views/layouts')

async function main(){
    const connection = await mysql2.createConnection({
        'host':'localhost', // host --> ip address of the database server
        'user': 'joanneks',
        'database':'sakila',
        'password':'Tech2022',
        })
        await connection.execute("SELECT * FROM actor");
};

main();

//to enable using forms
app.use(express.urlencoded({
    'extended':false
}))

app.listen (3000,function(){
    console.log("server has started")
})