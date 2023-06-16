import { PrismaClient } from '@prisma/client';
import { Request, Response } from 'express';

const prisma = new PrismaClient();

export const getOtherById = async (req: Request, res: Response): Promise<void> => {
    const { id } = req.params;
  
    try {
      const user = await prisma.user.findUnique({
        where: { id: Number(id) },
      });
      
      if (user) {
        res.json(user);
      } else {
        res.status(404).json({ error: 'user not found' });
      }
    } catch (error) {
      console.error(error);
      res.status(500).json({ error: 'Error retrieving user' });
    }
  };
  export const getPostsByUserId = async (req: Request, res: Response): Promise<void> => {
    const { id } = req.params;
  
    try {
      const posts = await prisma.post.findMany({
        where: { userId: Number(id) },
      });
  
      res.json(posts);
    } catch (error) {
      res.status(500).json({ error: 'Error retrieving posts' });
    }
  };
  // export const getMarketPostsByUserId = async (req: Request, res: Response): Promise<void> => {
  //   const { userId } = req.params;
  
  //   try {
  //     const posts = await prisma.postM.findMany({
  //       where: {
  //         userId: Number (userId),
  //       },
  //     });
  //     if (userId) {
  //       res.json(userId);
  //     } else {
  //       res.status(404).json({ error: 'user not found' });
  //     }
  //   } catch (error) {
  //     console.error(error);
  //     res.status(500).json({ error: 'Error retrieving Market' });
  //   }
  // };
  export const getMarketPostsByUserId = async (req: Request, res: Response): Promise<void> => {
    const {id} = req.params;
  
    try {
      const posts = await prisma.postM.findMany({
        where: {
          userId: Number(id) },
        });
        res.json(posts);
      } catch (error) {
        res.status(500).json({ error: 'Error retrieving posts' });
      }
  };
  
  
  

  
  
  
  
  