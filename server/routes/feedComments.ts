import express from 'express';
import { createComment, getCommentsByPostId } from '../controller/feedComments';

const router = express.Router();


router.post('/create', createComment);


router.get('/:postId', getCommentsByPostId);

export default router;
