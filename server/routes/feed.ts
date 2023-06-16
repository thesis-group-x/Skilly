import express from 'express';
import {
  getPosts,
  getPostById,
  getPostsBySkill,
  getPostsByTitle,
  createPost,
  updatePost,
  deletePost,
} from '../controller/feed'

const router = express.Router();


router.get('/', getPosts);
router.get('/:id', getPostById);
router.get('/skill/:skill', getPostsBySkill);
router.get('/title/:title', getPostsByTitle);
router.post('/post', createPost);
router.put('/:id', updatePost);
router.delete('/:id', deletePost);



export default router;

