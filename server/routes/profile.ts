import express from 'express';
import updateUser from '../controller/profileUser';


const router = express.Router();

router.put('/updateuser/:userId', updateUser);
// router.get('/getother/:uid',getOtherUser);


export default router;
