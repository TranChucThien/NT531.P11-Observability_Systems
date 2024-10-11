const app = require('./app');

// Set port
const port = process.env.PORT || 8080;
app.listen(port, () => {
    console.log(`API Gateway is running on port ${port}`);
})