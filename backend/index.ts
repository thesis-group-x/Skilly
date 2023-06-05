import express from 'express';
import dotenv from 'dotenv';
import pgPromise from 'pg-promise';
import routerMarket from './routes/market';
import routerInterests from './routes/interests'

dotenv.config();

const app = express();
app.use(express.json());
const db = pgPromise()(process.env.DATABASE_URL1 as string); 
const port = process.env.PORT 

app.use(express.json());

app.use('/Market',routerMarket);
app.use('/api',routerInterests)



app.get('/', (req, res) => {
  res.send('Hello, 9lewi');
});

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
