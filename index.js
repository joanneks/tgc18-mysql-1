const express = require('express');
const hbs = require('hbs');
const wax = require('wax-on');
require('dotenv').config()
const mysql2 = require('mysql2/promise'); //use await/async,we must use the promise version of mysql2
const app = express();

app.set('view engine','hbs');
wax.on(hbs.handlebars);
wax.setLayoutPath('./views/layouts')

async function main(){
    const connection = await mysql2.createConnection({
        'host':process.env.DB_HOST, // host --> ip address of the database server
        'user': process.env.DB_USER,
        'database':process.env.DB_DATABASE,
        'password':process.env.DB_PASSWORD,
        })
    app.get('/staff',async function(req,res){
        const[staff] = await connection.execute("SELECT staff_id,first_name,last_name,email from staff");
        // res.send(staff);
        res.render('staff.hbs',{
            'staff':staff
        })
    })
    
    app.get('/actors',async function(req,res){
        // connection.execute returns an array of results
        // the first element is the table that we selected
        // the second element onwards are housekeeping data
        // the first element will be stored in actors varibale
        const [actors] = await connection.execute("SELECT * FROM actor");

        // short form for:
        // const results = await connection.execute("SELECT * FROM actor");
        // const actors = results = [0]
        // array destructuring let [a,b,c] = ['apples','bananas','oranges','pears']
        // the following will get same result too:
            // function getFruits(){
                // return ['apples','bananas','oranges','pears']
            // }
            // let [a,b,c] = getFruits();
        
        // res.send(actors)
        res.render('actor.hbs',{
            'actors':actors
        })
    })
    app.get('/search',async function(req,res) {
        // define the 'get all results query'
        // 1 means true
        let query = "Select * from actor WHERE 1";
        let bindings = []

        // if req.query is not falsy
        // undefined,null,"",0 --> falsy value
        if (req.query.first_name){
            query += ` AND first_name LIKE ?`;
            // ? tells SQL to treat it as a string after the ? is replaced
            bindings.push('%' + req.query.first_name + '%')
        }
        if(req.query.last_name){
            query += ` AND last_name LIKE ?`;
            bindings.push('%' + req.query.last_name + '%')
        }
        console.log(query,bindings)
        // 3 types of cyber security attacks : sql injections, xss (cross site scripting), csrf(cross server request forgery)

        let [actors] = await connection.execute(query,bindings);
        res.render('search',{
            'actors':actors
        })
    })
};

main();

//to enable using forms
app.use(express.urlencoded({
    'extended':false
}))

app.listen (3000,function(){
    console.log("server has started")
})