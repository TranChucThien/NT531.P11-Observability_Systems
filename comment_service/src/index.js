const app = require('./app');

// Connect database
const mongoose = require('mongoose');
// Set port
const port = process.env.PORT || 8003;
mongoose.connect(process.env.MONGO_URI)
   .then(() => {
        app.listen(port, () => {
            console.log('Connected to database');
            console.log(`Comment service listening at http://localhost:${port}`);
        });
   })
   .catch(err => console.log(err));