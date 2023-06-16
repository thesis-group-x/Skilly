// import { PrismaClient } from '@prisma/client';
// import { Request, Response } from 'express';
// import Stripe from 'stripe';

// const prisma = new PrismaClient();
// // const stripe = new Stripe('YOUR_STRIPE_SECRET_KEY');

// export const purchasePoints = async (req: Request, res: Response): Promise<void> => {
//   const { packId, cardId } = req.body;

//   try {
//     const pack = await prisma.pack.findUnique({
//       where: {
//         id: packId,
//       },
//     });

//     if (!pack) {
//       res.status(404).json({ error: 'Pack not found' });
//       return;
//     }

//     const user = await prisma.user.findUnique({
//       where: {
//         uid: req.params.uid,
//       },
//       include: {
//         cards: true,
//       },
//     });

//     if (!user) {
//       res.status(404).json({ error: 'User not found' });
//       return;
//     }

//     const card = user.cards.find((c) => c.id === cardId);

//     if (!card) {
//       res.status(404).json({ error: 'Card not found' });
//       return;
//     }

//     // Calculate the amount based on the selected pack's price
//     const amount = pack.price;

//     // Create a payment intent with Stripe
//     const paymentIntent = await stripe.paymentIntents.create({
//       amount: amount * 100, // Amount in cents
//       currency: 'usd',
//       payment_method: card.paymentMethodId,
//       confirm: true,
//     });

//     // Check if the payment was successful
//     if (paymentIntent.status === 'succeeded') {
//       // Update the user's points by incrementing the pack's points
//       await prisma.user.update({
//         where: {
//           uid: req.params.uid,
//         },
//         data: {
//           points: {
//             increment: pack.points,
//           },
//         },
//       });

//       res.json({ success: true, message: 'Points purchased successfully' });
//     } else {
//       res.status(500).json({ error: 'Payment failed' });
//     }
//   } catch (error) {
//     console.log(error);
//     res.status(500).json({ error: 'Error purchasing points' });
//   }
// };
