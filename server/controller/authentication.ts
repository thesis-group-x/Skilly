import { PrismaClient, User } from '@prisma/client';
import { Request, Response } from 'express';

const prisma = new PrismaClient();

export const createUser = async (req: Request, res: Response): Promise<void> => {
  try {
    const { name, email, uid } = req.body;

    if (!name || !email || !uid) {
      res.status(400).json({ error: "Name, email, uid are required." });
      return;
    }

    const createdUser: User = await prisma.user.create({
      data: {
        name,
        email,
        uid,
        address: '',
        profileImage: '',
        budge: 'https://www.flaticon.com/free-icon/medal_2838625?term=badge&page=2&position=50&origin=tag&related_id=2838625',
        points: 0,
        age: 0,
        gender:'',
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

// export const getUserById = async (req: Request, res: Response): Promise<void> => {
//   try {
//     const userEmail = req.params.id;

//     // if (isNaN(userId)) {
//     //   res.status(400).json({ error: "Invalid user ID." });
//     //   return;
//     // }

//     const user: User | null = await prisma.user.findUnique({
//       where: {
//         email: userEmail,
//       },
//     });

//     if (user) {
//       res.json(user);
//     } else {
//       res.status(404).json({ error: "User not found." });
//     }
//   } catch (error) {
//     console.error(error);
//     res.status(500).json({ error: "An error occurred while fetching the user." });
//   }
// };

export const updateUser = async (req: Request, res: Response): Promise<void> => {
  try {
    const userId = Number(req.params.id);
    const { name, email, address, profileImage, budge, phoneNumber } = req.body;

    if (isNaN(userId)) {
      res.status(400).json({ error: "Invalid user ID." });
      return;
    }

    const existingUser: User | null = await prisma.user.findUnique({
      where: {
        id: userId,
      },
    });

    if (!existingUser) {
      res.status(404).json({ error: "User not found." });
      return;
    }

    const updatedUser: User = await prisma.user.update({
      where: {
        id: userId,
      },
      data: {
        name: name || existingUser.name,
        email: email || existingUser.email,
        address: address || existingUser.address,
        profileImage: profileImage || existingUser.profileImage,
        budge: budge || existingUser.budge,
        phoneNumber: phoneNumber || existingUser.phoneNumber,
      },
    });

    res.json(updatedUser);
  } catch (error) {
    console.error(error);
    res.status(500).json({ error: "An error occurred while updating the user." });
  }
};

export const getUserByUid = async (req: Request, res: Response): Promise<void> => {
  try {
    const uid = req.params.uid; 

    if (!uid) {
      res.status(400).json({ error: "Invalid user UID." });
      return;
    }

    const user: User | null = await prisma.user.findUnique({
      where: {
        uid: uid, 
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


export const getUsers = async (req: Request, res: Response): Promise<void> => {
  try {
    const { searchQuery } = req.query;

    let users: User[];

    if (searchQuery) {
      users = await prisma.user.findMany({
        where: {
          OR: [
            { name: { contains: searchQuery as string, mode: "insensitive" } },
            { email: { contains: searchQuery as string, mode: "insensitive" } },
          ],
        },
      });
    } else {
      users = await prisma.user.findMany();
    }

    res.json(users);
  } catch (error) {
    console.error(error);
    res.status(500).json({ error: "An error occurred while retrieving users." });
  }
};
export const getUserFeedPosts = async (req: Request, res: Response) => {
  const uid = req.params.uid; 

  try {
    const user = await prisma.user.findUnique({
      where: { uid }, 
      include: { posts: true },
    });

    if (user) {
      res.json(user.posts);
    } else {
      res.status(404).json({ error: "User not found." });
    }
  } catch (error) {
    console.error(error);
    res.status(500).json({ error: "An error occurred while fetching the user feed posts." });
  }
};

export const getUserMarketPosts = async (req: Request, res: Response) => {
  const uid = req.params.uid; 

  try {
    const user = await prisma.user.findUnique({
      where: { uid }, 
      include: { PostM: true },
    });

    if (user) {
      res.json(user.PostM);
    } else {
      res.status(404).json({ error: "User not found." });
    }
  } catch (error) {
    console.error(error);
    res.status(500).json({ error: "An error occurred while fetching the user market posts." });
  }
};

export const updateUserByUid = async (req: Request, res: Response): Promise<void> => {
  try {
    const {uid} = req.params ;
    const { name, email, address, profileImage, budge, phoneNumber } = req.body;

    const existingUser: User | null = await prisma.user.findUnique({
      where: {
        uid: uid,
      },
    });

    if (!existingUser) {
      res.status(404).json({ error: "User not found." });
      return;
    }

    const updatedUser: User = await prisma.user.update({
      where: {
        uid: uid,
      },
      data: {
        name: name || existingUser.name,
        email: email || existingUser.email,
        address: address || existingUser.address,
        profileImage: profileImage || existingUser.profileImage,
        budge: budge || existingUser.budge,
        phoneNumber: phoneNumber || existingUser.phoneNumber,
      },
    });

    res.json(updatedUser);
  } catch (error) {
    console.error(error);
    res.status(500).json({ error: "An error occurred while updating the user." });
  }
};