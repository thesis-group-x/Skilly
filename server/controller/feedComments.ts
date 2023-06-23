import { PrismaClient, Comment } from '@prisma/client';
import { Request, Response } from 'express';

const prisma = new PrismaClient();

export const createComment = async (req: Request, res: Response): Promise<void> => {
  const { text, postId, userId } = req.body;

  try {
    const comment = await prisma.comment.create({
      data: {
        text,
        postId,
        userId,
      },
    });

    const updatedUser = await prisma.user.update({
      where: {
        id: userId,
      },
      data: {
        points: {
          increment: 5,
        },
      },
    });

    res.json({ comment, user: updatedUser });
  } catch (error) {
    res.status(500).json({ error: error });
  }
};


export const getCommentsByPostId = async (req: Request, res: Response): Promise<void> => {
    const { postId } = req.params;
  
    try {
      const comments: Comment[] = await prisma.comment.findMany({
        where: {
          postId: parseInt(postId),
        },
        select: {
          id: true,
          text: true,
          userId: true,
          postId: true,
        },
      });
  
      res.status(200).json(comments);
    } catch (error) {
      res.status(500).json({ error: 'Failed to retrieve comments.' });
    }
  };
  