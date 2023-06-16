import { PrismaClient, PostM, ReviewM, User } from '@prisma/client';

import { Request, Response } from 'express';

const prisma = new PrismaClient();

//------------------------------------------------------------ TEST USER ---------------------------------------------------------------------------------
//-------------------------------------------------------test for posting a user with id 
/* export const test = async (req: Request, res: Response): Promise<void> => {
  const { name, email, address, level } = req.body;

  try {
    const user = await prisma.user.create({
      data: {
        name,
        email,
        address,
        level,
      },
    });

    res.json(user);
  } catch (error) {
    res.status(500).json({ error: 'Error creating user' });
  }
}; */

//------------------------------------------------------------ POST MARKET PLACE ---------------------------------------------------------------------------------

//---------------------------------------------------------creation of gig
export const createPost = async (req: Request, res: Response): Promise<void> => {
  const { price, image, title, description, skill, userId } = req.body;
  console.log(req.query)
  try {
    const post = await prisma.postM.create({
      data: {
        price,
        image,
        title,
        description,
        skill,
        userId,
      },
    });
    res.json(post);
  } catch (error) {
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
    const { rating, postId, userId } = req.body;
    try {
      const review = await prisma.reviewM.create({
        data: {
          rating,
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
      const reviews = await prisma.reviewM.findMany({
        include: {
          post: true,
          user: true,
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
 
  