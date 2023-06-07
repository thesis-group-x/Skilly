import express from 'express';
import dotenv from 'dotenv';
import pgPromise from 'pg-promise';
import routerMarket from './routes/market';
import routerAuthentication from './routes/authenticaion'

const admin = require('firebase-admin');
const serviceAccount = require('../client/add.json');

admin.initializeApp({
    credential: admin.credential.cert(serviceAccount) ,
    databaseURL: 'https://console.firebase.google.com/project/skilly-d8050/overview'
});
dotenv.config();

const app = express();
app.use(express.json());

const db = pgPromise()(process.env.DATABASE_URL1 as string);
const port = process.env.PORT;




app.use('/Market', routerMarket);
app.use('/user', routerAuthentication);

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
