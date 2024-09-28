require('dotenv').config()

// Create express
const app = require('./app');


// Set port
const port = process.env.PORT || 8001;
// Connect database
const mongoose = require('mongoose');
mongoose.connect(process.env.MONGO_URI)
   .then(() => {
        app.listen(port, () => {
            console.log('Connected to database');
            console.log(`Post service listening at http://localhost:${port}`);
        });
   })
   .catch(err => console.log(err));