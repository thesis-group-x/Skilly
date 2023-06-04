import express from 'express';
import dotenv from 'dotenv';
import pgPromise from 'pg-promise';
import { PrismaClient, User } from '@prisma/client';
import { Request, Response } from 'express';

dotenv.config();

const app = express();
const db = pgPromise()(process.env.DATABASE_URL as string); 
const port = process.env.PORT 
const prisma = new PrismaClient();
app.use(express.json());

db.connect()
  .then(() => {
    console.log('Database connected');
    app.listen(port, () => {
      console.log(`Server is running on port ${port}`);
    });
  })
  .catch((error) => {
    console.error('Error connecting to the database:', error);
  });

app.get('/', (req, res) => {
  res.send('Hello, 9lewi');
});


// Get all users
app.get('/api/users', async (req: Request, res: Response) => {
  try {
    const users = await prisma.user.findMany();
    res.send(users);
  } catch (error) {
    console.error('Error fetching users:', error);
    res.status(500).json({ error: 'Internal server error' });
  }
});

// Get user interests
app.get('/api/user/:userId', async (req: Request, res: Response) => {
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
});

// Update user interests
app.post('/api/user/:userId/interests', async (req: Request, res: Response) => {
  const { userId } = req.params;
  const { hobbies, skills } = req.body;

  try {
    const user = await prisma.user.update({
      where: { id: Number(userId) },
      data: { hobbies, skills },
    });

    res.json({ message: 'Interests updated successfully' });
  } catch (error) {
    console.error('Error updating user interests:', error);
    res.status(500).json({ error: 'Internal server error' });
  }
});