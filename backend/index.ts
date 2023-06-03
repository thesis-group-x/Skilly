import express from 'express';
import dotenv from 'dotenv';
import pgPromise from 'pg-promise';

dotenv.config();

const app = express();
const db = pgPromise()(process.env.DATABASE_URL1 as string); 
const port = process.env.PORT 


db.connect()
  .then(() => {
    console.log('Database connected');
    app.listen(port, () => {
      console.log(`Server is running on port ${port}`);
    });
  })
  .catch((error) => {
    console.error('Error connecting to the database:', error);
  });

app.get('/', (req, res) => {
  res.send('Hello, 9lewi');
});

