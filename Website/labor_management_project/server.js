const express = require('express')
const moment = require('moment')
const app = express()
const pool = require('./pggres_db')
const bodyParser = require('body-parser');

app.set('view engine', 'ejs')
app.use(express.static(__dirname + '/public'));
app.use(express.json());
app.use(bodyParser.urlencoded({ extended: true })); //not using this will give empty req.body

app.get("/bank_info", async (req, res) => {
    try {
        const allstd = await pool.query('SELECT * FROM laborlist_and_wages_db.bank_info');

        const page = parseInt(req.query.page);//get value from url
        const limit = parseInt(req.query.limit);

        const startInd = (page - 1) * limit;
        const endInd = (page) * limit;

        const results = {};

        if (endInd < allstd.rows.length) {
            results.next = {
                page: page + 1,
                limit: limit
            }
        }
        if (startInd > 0) {
            results.prev = {
                page: page - 1,
                limit: limit
            }
        }
        results.results = allstd.rows.slice(startInd, endInd);

        res.paginatedResults = results;

        res.status(200).render('admin/bank_info.ejs', { data: res.paginatedResults });
        //print
    }
    catch (err) {
        console.error(err.message);
    }
});

app.get("/location_info", async (req, res) => {
    try {
        const allstd = await pool.query('SELECT * FROM laborlist_and_wages_db.location_info');

        const page = parseInt(req.query.page);//get value from url
        const limit = parseInt(req.query.limit);

        const startInd = (page - 1) * limit;
        const endInd = (page) * limit;

        const results = {};

        if (endInd < allstd.rows.length) {
            results.next = {
                page: page + 1,
                limit: limit
            }
        }
        if (startInd > 0) {
            results.prev = {
                page: page - 1,
                limit: limit
            }
        }
        results.results = allstd.rows.slice(startInd, endInd);

        res.paginatedResults = results;

        res.status(200).render('admin/location_info.ejs', { data: res.paginatedResults });
        //print
    }
    catch (err) {
        console.error(err.message);
    }
});


app.get("/personal_info", async (req, res) => {
    try {
        const allstd = await pool.query('SELECT * FROM laborlist_and_wages_db.personal_info');

        const page = parseInt(req.query.page);//get value from url
        const limit = parseInt(req.query.limit);

        const startInd = (page - 1) * limit;
        const endInd = (page) * limit;

        const results = {};

        if (endInd < allstd.rows.length) {
            results.next = {
                page: page + 1,
                limit: limit
            }
        }
        if (startInd > 0) {
            results.prev = {
                page: page - 1,
                limit: limit
            }
        }
        results.results = allstd.rows.slice(startInd, endInd);

        res.paginatedResults = results;

        res.status(200).render('admin/personal_info.ejs', { data: res.paginatedResults });
        //print
    }
    catch (err) {
        console.error(err.message);
    }
});

app.get("/all_employees", async (req, res) => {
    try {
        const allstd = await pool.query('SELECT * FROM pms2.employee_info');

        const page = parseInt(req.query.page);//get value from url
        const limit = parseInt(req.query.limit);

        const startInd = (page - 1) * limit;
        const endInd = (page) * limit;

        const results = {};

        if (endInd < allstd.rows.length) {
            results.next = {
                page: page + 1,
                limit: limit
            }
        }
        if (startInd > 0) {
            results.prev = {
                page: page - 1,
                limit: limit
            }
        }
        results.results = allstd.rows.slice(startInd, endInd);

        res.paginatedResults = results;

        res.status(200).render('admin/all_employees.ejs', { data: res.paginatedResults });
        //print
    }
    catch (err) {
        console.error(err.message);
    }
});

//admin login page
app.get('/a_login', (req, res) => {
    res.status(200).render('admin/a_login.ejs')
});

//admn login page post method
app.post('/a_login', (req, res) => {
    if (req.body.a_passwd == "admin") {
        res.status(304).redirect('/a_choice');
    } else {
        res.status(404).send("Wrong Pass");
    }
});

