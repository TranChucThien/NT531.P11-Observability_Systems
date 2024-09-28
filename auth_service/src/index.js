require('dotenv').config()

const express = require('express');
const cors = require('cors');
const cookieParser = require('cookie-parser');

const app = require("./app");

// Connect database
const port = process.env.PORT || 8003
const mongoose = require('mongoose');
mongoose.connect(process.env.MONGO_URI)
   .then(() => {
        app.listen(port, () => {
            console.log('Connected to database');
            console.log(`Auth service listening at http://localhost:${port}`);
        });
   })
   .catch(err => console.log(err));