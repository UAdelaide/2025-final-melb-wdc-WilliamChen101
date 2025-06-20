var express = require('express');
var path = require('path');
var cookieParser = require('cookie-parser');
var logger = require('morgan');
var mysql = require('mysql2/promise');

var app = express();

app.use(logger('dev'));
app.use(express.json());
app.use(express.urlencoded({ extended: false }));
app.use(cookieParser());

let db;

(async () => {
  try {
    const connection = await mysql.createConnection({
      host: 'localhost',
      user: 'root',
      password: 'Chenweiyu101'
    });

    await connection.query('CREATE DATABASE IF NOT EXISTS testdb');
    await connection.end();

    db = await mysql.createConnection({
      host: 'localhost',
      user: 'root',
      password: 'Chenweiyu101',
      database: 'testdb'
    });

    await db.execute(`
      CREATE TABLE IF NOT EXISTS books (
        id INT AUTO_INCREMENT PRIMARY KEY,
        title VARCHAR(255),
        author VARCHAR(255)
      )
    `);

    const [rows] = await db.execute('SELECT COUNT(*) AS count FROM books');
    if (rows[0].count === 0) {
      await db.execute(`
        INSERT INTO books (title, author) VALUES
        ('1984', 'George Orwell'),
        ('To Kill a Mockingbird', 'Harper Lee'),
        ('Brave New World', 'Aldous Huxley')
      `);
    }

    const usersRouter = require('./routes/users');
    app.use('/users', usersRouter);

    app.use(express.static(path.join(__dirname, 'public')));

    app.get('/api/dogs', async (req, res) => {
      try {
        const [rows] = await db.execute(`
          SELECT d.name AS dog_name, d.size, u.username AS owner_username
          FROM dogs d
          JOIN users u ON d.owner_id = u.user_id
        `);
        res.json(rows);
      } catch (err) {
        console.error('/api/dogs error:', err);
        res.status(500).json({ error: 'Database error' });
      }
    });

    app.get('/api/walkrequests/open', async (req, res) => {
      try {
        const [rows] = await db.execute(`
          SELECT wr.request_id, d.name AS dog_name, wr.requested_time, wr.duration_minutes, wr.location, u.username AS owner_username
          FROM walkrequests wr
          JOIN dogs d ON wr.dog_id = d.dog_id
          JOIN users u ON d.owner_id = u.user_id
          WHERE wr.status = 'open'
        `);
        res.json(rows);
      } catch (err) {
        console.error('/api/walkrequests/open error:', err);
        res.status(500).json({ error: 'Database error' });
      }
    });

    app.get('/api/walkers/summary', async (req, res) => {
      try {
        const [rows] = await db.execute(`
          SELECT
            w.username AS walker_username,
            COUNT(r.rating) AS total_ratings,
            ROUND(AVG(r.rating), 1) AS average_rating,
            COUNT(wr.request_id) AS completed_walks
          FROM users w
          LEFT JOIN walkrequests wr ON w.user_id = wr.walker_id AND wr.status = 'completed'
          LEFT JOIN ratings r ON wr.request_id = r.request_id
          WHERE w.role = 'walker'
          GROUP BY w.username
        `);
        res.json(rows);
      } catch (err) {
        console.error('/api/walkers/summary error:', err);
        res.status(500).json({ error: 'Database error' });
      }
    });

  } catch (err) {
    console.error('Startup error:', err);
  }
})();

module.exports = app;
