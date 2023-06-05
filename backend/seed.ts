import { PrismaClient } from "@prisma/client";

const prisma = new PrismaClient();

async function seed() {
  try {
    // Insert sample data into User table
    const user = await prisma.user.create({
      data: {
        name: "John Doe",
        email: "john.doe@example.com",
        password: "password123",
        address: "123 Main St",
        profileImage: "profile.jpg",
        budge: "1000",
        points: 10,
        skills: ["JavaScript", "Python"],
        hobbies: ["Reading", "Gaming"],
        details: "Some details about the user",
        descriptions: "Some descriptions",
        phoneNumber: "1234567890",
        level: 1,
      },
    });

    console.log("Sample user inserted:", user);
  } catch (error) {
    console.error("Error seeding data:", error);
  } finally {
    await prisma.$disconnect();
  }
}

seed();
