
import { PrismaClient } from '@prisma/client';
import { Request, Response } from 'express';
const cloudinary = require('cloudinary').v2;

// Configure Cloudinary
cloudinary.config({
  cloud_name: 'dwtho2kip',
  api_key: '629975817477331',
  api_secret: 'a6PFr92otxe7aXA8Vwc2M2ndon4',
});

const prisma = new PrismaClient();

//------------------------------------------------------------ POST MARKET PLACE ---------------------------------------------------------------------------------

//---------------------------------------------------------creation of gig
export const createPost = async (req: Request, res: Response): Promise<void> => {
  const {  title, description, skill } = req.body;
  const userId=1
  const price=23

  try {
   
    const result = await cloudinary.uploader.upload("https://images.unsplash.com/photo-1617396900799-f4ec2b43c7ae?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8NHx8d2FsbHBhcGVyJTIwNGt8ZW58MHx8MHx8fDA%3D&w=1000&q=80", { upload_preset: 'kusldcry' });

    const post = await prisma.postM.create({
      data: {
        price,
        image: result.secure_url,
        title,
        description,
        skill,
        userId,
      },
    });

    res.json(post);
  } catch (error) {
    console.log(error)
    res.status(500).json({ error: 'Error creating post' });
  }
};

//---------------------------------------------------------feed gigs
export const getPosts = async (req: Request, res: Response): Promise<void> => {
    
  try {
    const posts = await prisma.postM.findMany();//query mtaa l find all f prisma
    res.json(posts);
  } catch (error) {
    res.status(500).json({ error: 'Cant retrieve' });
  }
};
//---------------------------------------------------------get post by id 
export const searchPostsByid = async (req: Request, res: Response): Promise<void> => {
    const { id } = req.params;
    console.log(id)
    try {
      const posts = await prisma.postM.findMany({
        where: { id: Number(id) },
      });
      res.json(posts);
    } catch (error) {
      res.status(500).json({ error: 'Error searching posts' });
    }
  };

  //-------------------------------------------------search by skill posts
export const searchPostsBySkill = async (req: Request, res: Response): Promise<void> => {
  const { skill } = req.query;
  console.log(skill)
  try {
    const posts = await prisma.postM.findMany({
      where: { skill: { contains: skill as string } },
    });
    res.json(posts);
  } catch (error) {
    res.status(500).json({ error: 'Error searching posts' });
  }
};

//------------------------------------------------------update gig
export const updatePost = async (req: Request, res: Response): Promise<void> => {
  const { id } = req.params;
  const { price, image, description, skill } = req.body;
  try {
    const post = await prisma.postM.update({
      where: { id: Number(id) },
      data: {
        price,
        image,
        description,
        skill,
      },
    });
    res.json(post);
  } catch (error) {
    res.status(500).json({ error: 'Error updating post' });
  }
};
 //------------------------------------------------delete post mtaa l market place
 export const deletePost = async (req: Request, res: Response): Promise<void> => {
  const { id } = req.params;
  try {
    const post = await prisma.postM.delete({
      where: { id: Number(id) },
    });
    res.json(post);
  } catch (error) {
    res.status(500).json({ error: 'Error deleting post' });
  }
};
//------------------------------------------------------------ Reviews ---------------------------------------------------------------------------------

//creation of review
export const createReview = async (req: Request, res: Response): Promise<void> => {
    const { rating,comment, postId, userId } = req.body;
    try {
      const review = await prisma.reviewM.create({
        data: {
          rating,
          comment,
          postId,
          userId,
        },
      });
      res.json(review);
    } catch (error) {
      res.status(500).json({ error: 'Error creating review' });
    }
  };
  //geting them
  export const getReviews = async (req: Request, res: Response): Promise<void> => {
    try {
      const { id } = req.params;
  
      const reviews = await prisma.reviewM.findMany({
        where: {
          postId: Number(id), // Assuming postId is a number
        },
        select: {
          rating: true,
          comment: true,
          userId:true
        },
      });
  
      res.json(reviews);
    } catch (error) {
      res.status(500).json({ error: 'Error retrieving reviews' });
    }
  };
  
  
  //update review 
  export const updateReview = async (req: Request, res: Response): Promise<void> => {
    const { id } = req.params;
    const { rating } = req.body;
    try {
      const review = await prisma.reviewM.update({
        where: { id: Number(id) },
        data: {
          rating,
        },
      });
      res.json(review);
    } catch (error) {
      res.status(500).json({ error: 'Error updating review' });
    }
  };
  //delete review 
  export const deleteReview = async (req: Request, res: Response): Promise<void> => {
    const { id } = req.params;
    try {
      const review = await prisma.reviewM.delete({
        where: { id: Number(id) },
      });
      res.json(review);
    } catch (error) {
      res.status(500).json({ error: 'Error deleting review' });
    }
  };
 