import { PrismaClient } from '@prisma/client';
import { Request, Response } from 'express';
import Stripe from 'stripe';

const prisma = new PrismaClient();
const stripe = new Stripe('pk_test_51NJi2oFuE67mowKS98uhEQ3BmNa6FLxQLoGeVaFmGOYnzTqqD9TvGeE3zg00qbE8d3aJlBzMerK47fc4ZkO6HWRb00NGxnL4o9', {
  apiVersion: '2022-11-15',
  timeout: 5000,
});


export const purchasePoints = async (req: Request, res: Response): Promise<void> => {
    const { packId, cardId } = req.body;
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
        },
        include: {
          cards: true,
        },
      });
  
      if (!user) {
        res.status(404).json({ error: 'User not found' });
        return;
      }
  
      const card = user.cards.find((c) => c.id === cardId);
  
      if (!card) {
        res.status(404).json({ error: 'Card not found' });
        return;
      }
  
      
      const amount = pack.price;
  
      
      const paymentIntent = await stripe.paymentIntents.create({
        amount: amount * 100, // Amount in cents
        currency: 'usd',
        payment_method: card.paymentMethodId || undefined,
        confirm: true,
      });

      if (paymentIntent.status === 'succeeded') {
       
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
      } else {
        res.status(500).json({ error: 'Payment failed' });
      }
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