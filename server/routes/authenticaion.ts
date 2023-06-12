import express from 'express';

import {
    createUser,
    getUsers,
    getUserById,
    updateUser,
    getUserByUid,
    getUserFeedPosts,
    getUserMarketPosts
    }from '../controller/authentication'

    const router = express.Router();
    router.post('/adduser', createUser);
    router.get('/getuser', getUsers);
    router.get('/byid/:id', getUserById);
    router.get('/uid/:uid',getUserByUid)
    router.put('/update/:id' ,updateUser);
 
   router.get('/:id/feed/posts', getUserFeedPosts);
   router.get('/:id/market/posts', getUserMarketPosts);
    export default router;