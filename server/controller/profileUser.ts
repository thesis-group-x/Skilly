
import { PrismaClient } from '@prisma/client';
import { Request, Response } from 'express';

const prisma = new PrismaClient();
const updateUser = async (req: Request, res: Response) => {
  const { userId } = req.params;
  const { name, profileImage, details, age, address,gender } = req.body;

  try {
    const user = await prisma.user.update({
      where: { email: userId }, // Use the correct field and provide a valid non-empty string
      data: { name, profileImage, details, age, address,gender},
    });

    res.json({ message: 'User updated successfully', user });
  } catch (error) {
    console.error('Error updating user:', error);
    res.status(500).json({ error: 'Internal server error' });
  }
};

export default updateUser;




