const express = require('express');
const hbs = require('hbs');
const wax = require('wax-on');
require('handlebars-helpers')({
    'handlebars': hbs.handlebars
})
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
        //prepared statement prevents against sql injections
        //connection executes returns an array of results
        let [actors] = await connection.execute(query,bindings);
        res.render('search',{
            'actors':actors
        })
    })


    app.get('/actors/create', async function(req,res){
        res.render('create_actor');
    })

    app.post('/actors/create', async function(req,res){
        const query = "insert into actor (first_name, last_name) values (?, ?)";
        const bindings = [req.body.first_name, req.body.last_name];
        await connection.execute(query, bindings);
        res.redirect('/actors');
    })

    app.get('/actors/:actor_id/update', async function (req, res) {
        const actorId = parseInt(req.params.actor_id);
        const query = "select * from actor where actor_id = ?";
        const [actors] = await connection.execute(query, [actorId]);
        const actorToUpdate = actors[0]; // since we are only expecting one result,we just take the first index
        res.render('update_actor',{
            'actor': actorToUpdate
        })
    })
    app.post('/actors/:actor_id/update', async function(req,res){

        if (req.body.first_name.length > 45 || req.body.last_name > 45) {
            res.status(400);
            res.send("Invalid request");
            return;
        }

        // sample query
        // update actor set first_name="Zoe2", last_name="Tay2" WHERE actor_id = 202;
        const query = `update actor set first_name=?, last_name=? WHERE actor_id = ?`
        const bindings = [req.body.first_name, req.body.last_name, parseInt(req.params.actor_id)];
        await connection.execute(query, bindings);
        res.redirect('/actors');
    })

    app.post ('/actors/:actor_id/delete', async function(req,res){
        const query = "DELETE FROM actor WHERE actor_id = ?";
        const bindings = [parseInt(req.params.actor_id)];
        await connection.execute(query,bindings);
        res.redirect('/actors');
    })
    // app.get('/category',async function(req,res){
    //     const [category] = await connection.execute("SELECT * from category ORDER BY name ASC");
    //     res.render('category',{
    //         category
    //     })
    // })

    app.get('/category',async function(req,res){

            let query = "SELECT * from category where 1";
            bindings = []
            if (req.query.name){
                query += ` AND name LIKE ?`
                bindings.push("%"+req.query.name+"%")
            }
            if(req.query.nameOrder==="Name Ascending"){
                query += `ORDER BY name ?`
                bindings.push("ASC")
            }
            if(req.query.nameOrder==="Name Descending"){
                query += `ORDER BY name ?`
                bindings.push("DESC")
            }
            const [category] = await connection.execute(query,bindings);
            console.log(query,bindings)
            res.render('category',{
                category
            })
    })
    
    // app.post('/category',async function(req,res){
    //     const query = "SELECT * from category name LIKE ? ORDER BY name ASC";
    //     bindings = [req.body.name]
    //     const [category] = await connection.execute(query,bindings);
        
    //     res.render('category',{
    //         category
    //     })
    // })

    app.get('/category/create',async function(req,res){
        res.render('category_create');
    })
    app.post('/category/create',async function(req,res){
        let categoryName =req.body.name;
            if (categoryName.length<=25){
                const query = `insert into category (name) values (?)`;
                const bindings = [req.body.name];
                await connection.execute(query,bindings);
                res.redirect('/category');
            } else{
                res.status(400);
                res.send("Invalid Request")
            }
    })
    app.get('/category/:category_id/update',async function(req,res){
        categoryId = req.params.category_id;
        const query = `SELECT * from category WHERE category_id = ?`;
        [category] = await connection.execute(query,[categoryId]);
        categoryToUpdate = category[0]
        res.render('category_update',{
            'category':categoryToUpdate
        })
    })
    app.post('/category/:category_id/update',async function(req,res){
        categoryId = req.params.category_id;
        const query = `UPDATE category set name=? WHERE category_id = ?`;
        bindings = [req.body.name,categoryId]
        await connection.execute(query,bindings);
        res.redirect('/category');
    })
    app.get('/category/:category_id/delete',async function(req,res){
        categoryId = req.params.category_id;
        const query = `SELECT * from category WHERE category_id = ?`;
        [category] = await connection.execute(query,[categoryId]);
        categoryToUpdate = category[0]
        res.render('category_delete',{
            'category':categoryToUpdate
        })
    })
    app.post('/category/:category_id/delete',async function(req,res){
        // find all films which cateegory_id equal to the one that we try to delete
        const deleteQuery = "DELETE FROM film_category where category_id= ?";
        await connection.execute(deleteQuery, [parseInt(req.params.category_id)])

        categoryId = req.params.category_id;
        const query = `DELETE FROM category WHERE category_id=?`
        const bindings = [categoryId]
        await connection.execute(query,bindings);
        res.redirect('/category');
    })


    
    app.get('/categories/:category_id/delete', async function (req, res) {
        const query = "SELECT * from category where category_id = ?"
        const [categories] = await connection.execute(query, [parseInt(req.params.category_id)]);
        const categoryToDelete = categories[0];
        res.render('confirm_delete_category', {
            'category': categoryToDelete
        })
    })

    app.post('/categories/:category_id/delete', async function (req, res) {

        // find all the films which have category_id equal to the one that we are trying to delete
        const deleteQuery = "DELETE FROM film_category where category_id = ?";
        await connection.execute(deleteQuery, [parseInt(req.params.category_id)]);

        const query = "DELETE FROM category where category_id = ?";
        const bindings = [parseInt(req.params.category_id)];
        await connection.execute(query, bindings);
        res.redirect('/categories');
    })

    
    app.get('/films/create', async function (req, res) {
        const [languages] = await connection.execute(
            "SELECT * FROM language"
        );

        const [actors] = await connection.execute(
            "SELECT * FROM actor"
        );

        res.render('create_film', {
            languages: languages,
            actors: actors
        })
    })


    app.get('/films', async function (req, res) {
        const [films] = await connection.execute(`SELECT film_id, title, description, language.name AS 'language' FROM film 
                                                  JOIN language 
                                                  ON film.language_id = language.language_id`);

        // console.log(films);
        res.render('films', {
            films: films
        })
    })

    app.post('/films/create', async function (req, res) {
        // console.log(req.body.actors);
        let actors = req.body.actors ? req.body.actors : [];
        actors = Array.isArray(actors) ? actors : [actors];

        // nested ternary expression
        // let actors =req.body.actors?
        // (Array.isArray(req.body.actors)?req.body.actors : [req.body.actors]):[];
        /*
        insert into film (title, description, language_id)
               values ("The Lord of the Ring", "blah blah blah", 1);
        */
    //    1. we have to create the row first
    const [results] = await connection.execute(
        `insert into film (title,description, language_id) values (?,?,?)`,
        [req.body.title,req.body.description,req.body.language_id]
    );
    const newFilmId = results.insertId

    // 2. then add in relationship in the pivot table
    // sample query
    // insert into film_actor (actor_id,film_id) values (2,1002))
    // for (let actorId of actors){
    //     const bindings = [actorId,newFilmId];
    //     await connection.execute(`insert into film_actor (actor_id, film_id) values (?,?)`,bindings)
    // }
        let query = "INSERT INTO film_actor (actor_id,film_id) values "
        const bindings = []
        for (let actorId of actors){
            query += "(?,?),"
            bindings.push(actorId,newFilmId)
        }
        query = query.slice(0,-1) //omit the last comma
        await connection.execute(query,bindings)
        // await connection.execute(
        //     `insert into film (title, description, language_id) values (?, ?, ?)`,
        //     [req.body.title, req.body.description, parseInt(req.body.language_id), ]
        // );
        res.redirect('/films');
    })

    app.get('/films/:film_id/update', async function (req, res) {
        const [languages] = await connection.execute("SELECT * from language");
        const [films] = await connection.execute("SELECT * from film where film_id = ?",
            [parseInt(req.params.film_id)]);
        const [actors] = await connection.execute("SELECT * from actor");
        const [currentActors] = await connection.execute("SELECT actor_id from film_actor where film_id = ?",[req.params.film_id])
        const currentActorIds = currentActors.map(a => a.actor_id);
        // console.log(currentActorIds);
        
        const filmToUpdate = films[0];
        res.render('update_film',{
            'film':filmToUpdate,
            'languages':languages,
            'actors': actors,
            'currentActors': currentActorIds
        })

    })

    
    app.post('/films/:film_id/update', async function(req,res){
        /* sample query:
         update film set title="ASD ASD",
                 description="ASD2 ASD2",
                 language_id=3
                WHERE film_id=1;
        */
       await connection.execute(
        `UPDATE film SET title=?,
                         description=?,
                         language_id=?
                         WHERE film_id=?`,
        [req.body.title, req.body.description, parseInt(req.body.language_id), req.params.film_id]
       );

    //    update actors
    await connection.execute("DELETE from film_actor where film_id =?",[req.params.film_id]);

    // second re-add all the selected actors back to the film
    let actors = req.body.actors? req.body.actors : [];
    actors =Array.isArray(actors)? actors: [actors];
    for (let actorId of actors){
        await connection.execute("INSERT INTO film_actor (film_id,actor_id) values (?,?)",[
            parseInt(req.params.film_id),
            actorId
        ])
    }

       res.redirect('/films');
    })

