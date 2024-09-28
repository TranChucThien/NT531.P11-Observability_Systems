require('dotenv').config()

// Create express
const express = require('express');
const cors = require('cors');
const app = express();
app.use(express.json());
app.use(cors());


const {
    getPosts,
    getOnePost,
    createPost,
    deletePost
} = require('./controllers/postController')

app.get('/', (req, res) => {
    res.send("Post Service is running!");
})

app.get('/all', getPosts);

// Get one ticket
app.get('/all/:id', getOnePost);

// Create a new ticket
app.post('/', createPost);

app.delete('/:id', deletePost);

module.exports = app;