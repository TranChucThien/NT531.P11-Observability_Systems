require('dotenv').config()

// Create express
const express = require('express');
const cors = require('cors');
const app = express();
app.use(express.json());
app.use(cors());


const {
    getComments,
    createComment,
    deleteComment
} = require('./controllers/commentController')

app.get('/', (req, res) => {
    res.send("Comment Service is running!");
})

// Get all comments on a ticket
app.get('/:postId', getComments);

// Create a new ticket
app.post('/', createComment);

// Delete a comment
app.delete('/:id', deleteComment);

module.exports = app;