import { Request, Response } from 'express';
import { PrismaClient } from '@prisma/client';

const prisma = new PrismaClient();

export const getAllCountries = async (req: Request, res: Response): Promise<void> => {
  try {
    const countries = await prisma.country.findMany();
    res.json(countries);
  } catch (error) {
    console.error('Error retrieving countries:', error);
    res.status(500).json({ error: 'Failed to retrieve countries' });
  }
};
