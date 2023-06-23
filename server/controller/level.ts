import { PrismaClient,} from '@prisma/client';
import { Request, Response } from 'express';


const prisma = new PrismaClient();
const updateBadge = async (userId: number, level: number): Promise<void> => {
    try {
      let badgeImage = '';
  
      if (level >= 30 && level < 90) {
        badgeImage = 'assets/image/224724-removebg-preview.png';
      } else if (level >= 90 && level < 150) {
        badgeImage = 'assets/image/1959461-removebg-preview.png';
      } else if (level >= 150 && level < 210) {
        badgeImage = 'assets/image/2578759-removebg-preview.png';
      } else if (level >= 210 && level < 270) {
        badgeImage = 'assets/image/5091841-removebg-preview.png';
      } else if (level >= 270 && level < 300) {
        badgeImage = 'assets/image/5611117-removebg-preview.png';
      } else if (level >= 300) {
        badgeImage = 'assets/image/9918694-removebg-preview.png';
      }
  
      if (badgeImage !== '') {
        await prisma.user.update({
          where: {
            id: userId,
          },
          data: {
            budge: {
            set: badgeImage,
            },
          },
        });
      }
    } catch (error) {
      console.log(error);
      
    }
  };
  const updateAllBadges = async (): Promise<void> => {
    try {
      const users = await prisma.user.findMany();
  
      for (const user of users) {
        await updateBadge(user.id, user.level);
      }
  
      console.log('Badges updated successfully');
    } catch (error) {
      console.log(error);
    }}
//update kol nhar 
setInterval(updateAllBadges, 86400000);



  