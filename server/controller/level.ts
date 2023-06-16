import { PrismaClient,} from '@prisma/client';
import { Request, Response } from 'express';

const prisma = new PrismaClient();
const updateBadge = async (userId: number, level: number): Promise<void> => {
    try {
      let badgeImage = '';
  
      if (level >= 30 && level < 90) {
        badgeImage = 'https://cdn-icons-png.flaticon.com/128/224/224724.png';
      } else if (level >= 90 && level < 150) {
        badgeImage = 'https://cdn-icons-png.flaticon.com/128/5091/5091841.png';
      } else if (level >= 150 && level < 210) {
        badgeImage = 'https://cdn-icons-png.flaticon.com/128/10484/10484461.png';
      } else if (level >= 210 && level < 270) {
        badgeImage = 'https://cdn-icons-png.flaticon.com/128/2578/2578759.png';
      } else if (level >= 270 && level < 300) {
        badgeImage = 'https://cdn-icons-png.flaticon.com/128/5611/5611117.png';
      } else if (level >= 300) {
        badgeImage = 'https://cdn-icons-png.flaticon.com/128/1959/1959461.png';
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



  