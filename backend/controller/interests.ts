import { Request, Response } from 'express';
import { PrismaClient } from '@prisma/client';

const prisma = new PrismaClient();

// Create a new user

  
// export const createUser = async (req: Request, res: Response) => {
//   const { name, email, address, skills, hobbies,profileImage, phoneNumber } = req.body;

//   try {
//     const user = await prisma.user.create({
//       data: {
//         name,
//         email,
//         address,
//         skills,
//         hobbies,
//         profileImage,
//         phoneNumber,
//         level: 1, 
//       },
//     });

//     res.json({ message: 'User created successfully', user });
//   } catch (error) {
//     console.error('Error creating user:', error);
//     res.status(500).json({ error: 'Internal server error' });
//   }
// };



// Get all users
export const getUserList = async (req: Request, res: Response) => {
  try {
    const users = await prisma.user.findMany();
    res.send(users);
  } catch (error) {
    console.error('Error fetching users:', error);
    res.status(500).json({ error: 'Internal server error' });
  }
};

// Get user interests
export const getUserInterests = async (req: Request, res: Response) => {
  const { userId } = req.params;

  try {
    const user = await prisma.user.findUnique({
      where: { id: Number(userId) },
      select: { hobbies: true, skills: true },
    });

    if (!user) {
      return res.status(404).json({ error: 'User not found' });
    }

    res.json({ interests: { hobbies: user.hobbies, skills: user.skills } });
  } catch (error) {
    console.error('Error fetching user interests:', error);
    res.status(500).json({ error: 'Internal server error' });
  }
};

// Update user interests
export const updateUserInterests = async (req: Request, res: Response) => {
  const { userId } = req.params;
  const { hobbies, skills } = req.body;
  if (!userId || (!hobbies && !skills)) {
    return res.status(400).json({ error: 'Invalid request' });
  }
  try {
    const user = await prisma.user.update({
      where: { id: Number(userId) },
      data: { hobbies, skills },
    });

    res.json({ message: 'Interests updated successfully' , user });
  } catch (error) {
    console.error('Error updating user interests:', error);
    res.status(500).json({ error: 'Internal server error' });
  }
};
