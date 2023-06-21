import { PrismaClient } from '@prisma/client';
import { Request, Response } from 'express';

const prisma = new PrismaClient();

export const purchasePoints = async (req: Request, res: Response): Promise<void> => {
  const { packId} = req.body;
  const { uid } = req.params;

  try {
    const pack = await prisma.pack.findUnique({
      where: {
        id: packId,
      },
    });

    if (!pack) {
      res.status(404).json({ error: 'Pack not found' });
      return;
    }

    const user = await prisma.user.findUnique({
      where: {
      uid,
      }
    });

    if (!user) {
      res.status(404).json({ error: 'User not found' });
      return;
    }
    await prisma.user.update({
      where: {
        uid,
      },
      data: {
        points: {
          increment: pack.points,
        },
      },
    });

    res.json({ success: true, message: 'Points purchased successfully' });
  } catch (error) {
    console.log(error);
    res.status(500).json({ error: 'Error purchasing points' });
  }
};


  //testing 
  export const getPack = async (req: Request, res: Response): Promise<void> => {
    const { packId } = req.params;
  
    try {
      const pack = await prisma.pack.findUnique({
        where: { id: parseInt(packId) },
      });
  
      if (!pack) {
        res.status(404).json({ error: 'Pack not found' });
        return;
      }
  
      res.json(pack);
    } catch (error) {
      console.log(error);
      res.status(500).json({ error: 'Internal server error' });
    }
  };
  export const createPack = async (req: Request, res: Response): Promise<void> => {
    const { name, points, price } = req.body;
  
    try {
      const pack = await prisma.pack.create({
        data: {
          name,
          points,
          price,
        },
      });
  
      res.status(201).json(pack);
    } catch (error) {
      console.log(error);
      res.status(500).json({ error: 'Internal server error' });
    }
  };
  export const getAllPacks = async (req: Request, res: Response): Promise<void> => {
    try {
      const packs = await prisma.pack.findMany();
      res.json({ packs });
    } catch (error) {
      console.log(error);
      res.status(500).json({ error: 'Internal server error' });
    }
  };