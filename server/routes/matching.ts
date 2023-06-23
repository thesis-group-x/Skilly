import express from 'express';
import FriendshipController from '../controller/matching';

const router = express.Router();
const friendshipController = new FriendshipController();

// tsendi
router.post('/friendships', friendshipController.createFriendship);

// tgetii
router.get('/friendships/get/:userId', friendshipController.getFriendshipRequests);

// accept
router.put('/friendships/accept/:friendshipId', friendshipController.acceptFriendshipRequest);

// decline
router.put('/friendships/decline/:friendshipId', friendshipController.declineFriendshipRequest);

export default router;