//admin choices to show
app.get('/a_choice', (req, res) => {
    res.status(200).render('admin/choice.ejs');
});


//home page redirect
app.get('/', (req, res) => {
    res.status(301).redirect('/home')
});

//home page main link
app.get('/home', (req, res) => {
    res.status(200).render('home/home.ejs')
});

app.get('/login', (req, res) => {
    res.status(301).redirect('/home')
});


app.get('/user_signin', (req, res) => {
    res.status(200).render('user/user_signin_basic.ejs')
});

app.post('/user_signin', async(req,res) => {
    try {
        // console.log(req.body);
    
        var len1 = await pool.query(`SELECT max(user_id) FROM laborlist_and_wages_db.users_info`)

        len1 = parseInt(len1.rows[0].max);
        var len2 = await pool.query(`SELECT max(location_id) FROM laborlist_and_wages_db.location_info`)
        len2 = parseInt(len2.rows[0].max);
        let x = Math.floor((Math.random() * 9999999)+1);
        let y = Math.floor((Math.random() * 999999999)+1);
        await pool.query(`INSERT INTO laborlist_and_wages_db.location_info VALUES($1,$2,$3);`,[len2+1, req.body.city, req.body.district]);
        
        await pool.query(`INSERT INTO laborlist_and_wages_db.personal_info VALUES($1,NULL,NULL,NULL,$2,$3,$4,$5);`,[len1+241, req.body.mo_number, req.body.type_of_user, req.body.name, req.body.email]);

        await pool.query(`INSERT INTO laborlist_and_wages_db.bank_info VALUES($1,$2,$3,$4,$5,$6)`,[x.toString(),y.toString(),req.body.name, req.body.email, len1+241, req.body.type_of_user]);
    
        await pool.query(`INSERT INTO laborlist_and_wages_db.users_info VALUES($1,$2,$3,$4)`,[len1+241,x.toString(),len2+1, req.body.passwd]);

        res.status(304).redirect('/home');
    } catch (err) {
        console.error(err.message);
    }
});

app.get('/user_login', (req, res) => {
    res.status(200).render('user/user_login.ejs')
});

app.post('/user_login', async (req, res) => {
    try {
        const allstd = await pool.query(`SELECT * FROM laborlist_and_wages_db.users_info WHERE user_id = ${req.body.user_login_id}`);
        console.log(allstd.rows[0]);
        const location_id = allstd.rows[0].location_id;
        // const acc = await pool.query(`SELECT * FROM laborlist_and_wages_db.bank_info WHERE account_number = ${allstd.rows[0].account_number}`);
        const pinfo = await pool.query(`SELECT * FROM laborlist_and_wages_db.personal_info WHERE user_id = ${req.body.user_login_id}`);
        const loc = await pool.query(`SELECT * FROM laborlist_and_wages_db.location_info WHERE location_id = ${location_id}`);
        if (allstd.rows.length > 0) {
            if (req.body.user_login_passwd == allstd.rows[0].password) {
                res.status(200).render('user/user_info.ejs', {data: allstd.rows[0], pdata: pinfo.rows[0], location: loc.rows[0]});
            } else {
                res.status(404).send("Wrong Password");
            }
        } else {
            res.status(404).send("User ID not found");
        }
    } catch (err) {
        console.error(err.message);
    }
});

app.get('/user_edit',async (req, res) => {
    try {
        const allstd = await pool.query(`SELECT * FROM laborlist_and_wages_db.users_info WHERE user_id = ${req.query.id}`);
        console.log(allstd.rows[0]);
        const location_id = allstd.rows[0].location_id;
        // const acc = await pool.query(`SELECT * FROM laborlist_and_wages_db.bank_info WHERE account_number = ${allstd.rows[0].account_number}`);
        const pinfo = await pool.query(`SELECT * FROM laborlist_and_wages_db.personal_info WHERE user_id = ${req.query.id}`);
        const loc = await pool.query(`SELECT * FROM laborlist_and_wages_db.location_info WHERE location_id = ${location_id}`);
        if (allstd.rows.length > 0) {
            res.status(200).render('user/user_edit.ejs', {data: allstd.rows[0], pdata: pinfo.rows[0], location: loc.rows[0]});
        }else {
            res.status(404).send("User ID not found");
        }
    } catch (err) {
        console.error(err.message);
    }
});

