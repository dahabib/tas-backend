import { JwtPayload } from 'jsonwebtoken';
import { exclude } from '../../../helpers/excludeField';
import prisma from '../../../shared/prisma';

// Get profile information
const getProfile = async (user: JwtPayload) => {
  const { userId } = user;
  const result = await prisma.user.findUnique({
    where: {
      id: userId,
    },
  });
  return exclude(result, ['password']);
};

export const ProfileService = {
  getProfile,
};
