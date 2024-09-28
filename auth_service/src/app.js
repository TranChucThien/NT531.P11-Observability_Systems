require('dotenv').config()

const express = require('express');
const cors = require('cors');
const cookieParser = require('cookie-parser');

const app = express();
app.use(cors());
app.use(express.json());
app.use(cookieParser());

app.get('/', (req, res) => {
    res.send("Authentication Service is running!");
});

app.get('/set-cookie', (req, res) => {
    res.cookie('current_user', true);
    res.send("Cookie for user set");
});

app.get('/get-cookie', (req, res) => {
    const cookies = req.cookies;
    res.json(cookies);
})

const authRoutes = require('./routes/authRoutes');
app.use(authRoutes);


module.exports = app;