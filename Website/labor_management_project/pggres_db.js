const Pool = require('pg').Pool;

const pool = new Pool({
    host: "localhost",
    user: "postgres",
    port: 5432,
    password: "jay",
    database: "laborlist_and_wages"
});

module.exports = pool;
