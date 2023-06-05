// import { Request, Response } from 'express';
// import { PrismaClient, User } from '@prisma/client';
// const prisma = new PrismaClient();


// export const createUser = async (req: Request, res: Response): Promise<void> => {
//   try {
//     const newUser: User = {
//       userid: req.body.userid,
//       username: req.body.username,
//       useremail: req.body.useremail,
//     };

//     const createdUser = await prisma.user.create({
//       data: newUser,
//     });

//     res.json(createdUser);
//   } catch (error) {
//     console.error(error);
//     res.status(500).json({ error: "An error occurred while creating the user." });
//   }
// };