app.post('/user_edit', async(req,res) => {
    try {
        console.log(req.body);
        // const qury = `UPDATE laborlist_and_wages_db.users_info
        // SET account_number = $1, 
        // location_id = $2, 
        // WHERE user_id=$3`;

        const qury_location = `UPDATE laborlist_and_wages_db.location_info 
        SET city = $1, 
        district = $2
        WHERE location_id = $3`;

        const qury_personal = `UPDATE laborlist_and_wages_db.personal_info
        SET name = $1,
        email = $2,
        mobile_number = $3
        WHERE user_id = $4`;

        await pool.query(qury_location, [req.body.city, req.body.district, req.body.location_id]);
        
        await pool.query(qury_personal, [req.body.name, req.body.email, req.body.mo_number, req.body.id]);
        
        res.status(200).redirect('/home');
    } catch (err) {
        console.error(err.message);
    }
});

app.get('/user_info',async (req, res) => {
    try {
        const allstd = await pool.query(`SELECT * FROM laborlist_and_wages_db.users_info WHERE user_id = ${req.query.id}`);
        console.log(allstd.rows[0]);
        const location_id = allstd.rows[0].location_id;
        // const acc = await pool.query(`SELECT * FROM laborlist_and_wages_db.bank_info WHERE account_number = ${allstd.rows[0].account_number}`);
        const pinfo = await pool.query(`SELECT * FROM laborlist_and_wages_db.personal_info WHERE user_id = ${req.query.id}`);
        const loc = await pool.query(`SELECT * FROM laborlist_and_wages_db.location_info WHERE location_id = ${location_id}`);
        if (allstd.rows.length > 0) {
            res.status(200).render('user/user_info.ejs', {data: allstd.rows[0], pdata: pinfo.rows[0], location: loc.rows[0]});
        }else {
            res.status(404).send("User ID not found");
        }
    } catch (err) {
        console.error(err.message);
    }
});


app.post('/delete_user', async (req, res)=>{
    try {
        let acc = String(req.body.acc_num);
        console.log(1);
        
        await pool.query(`DELETE FROM laborlist_and_wages_db.personal_info WHERE user_id=${req.body.id}`);
        console.log(2);
        const qury = `DELETE FROM laborlist_and_wages_db.users_info WHERE user_id = $1`;
        await pool.query(qury, [req.body.id]);
        await pool.query(`DELETE FROM laborlist_and_wages_db.bank_info WHERE account_number='${acc}'`);
        console.log(3);
        await pool.query(`DELETE FROM laborlist_and_wages_db.location_info WHERE location_id=${req.body.location_id}`);
        
        console.log(4);
        
        console.log(5);
        res.status(304).redirect('/home');
    } catch (err) {
        console.error(err.message);
    }
});


app.get('/labor_signin', (req, res) => {
    res.status(200).render('labor/labor_signin_basic.ejs')
});

