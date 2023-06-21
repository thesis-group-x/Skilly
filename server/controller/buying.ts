import { PrismaClient, User } from '@prisma/client';
import { Request, Response } from 'express';

const prisma = new PrismaClient();
export const buyPost = async (req: Request, res: Response): Promise<void> => {
    const { postId, buyerId } = req.body;
  
    try {
      const post = await prisma.postM.findUnique({
        where: {
          id: postId,
        },
      });
  
      if (!post) {
        res.status(404).json({ error: 'Post not found' });
        return;
      }
  
      const buyer = await prisma.user.findUnique({
        where: {
          uid: buyerId,
        },
      });
  
      if (!buyer) {
        res.status(404).json({ error: 'Buyer not found' });
        return;
      }
  
      const seller = await prisma.user.findUnique({
        where: {
          id: post.userId,
        },
      });
  
      if (!seller) {
        res.status(404).json({ error: 'Seller not found' });
        return;
      }
  
      if (buyer.points < post.price) {
        res.status(400).json({ error: 'Insufficient points' });
        return;
      }
  
      // tnakes point w tzid level
      const updatedBuyer = await prisma.user.update({
        where: {
          uid: buyerId,
        },
        data: {
          points: buyer.points - post.price,
          level: buyer.level + 5,
        },
      });
  
      // tzid points w level
      const updatedSeller = await prisma.user.update({
        where: {
          id: seller.id,
        },
        data: {
          points: seller.points + post.price,
          level: seller.level + 5,
        },
      });
  
      res.json({ buyer: updatedBuyer, seller: updatedSeller });
    } catch (error) {
      console.log(error);
      res.status(500).json({ error: 'Error buying post' });
    }
  };
  