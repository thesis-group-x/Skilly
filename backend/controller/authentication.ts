import { PrismaClient, User } from '@prisma/client';
import { Request, Response } from 'express';

const prisma = new PrismaClient();

export const createUser = async (req: Request, res: Response): Promise<void> => {
  try {
    const { name, email, uid } = req.body;

    if (!name || !email || !uid) {
      res.status(400).json({ error: "Name, email, and uid are required." });
      return;
    }

    const createdUser: User = await prisma.user.create({
      data: {
        name,
        email,
        uid,
        address: '',
        profileImage: '',
        budge: '',
        points: 0,
        skills: [],
        hobbies: [],
        details: '',
        descriptions: '',
        phoneNumber: '',
        level: 0,
        createdAt: new Date().toISOString(),
        isBanned: false,
        isAdmin: false,
      }  // Specify the type explicitly
    });

    res.json(createdUser);
  } catch (error) {
    console.error(error);
    res.status(500).json({ error: "An error occurred while creating the user." });
  }
};
export const getUsers = async (req: Request, res: Response): Promise<void> => {
  try {
    const users = await prisma.user.findMany();
    res.json(users);
  } catch (error) {
    console.error(error);
    res.status(500).json({ error: "An error occurred while retrieving users." });
  }
};

export const getUserById = async (req: Request, res: Response): Promise<void> => {
  try {
    const userId = Number(req.params.id);

    if (isNaN(userId)) {
      res.status(400).json({ error: "Invalid user ID." });
      return;
    }

    const user: User | null = await prisma.user.findUnique({
      where: {
        id: userId,
      },
    });

    if (user) {
      res.json(user);
    } else {
      res.status(404).json({ error: "User not found." });
    }
  } catch (error) {
    console.error(error);
    res.status(500).json({ error: "An error occurred while fetching the user." });
  }
};