app.post('/labor_signin', async(req,res) => {
    try {
        console.log(req.body);
        
        var len1 = await pool.query(`SELECT max(labor_id) FROM laborlist_and_wages_db.labor`)
        console.log(1);
        len1 = parseInt(len1.rows[0].max);
        console.log(len1);
        var len2 = await pool.query(`SELECT max(location_id) FROM laborlist_and_wages_db.location_info`)
        len2 = parseInt(len2.rows[0].max);
        let x = Math.floor((Math.random() * 9999999)+1);
        let y = Math.floor((Math.random() * 999999999)+1);
        let z = Math.floor((Math.random() * 60)+121);

        await pool.query(`INSERT INTO laborlist_and_wages_db.location_info VALUES($1,$2,$3);`,[len2+1, req.body.city, req.body.district]);

        await pool.query(`INSERT INTO laborlist_and_wages_db.bank_info VALUES($1,$2,$3,$4,$5,$6);`,[x.toString(),y.toString(),req.body.name, req.body.email, len1+241, req.body.type_of_user]);
        console.log(2);
        
        await pool.query(`INSERT INTO laborlist_and_wages_db.labor VALUES($1,$2,NULL,NULL,NULL,$3,$4,NULL,$5,$6,$7);`,[len1+241,req.body.birth_date,req.body.type_of_work,z,len2+1,x.toString(),req.body.passwd]);
        console.log(3);
        await pool.query(`INSERT INTO laborlist_and_wages_db.personal_info VALUES(NULL,$1,NULL,NULL,$2,$3,$4,$5);`,[len1+241, req.body.mo_number, req.body.type_of_user, req.body.name, req.body.email]);

    
        res.status(304).redirect('/home');
    } catch (err) {
        console.error(err.message);
    }
});

app.get('/labor_login', (req, res) => {
    res.status(200).render('labor/labor_login.ejs')
});

app.post('/labor_login', async (req, res) => {
    try {
        console.log(req.body);
        
        const allstd = await pool.query(`SELECT * FROM laborlist_and_wages_db.labor WHERE labor_id = ${req.body.labor_id}`);
        console.log(allstd.rows[0]);
        const location_id = allstd.rows[0].location_id;

        // const acc = await pool.query(`SELECT * FROM laborlist_and_wages_db.bank_info WHERE account_number = ${allstd.rows[0].account_number}`);
        const pinfo = await pool.query(`SELECT * FROM laborlist_and_wages_db.personal_info WHERE labor_id = ${req.body.labor_id}`);

        const loc = await pool.query(`SELECT * FROM laborlist_and_wages_db.location_info WHERE location_id = ${location_id}`);

        allstd.rows[0].birth_date = (allstd.rows[0].birth_date).toISOString().slice(0,10);
        if (allstd.rows.length > 0) {
            if (req.body.labor_password == allstd.rows[0].password) {
                res.status(200).render('labor/labor_info.ejs', {data: allstd.rows[0], pdata: pinfo.rows[0], location: loc.rows[0]});
            } else {
                res.status(404).send("Wrong Password");
            }
        } else {
            res.status(404).send("Labor ID not found");
        }
    } catch (err) {
        console.error(err.message);
    }
});

app.get('/labor_edit',async (req, res) => {
    try {
        const allstd = await pool.query(`SELECT * FROM laborlist_and_wages_db.labor WHERE labor_id = ${req.query.id}`);
        console.log(allstd.rows[0]);
        const location_id = allstd.rows[0].location_id;
        // const acc = await pool.query(`SELECT * FROM laborlist_and_wages_db.bank_info WHERE account_number = ${allstd.rows[0].account_number}`);
        const pinfo = await pool.query(`SELECT * FROM laborlist_and_wages_db.personal_info WHERE labor_id = ${req.query.id}`);
        const loc = await pool.query(`SELECT * FROM laborlist_and_wages_db.location_info WHERE location_id = ${location_id}`);
        allstd.rows[0].birth_date = (allstd.rows[0].birth_date).toISOString().slice(0,10);
        if (allstd.rows.length > 0) {
            res.status(200).render('labor/labor_edit.ejs', {data: allstd.rows[0], pdata: pinfo.rows[0], location: loc.rows[0]});
        }else {
            res.status(404).send("User ID not found");
        }
    } catch (err) {
        console.error(err.message);
    }
});

