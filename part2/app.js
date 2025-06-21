const express = require('express');
const path = require('path');
const cookieParser = require('cookie-parser');
const session = require('express-session');
require('dotenv').config();

const app = express();

app.use(express.json());
app.use(express.urlencoded({ extended: true }));
app.use(cookieParser());
app.use(session({
  secret: 'your_secret_key', 
  resave: false,
  saveUninitialized: true
}));

app.use(express.static(path.join(__dirname, '/public')));

const walkRoutes = require('./routes/walkRoutes');
const dogRoutes  = require('./routes/dogRoutes'); //ADD q15
const userRoutes = require('./routes/userRoutes');

app.use('/api/walks', walkRoutes);
app.use('/api/dogs', dogRoutes); //ADD q15
app.use('/api/users', userRoutes);
app.use('/', userRoutes); 

app.get('/owner-dashboard', (req, res) => {
  console.log('Owner session:', req.session); 
  if (!req.session.user || req.session.user.role !== 'owner') {
    return res.redirect('/');
  }
  res.sendFile(path.join(__dirname, 'public/owner-dashboard.html'));
});

app.get('/walker-dashboard', (req, res) => {
  console.log('Walker session:', req.session); 
  if (!req.session.user || req.session.user.role !== 'walker') {
    return res.redirect('/');
  }
  res.sendFile(path.join(__dirname, 'public/walker-dashboard.html'));
});

module.exports = app;