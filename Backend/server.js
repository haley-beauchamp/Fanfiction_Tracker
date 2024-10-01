const express = require('express');
const app = express();
const port = 3000;

app.get('/', (req, res) => {
  res.send('Hello World!')
})
app.listen(port, () => {
  console.log(`Server running at http://localhost:${port}`)
})

const books = [
  {id: 1, title: 'Alice in Wonderland', author: 'Lewis Carrol'},
  {id: 2, title: 'Around the World in eighty days', author: 'Jules Verne'},
  {id: 3, title: 'Utopia', author: 'Sir Thomas Moor'},
 ]

 app.get('/api/books', (req, res) => {
  res.json(books)
 })