app.post('/labor_edit', async(req,res) => {
    try {
        console.log(req.body);
        // const qury = `UPDATE laborlist_and_wages_db.users_info
        // SET account_number = $1, 
        // location_id = $2, 
        // WHERE user_id=$3`;

        const qury_location = `UPDATE laborlist_and_wages_db.location_info 
        SET city = $1, 
        district = $2
        WHERE location_id = $3`;

        const qury_personal = `UPDATE laborlist_and_wages_db.personal_info
        SET name = $1,
        email = $2,
        mobile_number = $3,
        type_of_work = $4
        WHERE labor_id = $5`;

        await pool.query(qury_location, [req.body.city, req.body.district, req.body.location_id]);
        await pool.query(qury_personal, [req.body.name, req.body.email, req.body.mo_number,req.body.type_of_work, req.body.id]);

        res.status(200).redirect('/home');
        // res.status(200).render('instructor/i_info.ejs', {data: allstd.rows[0]});
    } catch (err) {
        console.error(err.message);
    }
});

app.get('/labor_info',async (req, res) => {
    try {
        console.log(req.body);
        
        const allstd = await pool.query(`SELECT * FROM laborlist_and_wages_db.labor WHERE labor_id = ${req.body.labor_id}`);
        console.log(allstd.rows[0]);
        const location_id = allstd.rows[0].location_id;

        // const acc = await pool.query(`SELECT * FROM laborlist_and_wages_db.bank_info WHERE account_number = ${allstd.rows[0].account_number}`);
        const pinfo = await pool.query(`SELECT * FROM laborlist_and_wages_db.personal_info WHERE labor_id = ${req.body.labor_id}`);

        const loc = await pool.query(`SELECT * FROM laborlist_and_wages_db.location_info WHERE location_id = ${location_id}`);

        allstd.rows[0].birth_date = (allstd.rows[0].birth_date).toISOString().slice(0,10);
        if (allstd.rows.length > 0) {
            res.status(200).render('labor/labor_info.ejs', {data: allstd.rows[0], pdata: pinfo.rows[0], location: loc.rows[0]});
        }else {
            res.status(404).send("Labor ID not found");
        }
    } catch (err) {
        console.error(err.message);
    }
});

app.post('/delete_labor', async (req, res)=>{
    try {
        let acc = String(req.body.acc_num);
        await pool.query(`DELETE FROM laborlist_and_wages_db.personal_info WHERE labor_id=${req.body.id}`);
        const qury = `DELETE FROM laborlist_and_wages_db.labor WHERE labor_id = $1`;
        await pool.query(qury, [req.body.id]);
        await pool.query(`DELETE FROM laborlist_and_wages_db.bank_info WHERE account_number='${acc}'`);
        await pool.query(`DELETE FROM laborlist_and_wages_db.location_info WHERE location_id=${req.body.location_id}`);
        
        res.status(304).redirect('/home');
    } catch (err) {
        console.error(err.message);
    }
});







app.get('/supervisor_signin', (req, res) => {
    res.status(200).render('supervisor/supervisor_signin_basic.ejs')
});

app.post('/supervisor_signin', async(req,res) => {
    try {
        console.log(req.body);
        
        var len1 = await pool.query(`SELECT max(supervisor_id) FROM laborlist_and_wages_db.labor_supervisor`)
        console.log(1);
        len1 = parseInt(len1.rows[0].max);
        console.log(len1);
        var len2 = await pool.query(`SELECT max(location_id) FROM laborlist_and_wages_db.location_info`)
        len2 = parseInt(len2.rows[0].max);
        let x = Math.floor((Math.random() * 9999999)+1);
        let y = Math.floor((Math.random() * 999999999)+1);
        let z = Math.floor((Math.random() * 60)+181);

        await pool.query(`INSERT INTO laborlist_and_wages_db.location_info VALUES($1,$2,$3);`,[len2+1, req.body.city, req.body.district]);

        await pool.query(`INSERT INTO laborlist_and_wages_db.bank_info VALUES($1,$2,$3,$4,$5,$6);`,[x.toString(),y.toString(),req.body.name, req.body.email, len1+241, req.body.type_of_user]);
        console.log(2);
        
        await pool.query(`INSERT INTO laborlist_and_wages_db.labor_supervisor VALUES($1,NULL,$2,$3,$4,$5);`,[len1+241,z,len2+1,x.toString(),req.body.passwd]);
        console.log(3);
        await pool.query(`INSERT INTO laborlist_and_wages_db.personal_info VALUES(NULL,NULL,$1,NULL,$2,$3,$4,$5);`,[len1+241, req.body.mo_number, req.body.type_of_user, req.body.name, req.body.email]);

    
        res.status(304).redirect('/home');
    } catch (err) {
        console.error(err.message);
    }
});

