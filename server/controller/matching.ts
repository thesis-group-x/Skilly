import { Request, Response } from 'express';

import { PrismaClient } from '@prisma/client';

const prisma = new PrismaClient();


class FriendshipController {
  public async createFriendship(req: Request, res: Response): Promise<void> {
    const { requestorId, respondentId } = req.body;

    try {
      const friendship = await prisma.friendship.create({
        data: {
          requestor: { connect: { id: requestorId } },
          respondent: { connect: { id: respondentId } },
        },
      });

      res.status(201).json(friendship);
    } catch (error) {
      res.status(500).json({ error: 'Failed to create friendship' });
    }
  }
//public kif export besh ykoun defined outside the class
  public async getFriendshipRequests(req: Request, res: Response): Promise<void> {
    const { userId } = req.params;

    try {
      const friendshipRequests = await prisma.user
        .findUnique({ where: { uid: userId } })
        .receivedRequests();//builtin function men prisma

      res.json(friendshipRequests);
    } catch (error) {
      res.status(500).json({ error: 'Failed to retrieve friendship requests' });
    }
  }

  public async acceptFriendshipRequest(req: Request, res: Response): Promise<void> {
    const { friendshipId } = req.params;

    try {
      const friendship = await prisma.friendship.update({
        where: { id: parseInt(friendshipId) },
        data: { status: 'ACCEPTED' },
      });

      res.json(friendship);
    } catch (error) {
      res.status(500).json({ error: 'Failed to accept friendship request' });
    }
  }

  public async declineFriendshipRequest(req: Request, res: Response): Promise<void> {
    const { friendshipId } = req.params;

    try {
      const friendship = await prisma.friendship.update({
        where: { id: parseInt(friendshipId) },
        data: { status: 'DECLINED' },
      });

      res.json(friendship);
    } catch (error) {
      res.status(500).json({ error: 'Failed to decline friendship request' });
    }
  }
}

export default FriendshipController;
