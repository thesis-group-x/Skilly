import express from 'express';

import {
    createUser,
    getUsers,
    getUserById,
    updateUser,
    getUserByUid,
    getUserFeedPosts,
    getUserMarketPosts,
    updateUserByUid,
    }from '../controller/authentication'

    const router = express.Router();
    router.post('/adduser', createUser);
    router.get('/getuser', getUsers);
    router.get('/byid/:id', getUserById);
    router.get('/uid/:uid',getUserByUid)
    router.put('/update/:id' ,updateUser);
    router.get('/uid/:uid/feed/posts', getUserFeedPosts); 
    router.get('/uid/:uid/market/posts', getUserMarketPosts); 
    router.put('/upd/:uid', updateUserByUid);
    
    export default router;