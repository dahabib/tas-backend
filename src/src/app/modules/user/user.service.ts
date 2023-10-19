import { User } from '@prisma/client';
import { exclude } from '../../../helpers/excludeField';
import prisma from '../../../shared/prisma';

// Get All Users
const getAllUsers = async () => {
  const users = await prisma.user.findMany();
  const result = exclude(users, ['password']);
  return result;
};

// Get Single User
const getSingleUser = async (id: string) => {
  const user = await prisma.user.findUnique({
    where: {
      id,
    },
  });
  const result = exclude(user, ['password']);
  return result;
};

// Update User Informaiton
const updateUser = async (
  id: string,
  data: Partial<User>
): Promise<User | null> => {
  const result = await prisma.user.update({
    where: {
      id,
    },
    data,
  });

  return result;
};

// Delete a User
const deleteUser = async (id: string) => {
  return await prisma.user.delete({
    where: {
      id,
    },
  });
};

export const UserService = {
  getAllUsers,
  getSingleUser,
  updateUser,
  deleteUser,
};
