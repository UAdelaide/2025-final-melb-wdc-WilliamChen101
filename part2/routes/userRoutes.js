const express = require('express');
const router = express.Router();
const db = require('../models/db');

router.post('/login', async (req, res) => {
  const { email, password } = req.body;

  try {
    const [rows] = await db.query(`
      SELECT user_id, username, role FROM Users
      WHERE email = ? AND password_hash = ?
    `, [email, password]);

    if (rows.length === 0) {
      return res.send('Invalid email or password. <a href="/">Try again</a>');
    }


    req.session.user = {
      id: rows[0].user_id,
      username: rows[0].username,
      role: rows[0].role
    };

    console.log('Login successful, written in session:', req.session.user);


    if (rows[0].role === 'owner') {
      res.redirect('/owner-dashboard');
    } else if (rows[0].role === 'walker') {
      res.redirect('/walker-dashboard');
    } else {
      res.send('Unknown role.');
    }

  } catch (error) {
    console.error('❌ login error:', error);
    res.status(500).send('Login failed');
  }
});

router.get('/logout', (req, res) => {
  req.session.destroy(err => {
    res.clearCookie('connect.sid');
    res.redirect('/');
  });
});

//q16
router.get('/me', (req, res) => {
  if (!req.session.user) {
    return res.status(401).json({ error: 'Not logged in' });
  }
  res.json({
    id:       req.session.user.id,
    username: req.session.user.username,
    role:     req.session.user.role
  });
});

module.exports = router;