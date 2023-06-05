import express from 'express';

import {
createUser
}from '../controller/authentication'



const router = express.Router();
router.post('/', createUser);


export default router;