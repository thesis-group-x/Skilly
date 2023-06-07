import express from 'express';

import {
    createUser,
    getUsers,
    getUserById
    }from '../controller/authentication'

    const router = express.Router();
    router.post('/adduser', createUser);
    router.get('/getuser', getUsers);
    router.get('/byid/:id', getUserById);
    
    export default router;