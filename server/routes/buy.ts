import { Router } from 'express';
import {buyPost} from '../controller/buying'

const router = Router();

router.post('/posts/buy', buyPost);

export default router;
