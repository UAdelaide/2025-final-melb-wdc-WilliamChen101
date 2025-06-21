const express = require('express');
const router  = express.Router();
const db      = require('../models/db');

router.use((req, res, next) => {
  if (!req.session.user) {
    return res.status(401).send('Unauthorized');
  }
  if (req.session.user.role !== 'owner') {
    return res.status(403).send('Forbidden');
  }
  next();
});

router.get('/', async (req, res) => {
  try {
    const ownerId = req.session.user.id;
    const [rows] = await db.query(
      'SELECT dog_id, name FROM Dogs WHERE owner_id = ?',
      [ownerId]
    );
    res.json(rows);
  } catch (err) {
    console.error('SQL Error:', err);
    res.status(500).json({ error: 'Failed to fetch dogs' });
  }
});

module.exports = router;