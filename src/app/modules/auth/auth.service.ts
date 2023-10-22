import { User } from '@prisma/client';
import bcrypt from 'bcrypt';
import httpStatus from 'http-status';
import { Secret } from 'jsonwebtoken';
import config from '../../../config';
import ApiError from '../../../errors/ApiError';
import { exclude } from '../../../helpers/excludeField';
import { jwtHelpers } from '../../../helpers/jwtHelpers';
import prisma from '../../../shared/prisma';
import {
  IRefreshTokenResponse,
  IUserLogin,
  IUserLoginResonse,
} from './auth.interface';

const signupUser = async (payload: User) => {
  const { password, ...otherInfo } = payload;

  const hashedPassword = await bcrypt.hash(
    password,
    Number(config.bycrypt_salt_rounds)
  );

  const user = await prisma.user.create({
    data: {
      password: hashedPassword,
      ...otherInfo,
    },
  });
  const result = exclude(user, ['password']);
  return result;
};

// login service
const loginUser = async (payload: IUserLogin): Promise<IUserLoginResonse> => {
  const { email, password } = payload;

  // check if the user exists
  const isUserExists = await prisma.user.findUnique({
    where: {
      email,
    },
  });

  if (!isUserExists) {
    throw new ApiError(httpStatus.NOT_FOUND, 'User does not exists');
  }

  const { id: userId, role } = isUserExists;

  const isPasswordMached = async function (
    givenPassword: string,
    savedPassword: string
  ): Promise<boolean> {
    return bcrypt.compare(givenPassword, savedPassword);
  };

  // check if password is matched
  if (
    isUserExists.password &&
    !(await isPasswordMached(password, isUserExists.password))
  ) {
    throw new ApiError(httpStatus.UNAUTHORIZED, 'Incorrect password');
  }

  // generate access token
  const accessToken = jwtHelpers.generateToken(
    { userId, role },
    config.jwt.secret as Secret,
    config.jwt.expires_in as string
  );

  // generate refresh token
  const refreshToken = jwtHelpers.generateToken(
    { userId, role },
    config.jwt.refresh_secret as Secret,
    config.jwt.refresh_expires_in as string
  );

  return {
    accessToken,
    refreshToken,
  };
};

// refresh token service

const refreshToken = async (token: string): Promise<IRefreshTokenResponse> => {
  let verifiedToken = null;

  // verify refresh token
  try {
    verifiedToken = jwtHelpers.verifyToken(
      token,
      config.jwt.refresh_secret as Secret
    );
  } catch (err) {
    throw new ApiError(httpStatus.FORBIDDEN, 'Invalid refresh token.');
  }

  // check if request user is exits or not
  const { email } = verifiedToken;
  const isUserExists = await prisma.user.findUnique({
    where: {
      email,
    },
  });

  if (!isUserExists) {
    throw new ApiError(httpStatus.NOT_FOUND, 'User does not exists.');
  }

  // generate access token
  const newAccessToken = jwtHelpers.generateToken(
    { id: isUserExists.id, role: isUserExists.role },
    config.jwt.secret as Secret,
    config.jwt.expires_in as string
  );

  return {
    accessToken: newAccessToken,
  };
};

export const AuthService = {
  signupUser,
  loginUser,
  refreshToken,
};