app.get('/supervisor_login', (req, res) => {
    res.status(200).render('supervisor/supervisor_login.ejs')
});

app.post('/supervisor_login', async (req, res) => {
    try {
        console.log(req.body);
        
        const allstd = await pool.query(`SELECT * FROM laborlist_and_wages_db.labor_supervisor WHERE supervisor_id = ${req.body.supervisor_id}`);
        console.log(allstd.rows[0]);
        const location_id = allstd.rows[0].location_id;

        // const acc = await pool.query(`SELECT * FROM laborlist_and_wages_db.bank_info WHERE account_number = ${allstd.rows[0].account_number}`);
        const pinfo = await pool.query(`SELECT * FROM laborlist_and_wages_db.personal_info WHERE supervisor_id = ${req.body.supervisor_id}`);

        const loc = await pool.query(`SELECT * FROM laborlist_and_wages_db.location_info WHERE location_id = ${location_id}`);

        
        if (allstd.rows.length > 0) {
            if (req.body.supervisor_passwd == allstd.rows[0].password) {
                res.status(200).render('supervisor/supervisor_info.ejs', {data: allstd.rows[0], pdata: pinfo.rows[0], location: loc.rows[0]});
            } else {
                res.status(404).send("Wrong Password");
            }
        } else {
            res.status(404).send("Labor ID not found");
        }
    } catch (err) {
        console.error(err.message);
    }
});

app.get('/supervisor_edit',async (req, res) => {
    try {
        const allstd = await pool.query(`SELECT * FROM laborlist_and_wages_db.labor_supervisor WHERE supervisor_id = ${req.query.id}`);
        console.log(allstd.rows[0]);
        const location_id = allstd.rows[0].location_id;
        // const acc = await pool.query(`SELECT * FROM laborlist_and_wages_db.bank_info WHERE account_number = ${allstd.rows[0].account_number}`);
        const pinfo = await pool.query(`SELECT * FROM laborlist_and_wages_db.personal_info WHERE supervisor_id = ${req.query.id}`);
        const loc = await pool.query(`SELECT * FROM laborlist_and_wages_db.location_info WHERE location_id = ${location_id}`);
        
        if (allstd.rows.length > 0) {
            res.status(200).render('supervisor/supervisor_edit.ejs', {data: allstd.rows[0], pdata: pinfo.rows[0], location: loc.rows[0]});
        }else {
            res.status(404).send("Supervisor ID not found");
        }
    } catch (err) {
        console.error(err.message);
    }
});

app.post('/supervisor_edit', async(req,res) => {
    try {
        console.log(req.body);
        // const qury = `UPDATE laborlist_and_wages_db.users_info
        // SET account_number = $1, 
        // location_id = $2, 
        // WHERE user_id=$3`;

        const qury_location = `UPDATE laborlist_and_wages_db.location_info 
        SET city = $1, 
        district = $2
        WHERE location_id = $3`;

        const qury_personal = `UPDATE laborlist_and_wages_db.personal_info
        SET name = $1,
        email = $2,
        mobile_number = $3
        WHERE supervisor_id = $4`;

        await pool.query(qury_location, [req.body.city, req.body.district, req.body.location_id]);
        await pool.query(qury_personal, [req.body.name, req.body.email, req.body.mo_number, req.body.id]);

        res.status(200).redirect('/home');
    } catch (err) {
        console.error(err.message);
    }
});

