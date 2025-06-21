const express = require('express');
const path = require('path');
const cookieParser = require('cookie-parser');
const session = require('express-session');
require('dotenv').config();

const app = express();

// ✅ 中间件配置（必须在路由前）
app.use(express.json());
app.use(express.urlencoded({ extended: true }));
app.use(cookieParser());
app.use(session({
  secret: 'your_secret_key', // 替换为任意字符串即可
  resave: false,
  saveUninitialized: true
}));

// ✅ 静态文件服务
app.use(express.static(path.join(__dirname, '/public')));

// ✅ 路由导入
const walkRoutes = require('./routes/walkRoutes');
const userRoutes = require('./routes/userRoutes');

// ✅ 路由挂载
app.use('/api/walks', walkRoutes);
app.use('/api/users', userRoutes);
app.use('/', userRoutes); // ✔️ 支持 /login 表单提交

// ✅ 登录后跳转的页面（验证 session）
app.get('/owner-dashboard', (req, res) => {
  console.log('Owner session:', req.session); // ✅ 调试用
  if (!req.session.user || req.session.user.role !== 'owner') {
    return res.redirect('/');
  }
  res.sendFile(path.join(__dirname, 'public/owner-dashboard.html'));
});

app.get('/walker-dashboard', (req, res) => {
  console.log('Walker session:', req.session); // ✅ 调试用
  if (!req.session.user || req.session.user.role !== 'walker') {
    return res.redirect('/');
  }
  res.sendFile(path.join(__dirname, 'public/walker-dashboard.html'));
});

module.exports = app;