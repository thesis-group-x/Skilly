import express from 'express';
import {getOtherById,getPostsByUserId,getMarketPostsByUserId}  from '../controller/other';


const router = express.Router();

router.get('/:id', getOtherById);
router.get('/post/:id', getPostsByUserId);
router.get('/marketpost/:id', getMarketPostsByUserId);

export default router;