app.get('/supervisor_info',async (req, res) => {
    try {
        console.log(req.body);
        console.log(1);
        
        const allstd = await pool.query(`SELECT * FROM laborlist_and_wages_db.labor_supervisor WHERE supervisor_id = ${req.body.id}`);
        console.log(allstd.rows[0]);
        const location_id = allstd.rows[0].location_id;

        console.log(2);
        // const acc = await pool.query(`SELECT * FROM laborlist_and_wages_db.bank_info WHERE account_number = ${allstd.rows[0].account_number}`);
        const pinfo = await pool.query(`SELECT * FROM laborlist_and_wages_db.personal_info WHERE supervisor_id = ${req.body.id}`);
        console.log(3);
        const loc = await pool.query(`SELECT * FROM laborlist_and_wages_db.location_info WHERE location_id = ${location_id}`);

        
        if (allstd.rows.length > 0) {
            res.status(200).render('supervisor/supervisor_info.ejs', {data: allstd.rows[0], pdata: pinfo.rows[0], location: loc.rows[0]});
        }else {
            res.status(404).send("Labor ID not found");
        }
    } catch (err) {
        console.error(err.message);
    }
});

app.post('/delete_supervisor', async (req, res)=>{
    try {
        let acc = String(req.body.acc_num);
        await pool.query(`DELETE FROM laborlist_and_wages_db.personal_info WHERE supervisor_id=${req.body.id}`);
        const qury = `DELETE FROM laborlist_and_wages_db.labor_supervisor WHERE supervisor_id = $1`;
        await pool.query(qury, [req.body.id]);
        await pool.query(`DELETE FROM laborlist_and_wages_db.bank_info WHERE account_number='${acc}'`);
        await pool.query(`DELETE FROM laborlist_and_wages_db.location_info WHERE location_id=${req.body.location_id}`);
        
        res.status(304).redirect('/home');
    } catch (err) {
        console.error(err.message);
    }
});

app.get('/business_signin', (req, res) => {
    res.status(200).render('business/business_signin_basic.ejs')
});

app.post('/business_signin', async(req,res) => {
    try {
        console.log(req.body);
        
        var len1 = await pool.query(`SELECT max(business_id) FROM laborlist_and_wages_db.business_info`)
        console.log(1);
        len1 = parseInt(len1.rows[0].max);
        console.log(len1);
        var len2 = await pool.query(`SELECT max(location_id) FROM laborlist_and_wages_db.location_info`)
        len2 = parseInt(len2.rows[0].max);
        let x = Math.floor((Math.random() * 9999999)+1);
        let y = Math.floor((Math.random() * 999999999)+1);
        let z = Math.floor((Math.random() * 60)+241);

        await pool.query(`INSERT INTO laborlist_and_wages_db.location_info VALUES($1,$2,$3);`,[len2+1, req.body.city, req.body.district]);

        await pool.query(`INSERT INTO laborlist_and_wages_db.bank_info VALUES($1,$2,$3,$4,$5,$6);`,[x.toString(),y.toString(),req.body.name, req.body.email, len1+241, req.body.type_of_user]);
        console.log(2);
        
        await pool.query(`INSERT INTO laborlist_and_wages_db.business_info VALUES($1,$2,$3,$4,$5,NULL,$6);`,[len1+241,len2+1, z, req.body.name, req.body.email, req.body.passwd]);
        console.log(3);

    
        res.status(304).redirect('/home');
    } catch (err) {
        console.error(err.message);
    }
});

app.get('/business_login', (req, res) => {
    res.status(200).render('business/business_login.ejs')
});

app.post('/business_login', async (req, res) => {
    try {
        console.log(req.body);
        
        const allstd = await pool.query(`SELECT * FROM laborlist_and_wages_db.business_info WHERE business_id = ${req.body.business_id}`);
        console.log(allstd.rows[0]);
        const location_id = allstd.rows[0].location_id;

        // const acc = await pool.query(`SELECT * FROM laborlist_and_wages_db.bank_info WHERE account_number = ${allstd.rows[0].account_number}`);
        const pinfo = await pool.query(`SELECT * FROM laborlist_and_wages_db.business_info WHERE business_id = ${req.body.business_id}`);

        const loc = await pool.query(`SELECT * FROM laborlist_and_wages_db.location_info WHERE location_id = ${location_id}`);

        // allstd.rows[0].birth_date = (allstd.rows[0].birth_date).toISOString().slice(0,10);
        if (allstd.rows.length > 0) {
            if (req.body.business_password == allstd.rows[0].password) {
                res.status(200).render('business/business_info.ejs', {data: allstd.rows[0], pdata: pinfo.rows[0], location: loc.rows[0]});
            } else {
                res.status(404).send("Wrong Password");
            }
        } else {
            res.status(404).send("Business ID not found");
        }
    } catch (err) {
        console.error(err.message);
    }
});

