import express from 'express';
import { purchasePoints,getPack,createPack,getAllPacks } from '../controller/points' ; // Replace 'yourController' with the actual name of your controller file

const router = express.Router();

router.post('/purchase/:uid', purchasePoints);
router.get('/packs/:packId', getPack);
router.post('/packs', createPack);//for test
router.get('/packs',getAllPacks) 

export default router;
