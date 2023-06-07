import express from 'express';
import dotenv from 'dotenv';
import pgPromise from 'pg-promise';
import routerMarket from './routes/market';
import routerInterests from './routes/interests'
import routerFeed from './routes/feed';
import routerCountry from './routes/country';
import routerAuthentication from './routes/authenticaion';
import cors from 'cors';
import axios from 'axios';
import { PrismaClient } from '@prisma/client';



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
app.use('/countries' , routerCountry)
app.use('/Market', routerMarket);
app.use('/api', routerInterests);
app.use('/feed', routerFeed);
app.use('/user', routerAuthentication);

app.get('/', (req, res) => {
  res.send('Hello, 9lewi');
});

async function insertCountriesData() {
  try {
    const response = await axios.get('https://restcountries.com/v3.1/all');
    const countriesData = response.data;

    for (const countryData of countriesData) {
      const { name } = countryData;
      
      await prisma.country.create({
        data: {
          name: name.common,
        },
      });      
    }

    console.log('Countries data inserted successfully.');
  } catch (error) {
    console.error('Error inserting countries data:', error);
  }
}

async function main() {
  await prisma.$connect();
  await insertCountriesData();
}

main()
  .catch((error) => {
    console.error('Error starting the server:', error);
  })
  .finally(async () => {
    await prisma.$disconnect();
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
