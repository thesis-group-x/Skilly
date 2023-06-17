import express from 'express';
import {
  getPosts,
  searchPostsByid,
  createPost,
  updatePost,
  searchPostsBySkill,
  createReview,
  getReviews,
  updateReview,
  deleteReview,
  deletePost,
} from '../controller/market'

const router = express.Router();
router.get('/posts', getPosts);
router.get('/post/:id',searchPostsByid);
router.post('/posts', createPost);
router.put('/posts/:id', updatePost);
router.get('/posts/search', searchPostsBySkill);
router.post('/reviews', createReview);
router.get('/reviews', getReviews);
router.put('/reviews/:id', updateReview);
router.delete('/reviews/:id', deleteReview);
router.delete('/posts/:id', deletePost);

export default router;
