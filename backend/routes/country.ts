import express from 'express';
import { getAllCountries } from '../controller/country';

const router = express.Router();


router.get('/', getAllCountries);

export default router;
