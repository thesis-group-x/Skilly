import { PrismaClient } from '@prisma/client';
import { Request, Response } from 'express';

const prisma = new PrismaClient();

export const getPosts = async (req: Request, res: Response): Promise<void> => {
  try {
    const posts = await prisma.post.findMany();
    res.json(posts);
  } catch (error) {
    res.status(500).json({ error: 'Error retrieving posts' });
  }
};

export const getPostById = async (req: Request, res: Response): Promise<void> => {
  const { id } = req.params;
  try {
    const post = await prisma.post.findUnique({
      where: { id: Number(id) },
    });
    if (post) {
      res.json(post);
    } else {
      res.status(404).json({ error: 'Post not found' });
    }
  } catch (error) {
    res.status(500).json({ error: 'Error retrieving post' });
  }
};

export const getPostsBySkill = async (req: Request, res: Response): Promise<void> => {
  const { skill } = req.query;
  try {
    const posts = await prisma.post.findMany({
      where: { skill: String(skill) },
    });
    res.json(posts);
  } catch (error) {
    res.status(500).json({ error: 'Error retrieving posts' });
  }
};

export const getPostsByTitle = async (req: Request, res: Response): Promise<void> => {
  const { title } = req.query;
  try {
    const posts = await prisma.post.findMany({
      where: { title: { contains: String(title) } },
    });
    res.json(posts);
  } catch (error) {
    res.status(500).json({ error: 'Error retrieving posts' });
  }
};

export const createPost = async (req: Request, res: Response): Promise<void> => {
  const { image, title, skill, desc, userId } = req.body;

  try {
    const post = await prisma.post.create({
      data: {
        image,
        title,
        skill,
        desc,
        likes: 0,
        userId,
      },
    });

    const updatedUser = await prisma.user.update({
      where: {
        id: userId,
      },
      data: {
        points: {
          increment: 10,
        },
      },
    });

    res.json({ post, user: updatedUser });
  } catch (error) {
    res.status(500).json({ error: 'Error creating post' });
  }
};

export const updatePost = async (req: Request, res: Response): Promise<void> => {
  const { id } = req.params;
  const { image, title, skill, desc, userId, likes } = req.body;
  try {
    const post = await prisma.post.update({
      where: { id: Number(id) },
      data: {
        image,
        title,
        skill,
        desc,
        userId,
        likes, 
      },
    });
    res.json(post);
  } catch (error) {
    res.status(500).json({ error: 'Error updating post' });
  }
};


export const deletePost = async (req: Request, res: Response): Promise<void> => {
  const { id } = req.params;
  try {
    const post = await prisma.post.delete({
      where: { id: Number(id) },
    });
    res.json(post);
  } catch (error) {
    res.status(500).json({ error: 'Error deleting post' });
  }
};