app.get('/business_edit',async (req, res) => {
    try {
        const allstd = await pool.query(`SELECT * FROM laborlist_and_wages_db.business_info WHERE business_id = ${req.query.id}`);
        console.log(allstd.rows[0]);
        const location_id = allstd.rows[0].location_id;
        // const acc = await pool.query(`SELECT * FROM laborlist_and_wages_db.bank_info WHERE account_number = ${allstd.rows[0].account_number}`);
        const loc = await pool.query(`SELECT * FROM laborlist_and_wages_db.location_info WHERE location_id = ${location_id}`);
        
        if (allstd.rows.length > 0) {
            res.status(200).render('business/business_edit.ejs', {data: allstd.rows[0], location: loc.rows[0]});
        }else {
            res.status(404).send("Business ID not found");
        }
    } catch (err) {
        console.error(err.message);
    }
});

app.post('/business_edit', async(req,res) => {
    try {
        console.log(req.body);
        // const qury = `UPDATE laborlist_and_wages_db.users_info
        // SET account_number = $1, 
        // location_id = $2, 
        // WHERE user_id=$3`;

        const qury_location = `UPDATE laborlist_and_wages_db.location_info 
        SET city = $1, 
        district = $2
        WHERE location_id = $3`;

        const qury_personal = `UPDATE laborlist_and_wages_db.business_info
        SET name = $1,
        email = $2
        WHERE business_id = $3`;

        await pool.query(qury_location, [req.body.city, req.body.district, req.body.location_id]);
        await pool.query(qury_personal, [req.body.name, req.body.email, req.body.id]);

        res.status(200).redirect('/home');
        // res.status(200).render('instructor/i_info.ejs', {data: allstd.rows[0]});
    } catch (err) {
        console.error(err.message);
    }
});

app.get('/business_info',async (req, res) => {
    try {
        console.log(req.body);
        
        const allstd = await pool.query(`SELECT * FROM laborlist_and_wages_db.business_info WHERE business_id = ${req.body.business_id}`);
        console.log(allstd.rows[0]);
        const location_id = allstd.rows[0].location_id;

        // const acc = await pool.query(`SELECT * FROM laborlist_and_wages_db.bank_info WHERE account_number = ${allstd.rows[0].account_number}`);

        const loc = await pool.query(`SELECT * FROM laborlist_and_wages_db.location_info WHERE location_id = ${location_id}`);

        
        if (allstd.rows.length > 0) {
            res.status(200).render('labor/labor_info.ejs', {data: allstd.rows[0], location: loc.rows[0]});
        }else {
            res.status(404).send("Business ID not found");
        }
    } catch (err) {
        console.error(err.message);
    }
});

app.post('/delete_business', async (req, res)=>{
    try {
        // let acc = String(req.body.acc_num);
        await pool.query(`DELETE FROM laborlist_and_wages_db.location_info WHERE location_id=${req.body.location_id}`);
        await pool.query(`DELETE FROM laborlist_and_wages_db.business_info WHERE business_id=${req.body.id}`);
        
        
        res.status(304).redirect('/home');
    } catch (err) {
        console.error(err.message);
    }
});

//custom query
app.get('/custom', (req, res) => {
    res.status(200).render('custom/custom');
});

app.post('/custom', async (req, res) => {
    try {
        console.log(req.body);
        const qry = await pool.query(req.body.qury);
        res.status(200).render('custom/custom_res', { data: qry.rows });
    } catch (err) {
        console.error(err.message);
    }
});

app.listen(8000);