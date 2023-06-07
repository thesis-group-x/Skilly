import express from 'express';
 import { getUserList, getUserInterests, updateUserInterests } from '../controller/interests';

const router = express.Router();

// //Create user
 


// // Get all users
 router.get('/a', getUserList);

 // Get user interests
 router.get('/:userId', getUserInterests);

// // Update user interests
 router.post('/:userId', updateUserInterests);

export default router;