app.get('/customers',async function (req,res){
    let [store] = await connection.execute ("SELECT store.store_id, address.address from store JOIN address on store.address_id = address.address_id")
    let [customers] = await connection.execute("SELECT * from customer")
    res.render('customers',{
        customers
    })
})
app.get('/customers/create',async function(req,res){
    let [store] = await connection.execute ("SELECT * from store JOIN address on store.address_id = address.address_id")
    let [address] = await connection.execute ("SELECT * from address")
    let [city] = await connection.execute("SELECT * from city")
    res.render('customers_create',{
        store,
        address,
        city
    })
})
app.post('/customers/create', async function(req,res){
    // await connection.execute("START TRANSACTION")
    // try{
        let [newAddress] = await connection.execute(`INSERT INTO address (address,district,city_id,phone,location) values (?,?,?,?,POINT(0.0000,90.0000))`,
                                                    [req.body.address,req.body.district,req.body.city_id,req.body.phone])
        newAddressId = newAddress.insertId
        let query ="INSERT INTO customer (first_name,last_name,email,address_id,store_id) values (?,?,?,?,?)"
        let bindings = [req.body.first_name,
            req.body.last_name,req.body.email,newAddressId,req.body.store_id]
        let newCustomer = await 
            connection.execute(query,bindings)
        res.redirect('/customers');

    // }catch(e){
    //     await connection.execute("ROLLBACK");
    //     console.log(e);
    // }
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