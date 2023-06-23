import express from 'express';
import dotenv from 'dotenv';
import pgPromise from 'pg-promise';
import routerMarket from './routes/market';
import routerInterests from './routes/interests'
import routerFeed from './routes/feed';
import routerBuy from './routes/buy'
import routerStripe from './routes/points'
import routerAuthentication from './routes/authenticaion';
import routerMatching from './routes/matching';
import routerfc from './routes/feedComments';
import cors from 'cors';
import { PrismaClient } from '@prisma/client';
import routerProfile  from './routes/profile';
import routerOther from './routes/other';




const admin = require('firebase-admin');
const serviceAccount = require('../client/add.json');

admin.initializeApp({
    credential: admin.credential.cert(serviceAccount) ,
    databaseURL: 'https://console.firebase.google.com/project/skilly-d8050/overview'
});
dotenv.config();
const prisma = new PrismaClient();
const app = express();
const db = pgPromise()(process.env.DATABASE_URL1 as string);
const port = process.env.PORT;

app.use(express.json());
app.use(cors()); 
app.use('/feedCom', routerfc)
app.use('/Market', routerMarket);
app.use('/Market',routerBuy);
app.use('/stripe',routerStripe);
app.use('/api', routerInterests);
app.use('/feed', routerFeed);
app.use('/up',routerProfile);
app.use('/other',routerOther)
app.use('/user', routerAuthentication);
app.use('/match',routerMatching)

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
